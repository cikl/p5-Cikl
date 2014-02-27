use strict;
use warnings;

use inc::Module::Install;
use Getopt::Long;
use Data::Dumper;
require ExtUtils::MakeMaker;

our $DEF_INDEX = 'cikl';
our $DEF_HOST = 'localhost';
our $DEF_PORT = 9200;


###########

name 'cikl-elasticsearch';
version '1.0';
license 'lgpl';

my $opts = parse_cli();

preamble <<EOS
INDEX=$opts->{'es-index'}
EOS
;

postamble <<EOS

create_index:

drop_index:

EOS
;

WriteAll;

sub parse_cli {
  Getopt::Long::Configure ("bundling");
  my $opt = {
    'es-index' => $DEF_INDEX,
    'es-node' => [ ],
  };

  GetOptions(
    $opt,
    'help|?|h',
    'es-node=s@'
    'es-index=s',
  ) or usage();

  usage() if $opt->{help};
  return $opt;
}

sub usage() {
  print STDERR <<USAGE
Usage: perl $0 [options]

Possible options are:

  --es-index=<index>     Use the database <db>. defaults to '$DEF_DBNAME'
  --es-node=<node>       Specify that <node> as a node. Defaults to 
                         'localhost:9200'. May be specified more than once!
  --help                 Print this message and exit

USAGE
;
  exit 1;
}

