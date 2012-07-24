#!/usr/bin/env perl
use warnings;
use strict;
use utf8;
use Test::More;
use Form::SensibleX::FieldFactory::DBIC::RecordMeta;
use Form::SensibleX::FormFactory::Model::DBIC;
use Bread::Board;
use namespace::autoclean;

use FindBin '$Bin';

use lib "$Bin/../../lib";
use Schema;

my $db = Schema->connect("dbi:SQLite:$Bin/../../db/test.db", '', '', { sqlite_unicode => 1 });
my $product_rs = $db->resultset(
    'Product'
);

sub create_container {
    my $row = shift;
    my @row = $row ? (row => $row) : ();
    my $container = container FormFactory => as {
        service column_order => [ qw/id name product_metas/ ];
    };

    $container->add_sub_container(
        Form::SensibleX::FormFactory::Model::DBIC->new(
            @row,
            resultset => $product_rs
        )
    );

    return $container;
}

{
    my $container = create_container();

    ok(my $field_factory = Form::SensibleX::FieldFactory::DBIC::RecordMeta->new(
        name  => 'product_metas',
        metas => [
            { name => 'brand', display_name => 'Brand' },
            { name => 'color', display_name => 'Color' },
        ],
        model => $container->get_sub_container('Model'),
    ), 'build the factory');

    my $bfield = $field_factory->fields->[0];
    isa_ok($bfield, 'Form::Sensible::Field::Text', 'brand field');
    is($bfield->name, 'brand', 'name is correct');
    is($bfield->display_name, 'Brand', 'display name is correct');

    my $cfield = $field_factory->fields->[1];
    isa_ok($cfield, 'Form::Sensible::Field::Text', 'color field');
    is($cfield->name, 'color', 'name is correct');
    is($cfield->display_name, 'Color', 'display name is correct');

    $bfield->value('Impacto');
    $cfield->value('black');

    my $row = $product_rs->new_result({ id => 4, name => 'Product 4', supplier => 'person1', cost => 25, price => 50 });
    $row->insert;

    is($field_factory->execute($row, { $bfield->name => $bfield->value, $cfield->name => $cfield->value }), 1, 'execute works');
    ok(my $brand_row = $row->product_metas->search({ name => 'brand' })->single, 'found the row');
    is($brand_row->name,  'brand', 'meta name');
    is($brand_row->value, 'Impacto', 'meta value');
    ok(my $color_row = $row->product_metas->search({ name =>, 'color' })->single, 'found the row');
    is($color_row->name,  'color', 'meta name');
    is($color_row->value, 'black', 'meta value');
}

{
    my $row = $product_rs->find(4);
    my $container = create_container($row);

    ok(my $field_factory = Form::SensibleX::FieldFactory::DBIC::RecordMeta->new(
        name  => 'product_metas',
        metas => [
            { name => 'brand', display_name => 'Brand' },
            { name => 'color', display_name => 'Color' },
        ],
        model => $container->get_sub_container('Model'),
    ), 'build the factory');

    my $bfield = $field_factory->fields->[0];
    isa_ok($bfield, 'Form::Sensible::Field::Text', 'brand field');
    is($bfield->name, 'brand', 'name is correct');
    is($bfield->display_name, 'Brand', 'display name is correct');

    my $cfield = $field_factory->fields->[1];
    isa_ok($cfield, 'Form::Sensible::Field::Text', 'color field');
    is($cfield->name, 'color', 'name is correct');
    is($cfield->display_name, 'Color', 'display name is correct');

    $cfield->value('grey');
    $bfield->value('Imp2');

    is_deeply($field_factory->get_values_from_row($row,  [qw/brand color/]), { brand => 'Impacto', color => 'black' }, 'values fetched');
    is($field_factory->execute($row, { $bfield->name => $bfield->value, $cfield->name => $cfield->value }), 1, 'execute works');

    ok(my $brand_row = $row->product_metas->search({ name => 'brand' })->single, 'found the row');
    is($brand_row->name,  'brand', 'meta name');
    is($brand_row->value, 'Imp2',  'meta value');
    ok(my $color_row = $row->product_metas->search({ name => 'color' })->single, 'found the row');
    is($color_row->name,  'color', 'meta name');
    is($color_row->value, 'grey',  'meta value');
}

$product_rs->find(4)->product_metas->delete;
$product_rs->find(4)->delete;

done_testing();
