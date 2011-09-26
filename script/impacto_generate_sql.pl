#!/usr/bin/perl
use warnings;
use strict;
use autodie;
use Parse::Dia::SQL;
use FindBin '$Bin';

my ($input, $output) = @ARGV;

$input = $Bin . '/../uml/db.dia'
    if (!defined $input or $input eq '-');

my $dia = Parse::Dia::SQL->new(
    file                 => $input,
    db                   => 'postgres',
    ignore_type_mismatch => 1,
    uml                  => 1,
    loglevel             => 'ERROR',
);

my $output_fh = *STDOUT;

open $output_fh, '>', $output if defined $output;

print $output_fh "set client_min_messages=warning;\n";

for (split /\n/, $dia->get_sql) {
    next if /drop constraint/i;

    if (/drop table/) {
        s/;/ cascade;/;
        s/drop table/drop table if exists/i;
    }
    elsif (/constraint/) {
        s[constraint [\w\._"]+ ][]i;
    }

    print $output_fh $_ . "\n";
}

close $output_fh;
