#!/usr/bin/env perl
use warnings;
use strict;
use utf8;
use Test::More;
use Form::SensibleX::Field::Base::DBICSelect;

use FindBin '$Bin';

use lib "$Bin/../../lib";
use Schema;

my $person_rs = Schema->connect("dbi:SQLite:$Bin/../../db/test.db")->resultset(
    'Product'
);

my $base_field = Form::SensibleX::Field::Base::DBICSelect->new(
    name                   => 'product',
    option_label           => [ 'name', 'supplier.person.name' ],
    option_label_separator => ', ',
    option_value           => 'id',
    option_sort            => 'id',
    resultset              => $person_rs,
);

isa_ok($base_field, 'Form::SensibleX::Field::Base::DBICSelect');
isa_ok($base_field, 'Form::Sensible::Field::Select');

my $test_option_label = Form::SensibleX::Field::Base::DBICSelect->new(
    name                   => 'product',
    option_value           => [ 'name', 'supplier.person.name' ],
    resultset              => $person_rs,
);

my $test_option_value = Form::SensibleX::Field::Base::DBICSelect->new(
    name                   => 'product',
    option_label           => [ 'name', 'supplier.person.name' ],
    resultset              => $person_rs,
);

my $test_option_array = Form::SensibleX::Field::Base::DBICSelect->new(
    name                   => 'product',
    option_label           => 'name',
    resultset              => $person_rs,
);

my $test_required = Form::SensibleX::Field::Base::DBICSelect->new(
    name                   => 'product',
    option_label           => 'name',
    validation             => {
        required => 1,
    },
    resultset              => $person_rs,
);

my $test_not_required = Form::SensibleX::Field::Base::DBICSelect->new(
    name                   => 'product',
    option_label           => 'name',
    validation             => {
        required => 0,
    },
    resultset              => $person_rs,
);

is_deeply($test_option_label->option_label, $test_option_label->option_value, 'set the unset');

is_deeply($test_option_value->option_value, $test_option_value->option_label, 'set the unset');

is_deeply($test_option_array->option_label, [ 'name' ], 'simple value becomes array');
is_deeply($test_option_array->option_value, [ 'name' ], 'simple value becomes array for unset attr');


my $expected = {
    '+select' => [
        'supplier.person.name'
    ],
    '+as' => [
        'supplier_person_name'
    ],
    'order_by' => 'id',
    'columns' => [
        'name',
        'id',
        'supplier.person'
    ],
    'join' => [
        'supplier.person'
    ],
};

is_deeply($base_field->get_options_to_search, $expected, 'get_options_to_search');

is_deeply([ $test_required->get_first_empty_option ], [], 'required field doens\'t have first empty option');
is_deeply([ $test_not_required->get_first_empty_option ], [ { name => '--' } ], 'optional field does');

done_testing();
