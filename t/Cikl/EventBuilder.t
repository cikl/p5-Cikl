package TestsFor::Cikl::EventBuilder;
use base qw(Test::Class);
use strict;
use warnings;
use Test::More;

sub startup : Test(startup => 1) {
  use_ok( 'Cikl::EventBuilder' );
}

sub setup : Test(setup) {
  my $self = shift;
  my $builder = Cikl::EventBuilder->new();
  $self->{builder} = $builder;
}

sub test_normalize_empty_hash : Test(3) {
  my $self = shift;
  my $builder = $self->{builder};

  my $r = $builder->normalize({});
  my $count = keys %$r;
  is($count, 2, "it has two keys");
  is($r->{reporttime}, $builder->_now(), "it has a default 'reporttime'");
  is($r->{detecttime}, $builder->_now(), "it has a default 'detecttime'");
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
  ok(!defined($e->address()), "has an undefined address");
}

sub test_build_basic_ipv4 : Test(6) {
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
  isa_ok($e->address(), 'Cikl::Models::Observables::ipv4', "the address is an ipv4");
  is($e->address()->value(), '1.2.3.4', "the address 1.2.3.4");
}
TestsFor::Cikl::EventBuilder->runtests;

