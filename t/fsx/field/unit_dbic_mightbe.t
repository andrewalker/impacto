#!/usr/bin/env perl
use warnings;
use strict;
use utf8;
use Test::More;
use Form::SensibleX::Field::DBIC::MightBe;

use FindBin '$Bin';

use lib "$Bin/../../lib";
use Schema;

my $db = Schema->connect("dbi:SQLite:$Bin/../../db/test.db", '', '', { sqlite_unicode => 1 });

my $person_rs = $db->resultset(
    'Person'
);

my $field = Form::SensibleX::Field::DBIC::MightBe->new(
    name         => 'supplier',
    display_name => 'Supplier',
    resultset    => $person_rs,
);

isa_ok($field, 'Form::SensibleX::Field::DBIC::MightBe');
isa_ok($field, 'Form::Sensible::Field::Select');

my $expected = [
    {
        'value' => 1,
        'name' => '1'
    },
    {
        'value' => 0,
        'name' => '0'
    },
];

ok(my $result = $field->options, 'options delegate gets option');
is_deeply($result, $expected, 'and the results are expected');

{
    my $person = $person_rs->find('person1');
    is($field->get_values_from_row($person), 1, 'get_values_from_row');
}

{
    my $person = $person_rs->find('person2');
    is($field->get_values_from_row($person), 0, 'get_values_from_row');
}

done_testing();
