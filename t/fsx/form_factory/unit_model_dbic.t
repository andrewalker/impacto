#!/usr/bin/env perl
use warnings;
use strict;
use utf8;
use Test::More;
use Bread::Board;
use FindBin '$Bin';
use Schema;
use Form::SensibleX::FormFactory::Model::DBIC;

use lib "$Bin/../../lib";

my $person_rs = Schema->connect("dbi:SQLite:$Bin/../../db/test.db")->resultset(
    'Product'
);

my $container = container FormFactory => as {
    service column_order => [ qw/id name supplier cost price/ ];
};

$container->add_sub_container(
    Form::SensibleX::FormFactory::Model::DBIC->new(
        resultset => $person_rs
    )
);

my $set     = $container->resolve(service => '/Model/resultset');
my $source  = $container->resolve(service => '/Model/result_source');
my $row     = $container->resolve(service => '/Model/row');
my $related = $container->resolve(service => '/Model/related_resultset', parameters => { field => 'supplier' });

# test literal services
isa_ok($set,     'DBIx::Class::ResultSet');
isa_ok($source,  'DBIx::Class::ResultSource');
isa_ok($row,     'DBIx::Class::Row');
isa_ok($related, 'DBIx::Class::ResultSet');

# this proves that the loaded result_source is the one we want
# and that the row and resultset we have also are coherent
is($set->result_source, $source, "result_source matches resultset's result_source");
is($row->result_source, $source, "result_source matches row's result_source");

is($related->result_source->from, 'supplier', "the related resultset is a supplier");

isa_ok($container->resolve(service => '/Model/reflect'), 'Form::Sensible::Form');
my $flattened = $container->resolve( service => '/Model/flattened_reflection');
ok($flattened, "the flattened form is ok");


my $columns = $container->resolve( service => 'column_order' );
push @$columns, 'submit';

is_deeply($flattened->{field_order}, $columns, 'field order is right');
is($flattened->{name}, 'product', 'name is correct');

my %got      = map { $_ => 1 } keys %{ $flattened->{fields} };
my %expected = map { $_ => 1 } @$columns;

is_deeply(\%got, \%expected, 'all the fields are there');

done_testing();
