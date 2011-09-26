#!/usr/bin/perl
use warnings;
use strict;
use autodie;
use Parse::Dia::SQL;

my ($input, $output) = @ARGV;

my $dia = Parse::Dia::SQL->new(
    file                 => $input,
    db                   => 'postgres',
    ignore_type_mismatch => 1,
    uml                  => 1,
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
