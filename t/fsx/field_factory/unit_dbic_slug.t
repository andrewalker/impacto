#!/usr/bin/env perl
use warnings;
use strict;
use utf8;
use Test::More;
use Form::SensibleX::FieldFactory::DBIC::Slug;
use Form::SensibleX::FormFactory::Model::DBIC;
use Bread::Board;
use namespace::autoclean;

use FindBin '$Bin';

use lib "$Bin/../../lib";
use Schema;

my $db = Schema->connect("dbi:SQLite:$Bin/../../db/test.db", '', '', { sqlite_unicode => 1 });
my $cat_rs = $db->resultset(
    'category'
);

sub create_container {
    my $container = container FormFactory => as {
        service column_order => [ qw/slug name/ ];
    };

    $container->add_sub_container(
        Form::SensibleX::FormFactory::Model::DBIC->new(
            resultset => $cat_rs
        )
    );
    return $container;
}

{
    my $container = create_container();

    ok(my $field_factory = Form::SensibleX::FieldFactory::DBIC::Slug->new(
        name          => 'slug',
        field_sources => [ 'name' ],
        model         => $container->get_sub_container('Model'),
    ));
    my $field = $field_factory->fields->[0];
    isa_ok($field, 'Form::Sensible::Field::Text', 'slug field');
    my $row = $cat_rs->new_result({ name => 'Category 1' });

    is($field_factory->prepare_execute($row, { $field->name => $field->value }), 1, 'prepare_execute works');
    is($row->slug, 'category_1', 'slug is correct');
    $row->insert;
}

{
    my $container = create_container();

    ok(my $field_factory = Form::SensibleX::FieldFactory::DBIC::Slug->new(
        name          => 'slug',
        field_sources => [ 'name' ],
        model         => $container->get_sub_container('Model'),
    ));
    my $field = $field_factory->fields->[0];
    isa_ok($field, 'Form::Sensible::Field::Text', 'slug field');
    my $row = $cat_rs->new_result({ name => 'Category 1' });

    is($field_factory->prepare_execute($row, { $field->name => $field->value }), 1, 'prepare_execute works');
    is($row->slug, 'category_1[1]', 'slug is correct');
    $row->insert;
}

{
    my $container = create_container();

    ok(my $field_factory = Form::SensibleX::FieldFactory::DBIC::Slug->new(
        name          => 'slug',
        field_sources => [ 'name' ],
        model         => $container->get_sub_container('Model'),
    ));
    my $field = $field_factory->fields->[0];
    isa_ok($field, 'Form::Sensible::Field::Text', 'slug field');
    my $row = $cat_rs->new_result({ name => 'Category 2' });

    is($field_factory->prepare_execute($row, { $field->name => $field->value }), 1, 'prepare_execute works');
    is($row->slug, 'category_2', 'slug is correct');
    $row->insert;
}

{
    my $container = create_container();

    ok(my $field_factory = Form::SensibleX::FieldFactory::DBIC::Slug->new(
        name          => 'slug',
        field_sources => [ 'name' ],
        model         => $container->get_sub_container('Model'),
    ));
    my $field = $field_factory->fields->[0];
    isa_ok($field, 'Form::Sensible::Field::Text', 'slug field');
    my $row = $cat_rs->new_result({ name => 'Category 1' });

    is($field_factory->prepare_execute($row, { $field->name => $field->value }), 1, 'prepare_execute works');
    is($row->slug, 'category_1[2]', 'slug is correct');
    $row->insert;
}

$cat_rs->search({ slug => { like => 'category_%' } })->delete;

done_testing();
