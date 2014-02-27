package CIF::Elasticsearch::DataStore;
use strict;
use warnings;
use Mouse;
use CIF::DataStore::Role ();
use CIF::Postgres::SQLRole ();
use CIF::Postgres::DataStoreSQL ();
use CIF::Codecs::JSON ();
use Elasticsearch::Bulk;
use Time::HiRes qw/tv_interval gettimeofday/;
use namespace::autoclean;
use Data::Dumper;
use CIF qw/debug/;
use CIF::Elasticsearch::Helpers qw/event2es es2event yyyymmdd/;

with "CIF::DataStore::Role", 'CIF::Elasticsearch::ClientRole';

has 'pending_count' => (
  is => 'rw',
  traits => ['Counter'],
  init_arg => undef,
  default => 0,
  handles => {
    inc_pending_count => 'inc',
    reset_pending_count => 'reset',
  }
);
has 'last_flush' => (
  is => 'rw',
  init_arg => undef,
  default => sub { [gettimeofday] } 
);

has 'bulk_indexer' => (
  is => 'ro',
  init_arg => undef,
  lazy => 1,
  builder => '_build_bulk_indexer'
);

sub _build_bulk_indexer {
  my $self = shift;
  my $bulk = Elasticsearch::Bulk->new(
    es => $self->client,
    index => '_BULK_DEFAULT_',
    type => "event"
  );
  return $bulk;
}

sub submit { 
  my $self = shift;
  my $submission = shift;
  my $index = $self->index_prefix . yyyymmdd($submission->event->detecttime);
  $self->bulk_indexer->index({ _index => $index, source => event2es($submission->event) });
  $self->inc_pending_count();
  return 1;
}

sub flush {
  my $self = shift;
  my $count = $self->pending_count();
  if ($count == 0) {
    return [];
  }
  # BULK INDEX THE SUBMISSIONS
  $self->bulk_indexer->flush();
  $self->reset_pending_count();

  my $delta = tv_interval($self->last_flush);
  $self->last_flush([gettimeofday]);
  my $rate = $count  / $delta;
  debug("Inserted $count, Submissions per second: $rate");
  return [];
}

after "shutdown" => sub {
  my $self = shift;
};

__PACKAGE__->meta->make_immutable();


1;

