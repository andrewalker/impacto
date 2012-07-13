#!/usr/bin/env perl
use warnings;
use strict;
use utf8;
use Test::More;
use Form::SensibleX::FieldFactory::DBIC::BelongsTo;
use Form::SensibleX::FormFactory::Model::DBIC;
use Bread::Board;
use namespace::autoclean;

use FindBin '$Bin';

use lib "$Bin/../../lib";
use Schema;

my $db = Schema->connect("dbi:SQLite:$Bin/../../db/test.db", '', '', { sqlite_unicode => 1 });

############################################
#
# TEST PART 1 - Products
# (basic testing with one field)
#
############################################

{
    my $product_rs = $db->resultset(
        'Product'
    );

    my $container = container FormFactory => as {
        service column_order => [ qw/id name supplier cost price/ ];
    };

    $container->add_sub_container(
        Form::SensibleX::FormFactory::Model::DBIC->new(
            resultset => $product_rs
        )
    );


    ok(my $field_factory = Form::SensibleX::FieldFactory::DBIC::BelongsTo->new(
        name         => 'supplier',
        option_label => 'person.name',
        option_value => 'person',
        model        => $container->get_sub_container('Model'),
    ));

    isa_ok($field_factory, 'Form::SensibleX::FieldFactory::DBIC::BelongsTo');
    is($field_factory->field_count, 1, 'one field was created');

    my $field = $field_factory->fields->[0];
    isa_ok($field, 'Form::SensibleX::Field::DBIC::BelongsTo', 'the field');
    is($field->resultset->result_source->from, 'supplier', 'the relationship is guessed correctly');
    $field->value('person4');
    my $row = $product_rs->new_result({});
    ok($field_factory->prepare_execute($row, { supplier => $field->value }), 'prepare_execute returns true');
    is($row->get_column('supplier'), 'person4', 'prepare_execute did what was expected');
    ok($field_factory->execute($row, { supplier => $field }), 'execute returns true');
}

############################################
#
# TEST PART 2 - ProductCategory
# (two fields in the same factory)
#
############################################

{
    my $pc_rs = $db->resultset(
        'ProductCategory'
    );

    my $container = container FormFactory => as {
        service column_order => [ qw/product category/ ];
    };

    $container->add_sub_container(
        Form::SensibleX::FormFactory::Model::DBIC->new(
            resultset => $pc_rs
        )
    );

    ok(my $field_factory = Form::SensibleX::FieldFactory::DBIC::BelongsTo->new(
        name         => 'product',
        option_label => 'name',
        option_value => 'slug',
        model        => $container->get_sub_container('Model'),
    ), 'second factory');

    ok($field_factory->add_field({
        name         => 'category',
        option_label => 'name',
        option_value => 'slug',
    }), 'second field in second factory');

    is($field_factory->field_count, 2, 'both fields are there');

    my $product_field  = $field_factory->fields->[0];
    my $category_field = $field_factory->fields->[1];

    $product_field->value(3);
    $category_field->value('books');

    my $row = $pc_rs->new_result({});

    ok($field_factory->prepare_execute($row, { $product_field->name => $product_field->value, $category_field->name => $category_field->value } ), 'prepare_execute worked');
    is($row->get_column('product'), 3, 'prepare_execute did what was expected on product');
    is($row->get_column('category'), 'books', 'and category');
}

############################################
#
# TEST PART 3 - ProductCategoryComments
# (one field with two values)
#
############################################

{
    my $pcc_rs = $db->resultset(
        'ProductCategoryComment'
    );

    my $container = container FormFactory => as {
        service column_order => [ qw/product category comments/ ];
    };

    $container->add_sub_container(
        Form::SensibleX::FormFactory::Model::DBIC->new(
            resultset => $pcc_rs
        )
    );

    ok(my $field_factory = Form::SensibleX::FieldFactory::DBIC::BelongsTo->new(
        name         => 'product_category',
        option_label => [ qw/product.name category.name/ ],
        option_value => [ qw/product category/ ],
        model        => $container->get_sub_container('Model'),
    ), 'third factory');
    my $field  = $field_factory->fields->[0];

    ok($field->value([ 3, 'books' ]), 'setting the value');
    is_deeply($field->value(), { product => 3, category => 'books' }, 'just to be sure');

    my $row = $pcc_rs->new_result({});

    ok($field_factory->prepare_execute($row, { $field->name => $field->value } ), 'prepare_execute worked');
    is($row->get_column('product'), 3, 'prepare_execute did what was expected on product');
    is($row->get_column('category'), 'books', 'and on category');
}

done_testing();
