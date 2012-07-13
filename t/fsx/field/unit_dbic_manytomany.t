#!/usr/bin/env perl
use warnings;
use strict;
use utf8;
use Test::More;
use Form::SensibleX::Field::DBIC::ManyToMany;

use FindBin '$Bin';

use lib "$Bin/../../lib";
use Schema;

my $product_rs = Schema->connect("dbi:SQLite:$Bin/../../db/test.db", '', '', { sqlite_unicode => 1 })->resultset(
    'Product'
);

my $field = Form::SensibleX::Field::DBIC::ManyToMany->new(
    name         => 'categories',
    option_label => 'name',
    option_value => 'slug',
    resultset    => $product_rs,
);

isa_ok($field, 'Form::SensibleX::Field::Base::DBICSelect');
isa_ok($field, 'Form::SensibleX::Field::DBIC::ManyToMany');
isa_ok($field, 'Form::Sensible::Field::Select');

is($field->get_rs()->result_source->from, 'category', 'the relationship is correct');
is($field->get_rs($product_rs->find(1))->result_source->from, 'category', 'the relationship is correct from an existing row too');

my $expected = [
    {
        'value' => 'big',
        'name' => 'Big books'
    },
    {
        'value' => 'books',
        'name' => 'Books'
    },
    {
        'value' => 'mag',
        'name' => 'Magazines'
    },
    {
        'value' => 'small',
        'name' => 'Small books'
    }
];

is_deeply($field->options_delegate_get_from_db, $expected, 'expected results');

is_deeply($field->get_values_from_row($product_rs->find(1)), [qw/books small/], 'get_values_from_row: product 1');
is_deeply($field->get_values_from_row($product_rs->find(2)), [qw/big books/], 'get_values_from_row: product 2');
is_deeply($field->get_values_from_row($product_rs->find(3)), [qw/mag/], 'get_values_from_row: product 3');

done_testing();
