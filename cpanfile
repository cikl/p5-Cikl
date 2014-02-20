requires 'AnyEvent', '7.05';
requires 'AnyEvent::RabbitMQ', '1.15';
requires 'Class::Accessor', '0.34';
requires 'Class::Trigger', '0.14';
requires 'Config::Simple', '4.58';
requires 'Coro', '6.31';
requires 'Cwd', '3.40';
requires 'DateTime', '0.70';
requires 'DateTime::Format::DateParse', '0.05';
requires 'DateTime::Format::Strptime', '1.54';
requires 'Digest::MD5', '2.51';
requires 'Digest::SHA', '5.70';
requires 'DynaLoader', '1.13';
requires 'Encode', '2.44';
requires 'File::Spec', '3.40';
requires 'File::Type', "0.22";
requires 'Getopt::Long';
requires 'IO::Uncompress::Unzip', '2.02';
requires 'JSON', '2.53';
requires 'List::MoreUtils', '0.33';
requires 'Log::Dispatch', '2.32';
requires 'LWP::Protocol::https', '6.03';
requires 'LWP::UserAgent', '6.02';
requires 'LWPx::ParanoidAgent', '1.09';
requires 'Mail::RFC822::Address', '0.3';
requires 'MIME::Base64', '3.13';
requires 'MIME::Lite', '3.027';
requires 'Module::Install', '1.06';
requires 'Module::Install::CPANfile', '0.12';
requires 'Module::Pluggable', '3.9';
requires 'Mouse', "2.0.0";
requires 'MouseX::NativeTraits';
requires 'Net::Abuse::Utils', '0.13';
requires 'Net::Abuse::Utils::Spamhaus', '0.04';
requires 'Net::DNS::Match', '0.04';
requires 'Net::Patricia', '1.19';
requires 'Net::RabbitFoot', '1.03';
requires 'Net::SSLeay', '1.43';
requires 'Regexp::Common', '2.122';
requires 'Regexp::Common::net::CIDR', '0.02';
requires 'Storable', '2.27';
requires 'Text::CSV', '1.18';
requires 'Text::CSV_XS';
requires 'Text::Table', '1.127';
requires 'Time::HiRes', '1.972101';
requires 'Try::Tiny', '0.11';
requires 'URI::Escape', '3.31';
requires 'UUID::Tiny', '1.04';
requires 'XML::LibXML', '1.89';

on 'test' => sub {
  requires 'Test::Class', '0.41';
  requires 'Test::Exception', '0.32';
};

on 'develop' => sub {
    requires 'Memory::Usage';
    requires 'Devel::Size';
    requires 'Class::Inspector';
};

feature 'postgres', "Postgres DBI support" => sub {
  requires 'DBD::Pg', '2.19.0';
  requires 'DBI', '1.616';
  requires 'SQL::Abstract', '1.74';
  requires 'SQL::Abstract::More', '1.17';
};

feature 'elasticsearch', "Elasticsearch support" => sub {
  requires 'Elasticsearch';
};
