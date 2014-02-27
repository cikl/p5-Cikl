package CIF::Elasticsearch::Helpers;
use strict;
use warnings;
require Exporter;
require CIF::Models::Event;
use POSIX qw/strftime/;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(
event2es
es2event
yyyymmdd
);

use constant EVENT_TIME_FMT => "%F";
sub yyyymmdd {
  strftime(EVENT_TIME_FMT,gmtime(shift))
}

sub event2es {
  my $event = shift;
  my $ret = $event->to_hash;
  $ret->{detecttime_millis} = $ret->{detecttime} * 1000;
  $ret->{reporttime_millis} = $ret->{reporttime} * 1000;
  return $ret;
}

sub es2event {
  my $hash = shift;
  return CIF::Models::Event->from_hash($hash)
}


