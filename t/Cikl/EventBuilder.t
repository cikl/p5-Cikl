package TestsFor::Cikl::EventBuilder;
use base qw(Test::Class);
use strict;
use warnings;
use Test::More;
use Test::Deep;

sub startup : Test(startup => 1) {
  use_ok( 'Cikl::EventBuilder' );
}

sub setup : Test(setup) {
  my $self = shift;
  my $builder = Cikl::EventBuilder->new();
  $self->{builder} = $builder;
}

sub test_normalize_empty_hash : Test(4) {
  my $self = shift;
  my $builder = $self->{builder};

  my $r = $builder->normalize({});
  my $count = keys %$r;
  is($count, 3, "it has three keys");
  is($r->{reporttime}, $builder->_now(), "it has a default 'reporttime'");
  is($r->{detecttime}, $builder->_now(), "it has a default 'detecttime'");
  cmp_deeply($r->{observables}, [], "it has an empty 'observables' array");
}

sub test_build_basic : Test(5) {
  my $self = shift;
  my $builder = $self->{builder};

  my $data = {
    assessment => 'whitelist'
  };

  my $e = $builder->build_event($data);
  isa_ok($e, "Cikl::Models::Event", "it's an Event");
  is($e->reporttime(), $builder->_now(), "it has a default 'reporttime'");
  is($e->detecttime(), $builder->_now(), "it has a default 'detecttime'");
  is($e->assessment(), "whitelist", "it has the provided assessment");
  ok($e->observables()->is_empty(), "it has no observables");
}

sub test_build_basic_ipv4 : Test(7) {
  my $self = shift;
  my $builder = $self->{builder};

  my $data = {
    assessment => 'whitelist',
    ipv4 => '1.2.3.4'
  };

  my $e = $builder->build_event($data);
  isa_ok($e, "Cikl::Models::Event", "it's an Event");
  is($e->reporttime(), $builder->_now(), "it has a default 'reporttime'");
  is($e->detecttime(), $builder->_now(), "it has a default 'detecttime'");
  is($e->assessment(), "whitelist", "it has the provided assessment");
  is($e->observables()->count(), 1, "it has one observable");

  isa_ok($e->observables()->ipv4()->[0], 'Cikl::Models::Observables::ipv4', "the address is an ipv4");
  is($e->observables()->ipv4()->[0]->value(), '1.2.3.4', "the address 1.2.3.4");
}
TestsFor::Cikl::EventBuilder->runtests;

