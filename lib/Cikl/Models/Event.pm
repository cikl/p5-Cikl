package Cikl::Models::Event;
use strict;
use warnings;
use Mouse;
use Mouse::Util::TypeConstraints;
use Cikl::DataTypes::LowerCaseStr;
use Cikl::DataTypes::Integer;
use Cikl::DataTypes::PortList;
use Cikl::Models::Observable;
use Cikl::Models::Observables;
use Cikl::ObservableBuilder qw/create_observable/;
use namespace::autoclean;

has 'assessment' => (
  is => 'rw',
  isa => 'Cikl::DataTypes::LowerCaseStr',
  required => 1,
  coerce => 1
);

has 'source' => (is => 'rw');

has 'observables' => (
  is => 'ro',
  isa => 'Cikl::Models::Observables',
  default => sub { Cikl::Models::Observables->new() }
);

has 'detecttime' => (
  is => 'rw',
  isa => "Cikl::DataTypes::Integer",
  coerce => 1
);

has 'reporttime' => (
  is => 'rw',
  isa => "Cikl::DataTypes::Integer",
  coerce => 1
);

has 'alternativeid' => (is => 'rw');
has 'alternativeid_restriction' => (is => 'rw');

has 'md5' => (is => 'rw');
has 'sha1' => (is => 'rw');
has 'sha256' => (is => 'rw');
has 'sha512' => (is => 'rw');

has 'portlist' => (
  is => 'rw',
  isa => 'Cikl::DataTypes::PortList'
);

has 'protocol' => (is => 'rw');
has 'restriction' => (is => 'rw');

has 'cc' => (is => 'rw');
has 'rir' => (is => 'rw');

sub to_hash {
  my $ret = { %{$_[0]} };
  $ret->{observables} = $ret->{observables}->to_hash();
  return $ret;
}

__PACKAGE__->meta->make_immutable;

1;
