#!/usr/bin/env perl
use warnings;
use strict;
use utf8;
use Test::More;
use Form::SensibleX::FormFactory::FieldDefinition;
use Form::Sensible;
use Test::MockObject;

my $form = Form::Sensible->create_form({
    name => 'test',
    fields => [
        { name => 'name',   field_class => 'Text'    },
        { name => 'sex',    field_class => 'Text'    },
        { name => 'age',    field_class => 'Text'    },
        { name => 'submit', field_class => 'Trigger' },
    ],
});

my $extra_params = {
    age => { field_class => 'Number' },
};

my $flat = $form->field('age')->flatten;

ok(exists $flat->{field_type},  'field_type exists');
is($flat->{field_type}, 'text', 'and it is text');

# TODO
my $factory = Test::MockObject->new;
$factory->mock('model',             sub { 1 });
$factory->mock('request',           sub { 1 });
$factory->mock('set_field_factory', sub { 1 });
$factory->mock('get_field_factory', sub { 1 });

my $fd = Form::SensibleX::FormFactory::FieldDefinition->new(
    definition   => $flat,
    extra_params => $extra_params->{age},
    name         => 'age',
    _factory     => $factory,
);

my $def = $fd->get_definition();

isa_ok($fd, 'Form::SensibleX::FormFactory::FieldDefinition');
ok(!exists $def->{field_type}, 'field_type was deleted');
is($def->{field_class}, 'Number', 'field_class is now Number');

done_testing();
