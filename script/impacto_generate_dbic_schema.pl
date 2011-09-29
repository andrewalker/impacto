#!/usr/bin/env perl
use warnings;
use strict;
use FindBin '$Bin';

my @schemas = qw/people product finance user_account/;
my $schema  = scalar @ARGV > 3 ? pop @ARGV : undef;
my $created = 0;

defined $schema
    ? create($schema, @ARGV) if grep { $_ eq $schema } @schemas
    : map { create($_, @ARGV) } @schemas
    ;

die "Invalid schema\n" unless $created;

sub create {
    my ($schema, $db, $user, $password) = @_;
    my $uc_schema = join( '', map { ucfirst($_) } split('_', $schema) );

    $db       ||= q{''};
    $user     ||= q{''};
    $password ||= q{''};

    system $Bin . "/impacto_create.pl model " .
        "DB::${uc_schema} DBIC::Schema Impacto::Schema::${uc_schema} " .
        "create=static dbi:Pg:dbname=$db $user $password db_schema=$schema";

    my $new_model = "$Bin/../lib/Impacto/Model/${uc_schema}.pm.new";
    unlink $new_model if -e $new_model;

    $created++;
}
