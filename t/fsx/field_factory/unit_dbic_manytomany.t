#!/usr/bin/env perl
use warnings;
use strict;
use utf8;
use Test::More;
use Form::SensibleX::FieldFactory::DBIC::ManyToMany;
use Form::SensibleX::FormFactory::Model::DBIC;
use Bread::Board;
use namespace::autoclean;

use FindBin '$Bin';

use lib "$Bin/../../lib";
use Schema;

my $db = Schema->connect("dbi:SQLite:$Bin/../../db/test.db", '', '', { sqlite_unicode => 1 });

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

    ok(my $field_factory = Form::SensibleX::FieldFactory::DBIC::ManyToMany->new(
        name         => 'categories',
        option_label => 'name',
        option_value => 'slug',
        model        => $container->get_sub_container('Model'),
    ));

    isa_ok($field_factory, 'Form::SensibleX::FieldFactory::DBIC::ManyToMany');
    is($field_factory->field_count, 1, 'one field was created');

    my $field = $field_factory->fields->[0];
    isa_ok($field, 'Form::SensibleX::Field::DBIC::ManyToMany', 'the field');
    is($field->resultset->result_source->from, 'product', 'the table is correct');
    ok($field->value([qw/small big/]), 'setting the value');

    my $row = $product_rs->find(3);

    ok($field_factory->execute($row, { $field->name => $field->value }), 'execute returns true');
    is_deeply(
        [ sort map { $_->get_column('slug') } $product_rs->find(3)->categories ],
        [ qw/big small/ ],
        'it was applied to the database',
    );

    # returning to the original
    ok($field->value([qw/mag/]), 'setting the value');

    ok($field_factory->execute($row, { $field->name => $field->value }), 'execute returns true');
    is_deeply(
        [ map { $_->get_column('slug') } $product_rs->find(3)->categories ],
        [ qw/mag/ ],
        'it was applied to the database',
    );

}

done_testing();
