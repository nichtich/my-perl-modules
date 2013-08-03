#!/usr/bin/perl

use strict;
use v5.10;

use JSON;
use MetaCPAN::API;
use File::Slurp qw(write_file);
use List::MoreUtils qw(uniq);

my $mcpan = MetaCPAN::API->new;

my $search = $mcpan->fetch(
    '/release/_search',
    q => 'author:VOJ',
    filter => 'status:latest',
    fields => 'name',
    size => 100
);

#my $author = $mcpan->author('VOJ');
my @repositories = uniq sort map {
  my $n = $_->{fields}->{name};
  $n =~ s/-[^-]+$//;
  $n;
} @{$search->{hits}->{hits}};

=head1
my @repositories = qw(
    Plack-App-DAIA
    Plack-App-unAPI
    Plack-App-RDF-Files
    Plack-Middleware-Auth-AccessToken
    Plack-Middleware-Negotiate
);
=cut

my %modules;

foreach my $name (@repositories) {
    say $name;

    my $perl_module = $name;
    $perl_module =~ s/-/::/g;

    my $release = eval { $mcpan->release( distribution => $name ) } // { };

    my %module = (
        name    => $name,
        module  => $perl_module,
        release => $release,
    );

    $module{abstract} //= $release->{abstract};

    if ($module{resources}->{repository}->{url}) {
        # TODO: resources.bugtracker.date
    }
    if ($module{resources}->{bugtracker}->{web}) {
        # TODO: resources.bugtracker.issues
    }

    $modules{$name} = \%module;
}

write_file 'modules.json', to_json \%modules, { pretty => 1 };
