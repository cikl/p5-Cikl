package Cikl::Models::Event;
use strict;
use warnings;
use Mouse;
use Mouse::Util::TypeConstraints;
use Cikl::DataTypes::LowerCaseStr;
use Cikl::DataTypes::Integer;
use Cikl::DataTypes::PortList;
use Cikl::Models::Observable;
use Cikl::ObservableBuilder qw/create_address/;
use namespace::autoclean;

has 'assessment' => (
  is => 'rw',
  isa => 'Cikl::DataTypes::LowerCaseStr',
  required => 1,
  coerce => 1
);

has 'address' => (
  is => 'rw',
  does => 'Cikl::Models::Observable'
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
has 'source' => (is => 'rw');

has 'cc' => (is => 'rw');
has 'rir' => (is => 'rw');

sub to_hash {
  my $ret = { %{$_[0]} };
  if ($ret->{address}) {
    $ret->{address} = $ret->{address}->to_hash();
  }
  return $ret;
}

sub from_hash {
  my $class = shift;
  my $data = shift;
  my $address = $data->{address};
  if ($address) {
    my $type = (keys %$address)[0];
    if ($type) {
      $address = create_address($type, $address->{$type});
      $data->{address} = $address;
    }
  }
  return $class->new($data);
}

__PACKAGE__->meta->make_immutable;

1;
