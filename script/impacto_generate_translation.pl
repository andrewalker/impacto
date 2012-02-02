#!/usr/bin/env perl
use warnings;
use strict;
use FindBin '$Bin';
use Impacto;
use Lingua::Translate;
use autodie;

my($lt, $fh);

if (scalar @ARGV >= 1) {
    my $dest = shift @ARGV;
    $lt      = Lingua::Translate->new(
        src => 'en',
        dest => $dest,
    );
}

if (scalar @ARGV >= 1) {
    my $file = shift @ARGV;
    open $fh, '>', $file;
}
else {
    $fh = *STDOUT;
}

my $i = new Impacto();

my @schemas = qw/People Product Finance UserAccount/;
for my $schema (@schemas) {
    for my $table (values %{ $i->model("DB::$schema")->schema->source_registrations }) {
        my $table_name   = $table->from;
        print $fh "# -- $table_name --\n\n";

        my @columns = ($table->columns, 'submit');

        for my $column (@columns) {
            my $display_name = make_display_name( $column );

            print $fh <<"TRANSLATION";
msgid "crud.$table_name.$column"
msgstr "$display_name"

TRANSLATION
        }

        print $fh "\n\n";
    }
}

close $fh;

sub make_display_name {
    my $display_name = shift;
    $display_name =~ s/_/ /g;

    $display_name = $lt->translate( $display_name )
        if defined $lt;

    return ucfirst($display_name);
}
