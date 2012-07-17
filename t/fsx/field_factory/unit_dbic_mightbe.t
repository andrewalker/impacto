#!/usr/bin/env perl
use warnings;
use strict;
use utf8;
use Test::More;
use Form::SensibleX::FieldFactory::DBIC::MightBe;
use Form::SensibleX::FormFactory::Model::DBIC;
use Bread::Board;
use namespace::autoclean;

use FindBin '$Bin';

use lib "$Bin/../../lib";
use Schema;

my $db = Schema->connect("dbi:SQLite:$Bin/../../db/test.db", '', '', { sqlite_unicode => 1 });
my $person_rs = $db->resultset(
    'Person'
);


{
    my $container = container FormFactory => as {
        service column_order => [ qw/slug name birthday supplier/ ];
    };

    $container->add_sub_container(
        Form::SensibleX::FormFactory::Model::DBIC->new(
            resultset => $person_rs
        )
    );


    ok(my $field_factory = Form::SensibleX::FieldFactory::DBIC::MightBe->new(
        name         => 'supplier',
        display_name => 'Supplier',
        model        => $container->get_sub_container('Model'),
    ), 'creates the object');

    isa_ok($field_factory, 'Form::SensibleX::FieldFactory::DBIC::MightBe');
    is($field_factory->field_count, 1, 'one field was created');

    my $field = $field_factory->fields->[0];
    isa_ok($field, 'Form::SensibleX::Field::DBIC::MightBe', 'the field');

    $field->value(1);

    is($field_factory->execute($person_rs->find('person2'), { $field->name => $field->value }), 1, 'execute ok');
    is($person_rs->find('person2')->count_related('supplier'), 1, 'it was saved in the db');
}

{
    my $container = container FormFactory => as {
        service column_order => [ qw/slug name birthday supplier/ ];
    };

    $container->add_sub_container(
        Form::SensibleX::FormFactory::Model::DBIC->new(
            resultset => $person_rs
        )
    );

    ok(my $field_factory = Form::SensibleX::FieldFactory::DBIC::MightBe->new(
        name         => 'supplier',
        display_name => 'Supplier',
        model        => $container->get_sub_container('Model'),
    ), 'creates the object');

    isa_ok($field_factory, 'Form::SensibleX::FieldFactory::DBIC::MightBe');
    is($field_factory->field_count, 1, 'one field was created');

    my $field = $field_factory->fields->[0];
    isa_ok($field, 'Form::SensibleX::Field::DBIC::MightBe', 'the field');

    is($field_factory->execute($person_rs->find('person2'), { $field->name => $field->value }), 1, 'execute ok');
    is($person_rs->find('person2')->count_related('supplier'), 0, 'it was saved in the db');
}

done_testing();
