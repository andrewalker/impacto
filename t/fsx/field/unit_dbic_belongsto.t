#!/usr/bin/env perl
use warnings;
use strict;
use utf8;
use Test::More;
use Form::SensibleX::Field::DBIC::BelongsTo;

use FindBin '$Bin';

use lib "$Bin/../../lib";
use Schema;

my $supplier_rs = Schema->connect("dbi:SQLite:$Bin/../../db/test.db", '', '', { sqlite_unicode => 1 })->resultset(
    'Supplier'
);

my $field = Form::SensibleX::Field::DBIC::BelongsTo->new(
    name         => 'supplier',
    option_label => 'person.name',
    option_value => 'person',
    resultset    => $supplier_rs,
);

isa_ok($field, 'Form::SensibleX::Field::Base::DBICSelect');
isa_ok($field, 'Form::SensibleX::Field::DBIC::BelongsTo');
isa_ok($field, 'Form::Sensible::Field::Select');

my $broken = Form::SensibleX::Field::DBIC::BelongsTo->new(
    name         => 'supplier',
    option_label => 'person.name',
    option_value => 'person.name',
    resultset    => $supplier_rs,
);

ok(!eval { $broken->options_delegate_get_from_db }, 'value with fk dies');
like($@, qr/foreign key/, 'the message is expected');

my $expected = [
    {
        name  => '--'
    },
    {
        value => 'person1',
        name  => 'André Walker'
    },
    {
        value => 'person4',
        name  => 'Sir André Walker'
    }
];

ok(my $result = $field->options_delegate_get_from_db, 'options delegate gets records');
is_deeply($result, $expected, 'and the results are expected');


# now it gets beautiful
my $tags_rs = Schema->connect("dbi:SQLite:$Bin/../../db/test.db", '', '', { sqlite_unicode => 1 })->resultset(
    'ProductTag'
);

my $tagfield = Form::SensibleX::Field::DBIC::BelongsTo->new(
    name         => 'tag',
    option_label => [ qw/ product.name tag / ],
    option_value => [ qw/ product      tag / ],
    validation   => {
        required => 1,
    },
    resultset    => $tags_rs,
);

my $tagexpected = [
    {
        'value' => 'WzMsImJlYXV0aWZ1bCJd',
        'name' => 'Product 3 - beautiful'
    },
    {
        'value' => 'WzMsImNoZWFwIl0',
        'name' => 'Product 3 - cheap'
    }
];

ok(my $tagresult = $tagfield->options_delegate_get_from_db, 'get tags results from db');
is_deeply($tagresult, $tagexpected, 'the results are correct');

my $tagvalues = [
    {
        'tag'     => 'beautiful',
        'product' => 3,
    },
    {
        'tag'     => 'cheap',
        'product' => 3,
    },
];

is_deeply($tagfield->get_multi_value($tagresult->[0]->{value}), $tagvalues->[0], 'first value ok');
is_deeply($tagfield->get_multi_value($tagresult->[1]->{value}), $tagvalues->[1], 'second value ok');

ok($tagfield->set_selection('WzMsImNoZWFwIl0'), 'set_selection');
is_deeply($tagfield->value, $tagvalues->[1], 'value is right');

ok($tagfield->set_selection('WzMsImJlYXV0aWZ1bCJd'), 'set_selection');
is_deeply($tagfield->value, $tagvalues->[0], 'value is right');

done_testing();
