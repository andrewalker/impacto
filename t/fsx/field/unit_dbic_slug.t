#!/usr/bin/env perl
use warnings;
use strict;
use utf8;
use Test::More;
use Form::SensibleX::Field::DBIC::Slug;

use FindBin '$Bin';

use lib "$Bin/../../lib";
use Schema;

my $db = Schema->connect("dbi:SQLite:$Bin/../../db/test.db", '', '', { sqlite_unicode => 1 });

my $cat_rs = $db->resultset(
    'Category'
);

my $field = Form::SensibleX::Field::DBIC::Slug->new(
    name         => 'slug',
    resultset    => $cat_rs,
);

isa_ok($field, 'Form::SensibleX::Field::DBIC::Slug');
isa_ok($field, 'Form::Sensible::Field::Text');

{
    is($field->generate_slug('Category 1'), 'category_1', 'generate_slug works');
    $cat_rs->create({ slug => 'category_1', name => 'Category 1' });

    is($field->generate_slug('Category 1'), 'category_1[1]', 'generate_slug works');
    $cat_rs->create({ slug => 'category_1[1]', name => 'Category 1' });

    is($field->generate_slug('Category 2'), 'category_2', 'generate_slug works');
    $cat_rs->create({ slug => 'category_2', name => 'Category 1' });

    is($field->generate_slug('Category 1'), 'category_1[2]', 'generate_slug works');
    $cat_rs->create({ slug => 'category_1[2]', name => 'Category 1' });

    $cat_rs->search({ slug => { like => 'category_%' } })->delete;
}

{
    is($field->generate_slug_and_set_value('Category 1'), 'category_1', 'generate_slug_and_set_value works');
    is($field->value, 'category_1', 'value was set');
    $cat_rs->create({ slug => 'category_1', name => 'Category 1' });

    is($field->generate_slug_and_set_value('Category 1'), 'category_1[1]', 'generate_slug_and_set_value works');
    is($field->value, 'category_1[1]', 'value was set');
    $cat_rs->create({ slug => 'category_1[1]', name => 'Category 1' });

    is($field->generate_slug_and_set_value('Category 2'), 'category_2', 'generate_slug_and_set_value works');
    is($field->value, 'category_2', 'value was set');
    $cat_rs->create({ slug => 'category_2', name => 'Category 1' });

    is($field->generate_slug_and_set_value('Category 1'), 'category_1[2]', 'generate_slug_and_set_value works');
    is($field->value, 'category_1[2]', 'value was set');
    $cat_rs->create({ slug => 'category_1[2]', name => 'Category 1' });

    $cat_rs->search({ slug => { like => 'category_%' } })->delete;
}


{
    my $cat = $cat_rs->find('mag');
    is($field->get_values_from_row($cat), 'mag', 'gets value from row');
}

done_testing();
