use strict;
use warnings;
use Test::More tests => 2;
use Path::Class;
use DBIx::Class::Schema::Loader qw/ make_schema_at /;
use FindBin '$Bin';

my $db_file = file(  $Bin, 'db', 'test.db'  );
my $sql_file = file( $Bin, 'db', 'test.sql' );

unlink $db_file or die "Cannot delete old database: $!" if -f $db_file;

system 'sqlite3', '-init', $sql_file, $db_file, '.q';

ok( -f $db_file, 'DB generated' );

ok(make_schema_at(
    'Schema',
    {
        dump_directory    => "$Bin/lib/",
        result_base_class => 'Impacto::DBIC::Result',
        components        => [ 'InflateColumn::DateTime' ],
    },
    [ 'dbi:SQLite:t/db/test.db' ],
), 'schema generated');
