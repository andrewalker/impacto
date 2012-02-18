#!/usr/bin/env perl
use warnings;
use strict;
use FindBin '$Bin';

my @schemas = qw/'people' 'product' 'finance' 'user_account'/;

create(@ARGV);

sub create {
    my ($db, $user, $password) = @_;

    $db       ||= q{''};
    $user     ||= q{''};
    $password ||= q{''};

    local $" = ",";

    system $Bin . "/impacto_create.pl model DB DBIC::Schema Impacto::Schema " .
        "create=static moniker_parts='schema,name' " .
        "result_base_class='Impacto::DBIC::Result' " .
        "dbi:Pg:dbname=$db $user $password db_schema=[@schemas]";

    my $new_model = "$Bin/../lib/Impacto/Model/DB.pm.new";
    unlink $new_model if -e $new_model;
}
