#!/usr/bin/env perl
use warnings;
use strict;
use FindBin '$Bin';
use HTML::FormHandler::Generator::DBIC;
use File::Util;
use 5.010;

my @schemas = qw/People Product Finance UserAccount/;
my $f = File::Util->new;

for my $schema (@schemas) {
    say "Schema: $schema";
    $f->make_dir("$Bin/../lib/Impacto/Form/$schema", 0755, '--if-not-exists');

    my @results = $f->list_dir("$Bin/../lib/Impacto/Schema/$schema/Result/", '--no-fsdots');
    for my $result (@results) {
        $result =~ s[\.pm$][];
        print "\t$result";
        my $obj = HTML::FormHandler::Generator::DBIC->new(
            rs_name => $result,
            schema_name => "Impacto::Schema::$schema",
            db_dsn => 'dbi:Pg:dbname=test',
        );
        $f->write_file(
            file => "$Bin/../lib/Impacto/Form/$schema/$result.pm",
            content => $obj->generate_form,
        );
        say " - done";
    }
}
