use strict;
use warnings;
use Test::More tests => 1;
use Path::Class;
use FindBin '$Bin';

my $db_file = file(  $Bin, 'db', 'test.db'  );
my $sql_file = file( $Bin, 'db', 'test.sql' );

unlink $db_file or die "Cannot delete old database: $!" if -f $db_file;

system 'sqlite3', '-init', $sql_file, $db_file, '.q';

ok( -f $db_file, 'DB generated' )
