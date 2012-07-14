#!/usr/bin/env perl
use warnings;
use strict;
use utf8;
use Test::More;
use Bread::Board;
use Form::Sensible;
use FindBin '$Bin';

use lib "$Bin/../../lib";
use Schema;
use Form::SensibleX::FormFactory::Model::DBIC;

my $product_rs = Schema->connect("dbi:SQLite:$Bin/../../db/test.db")->resultset(
    'Product'
);

my $form = Form::Sensible->create_form({
    name => 'test',
    fields => [
        { name => 'id',    field_class => 'Number' },
        { name => 'name',  field_class => 'Text'   },
        { name => 'cost',  field_class => 'Number' },
        { name => 'price', field_class => 'Number' },
    ],
});

my $container = container FormFactory => as {
    service column_order => [ qw/id name supplier cost price/ ];
    service form         => (
        block => sub { $form }
    );
};

$container->add_sub_container(
    Form::SensibleX::FormFactory::Model::DBIC->new(
        resultset => $product_rs
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

is($flattened->{name}, 'product', 'name is correct');

my %got      = map { $_ => 1 } keys %{ $flattened->{fields} };
my %expected = map { $_ => 1 } @$columns;

is_deeply(\%got, \%expected, 'all the fields are there');


# set_values_from_row
# prepare_get_db_values_from_row
# get_db_values_and_factories_from_form
# validate_form

done_testing();
