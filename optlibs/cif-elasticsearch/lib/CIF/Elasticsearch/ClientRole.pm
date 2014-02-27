package CIF::Elasticsearch::ClientRole;
use strict;
use warnings;
use Mouse::Role;
use Elasticsearch;
use namespace::autoclean;
use CIF::Elasticsearch::Helpers qw/yyyymmdd/;
use CIF qw/debug/;

has 'index_prefix' => (
  is => 'ro',
  isa => 'Str',
  default => sub { 'cif-' }
);

has 'default_index' => (
  is => 'ro',
  isa => 'Str',
  lazy => 1,
  default => sub { my $self = shift; return $self->index_prefix . yyyymmdd(time()); }
);

has 'nodes' => (
  is => 'ro',
  isa => 'Str',
  default => sub { "localhost:9200" }
);

has 'client' => (
  is => 'ro',
  init_arg => undef,
  lazy => 1,
  builder => '_build_client'
);

sub _build_client {
  my $self = shift;
  my @nodes = split(',', $self->nodes);
  my $e = Elasticsearch->new(
    nodes => \@nodes,
  );

  return $e;
}

sub BUILD {
  my $self = shift;
  $self->update_templates();
}

sub update_templates {
  my $self = shift;
  my $template = {
    template => $self->index_prefix . "*",
    order => 1,
    settings => {
      index => {
        analysis => {
          analyzer => {
            fqdn_analyzer => {
              type => "custom",
              tokenizer => "fqdn_tokenizer",
              filter => [ "lowercase" ]
            },
            lowercase_keyword => {
              type => "custom",
              tokenizer => "keyword",
              filter => [ "lowercase" ]
            }
          },
          tokenizer => {
            fqdn_tokenizer => {
              type => "path_hierarchy",
              reverse => "true",
              delimiter => "."
            }
          }
        }
      }
    },
    mappings => {
      "event" => {
        properties => {
          restriction => { type => "string", analyzer => "lowercase_keyword" },
          assessment => { type => "string", analyzer => "lowercase_keyword"  },
          description => { type => "string", index => "analyzed" },
          source => { type => "string", analyzer => "lowercase_keyword" },
          alternativeid_restriction => { type => "string", index => "not_analyzed" },
          alternativeid => { type => "string", analyzer => "keyword" },

          reporttime => { 
            type => "long", 
            index => "not_analyzed" 
          },
          reporttime_millis => { 
            type => "date"
          },

          detecttime => { 
            type => "long", 
            index => "not_analyzed" 
          },
          detecttime_millis => { 
            type => "date"
          },

          confidence => { type => "integer"},

          group => { type => "string", analyzer => "lowercase_keyword" },

          address => {
            type => "object",
            properties => {
              fqdn => { 
                type => "multi_field",
                fields => {
                  fqdn => {
                    type => "string", 
                    index_analyzer => "fqdn_analyzer",
                    search_analyzer => "lowercase_keyword"
                  },
                  exact => {
                    type => "string",
                    analyzer => "lowercase_keyword"
                  }
                }
              },
              ipv4 => { 
                type => "ip"
              },
              asn => { 
                type => "integer"
              }
            }
          }
        }

      }
    }
  };

  my $response = $self->client->indices->put_template(
    name => 'cif_primary',
    body => $template
  );
  if ($response->{ok} != 1) {
    die "Failed to install Elasticsearch template!";
  }


}

1;


