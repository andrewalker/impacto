#!/usr/bin/env perl
use warnings;
use strict;
use utf8;
use Test::More;
use Form::Sensible;
use Form::SensibleX::FormFactory::FieldDefinition;
use Form::SensibleX::FieldFactory::Manager;
use Test::MockObject;
use Form::SensibleX::FormFactory::Request::Catalyst::Request;
use Form::SensibleX::FormFactory::Model::DBIC;

use Bread::Board;

use FindBin '$Bin';

use lib "$Bin/../../lib";
use Schema;

my $db = Schema->connect("dbi:SQLite:$Bin/../../db/test.db", '', '', { sqlite_unicode => 1 });
my $pc_rs = $db->resultset(
    'ProductCategory'
);

my $req = Test::MockObject->new();
$req->set_isa( 'Catalyst::Request' );
$req->mock( 'method',      sub { 'GET'        } );
$req->mock( 'body_params', sub { +{}          } );
$req->mock( 'upload',      sub { ()           } );

{
    my $container = container FormFactory => as {
        service form => (
            lifecycle => 'Singleton',
            block => sub {
                my $s = shift;
                return Form::Sensible->create_form({
                    name => 'test',
                    fields => [
                        { name => 'name',   field_class => 'Text'    },
                        { name => 'sex',    field_class => 'Text'    },
                        { name => 'age',    field_class => 'Text'    },
                        { name => 'submit', field_class => 'Trigger' },
                    ],
                });
            },
        );
        service column_order => [ qw/name sex file age myfk/ ];
    };

    $container->add_sub_container(
        Form::SensibleX::FormFactory::Request::Catalyst::Request->new(
            req => $req
        )
    );

    $container->add_sub_container(
        Form::SensibleX::FormFactory::Model::DBIC->new(
            resultset => $pc_rs
        )
    );

    my $form = $container->resolve(service => 'form');
    my $manager = Form::SensibleX::FieldFactory::Manager->new(
        model        => $container->get_sub_container('Model'),
        request      => $container->get_sub_container('Request'),
        form         => $form,
        column_order => $container->resolve(service => 'column_order'),
    );

    my $extra_params = {
        age => { field_class      => 'Number' },
        file => { x_field_class   => 'FileSelector::CatalystByteA' },
        product => { x_field_factory => 'DBIC::BelongsTo', option_value => 'id' },
    };

    {
        my $flat = $form->field('age')->flatten;

        ok(exists $flat->{field_type},  'field_type exists');
        is($flat->{field_type}, 'text', 'and it is text');

        ok(my $fd = Form::SensibleX::FormFactory::FieldDefinition->new(
            definition      => $flat,
            extra_params    => $extra_params->{age},
            name            => 'age',
            field_factories => $manager,
        ), 'builds ok');

        ok(my $def = $fd->get_definition(), 'gets definition');

        isa_ok($fd, 'Form::SensibleX::FormFactory::FieldDefinition');
        ok(!exists $def->{field_type}, 'field_type was deleted');
        is($def->{field_class}, 'Number', 'field_class is now Number');
    }

    {
        ok(!eval { Form::SensibleX::Field::FileSelector::CatalystByteA->can('new') }, 'class is not loaded');

        ok(my $fd = Form::SensibleX::FormFactory::FieldDefinition->new(
            definition      => {},
            extra_params    => $extra_params->{file},
            name            => 'file',
            field_factories => $manager,
        ), 'builds ok');

        ok(my $def = $fd->get_definition(), 'gets definition');

        isa_ok($fd, 'Form::SensibleX::FormFactory::FieldDefinition');
        ok(!exists $def->{field_type}, 'field_type was deleted');
        is($def->{field_class}, '+Form::SensibleX::Field::FileSelector::CatalystByteA', 'field_class is correct');
        ok(Form::SensibleX::Field::FileSelector::CatalystByteA->can('new'), 'class is loaded');
    }

    {
        ok(!eval { Form::SensibleX::FieldFactory::DBIC::BelongsTo->can('new') }, 'class is not loaded');

        ok(my $fd = Form::SensibleX::FormFactory::FieldDefinition->new(
            definition      => {},
            extra_params    => $extra_params->{product},
            name            => 'product',
            field_factories => $manager,
        ), 'builds ok');

        ok(!$fd->get_definition(), 'definition is undef because its a factory');

        isa_ok($fd, 'Form::SensibleX::FormFactory::FieldDefinition');
        ok(Form::SensibleX::FieldFactory::DBIC::BelongsTo->can('new'), 'class is loaded');
        is_deeply($manager->get_factory('Form::SensibleX::FieldFactory::DBIC::BelongsTo')->names, [ 'product' ], 'manager got the factory');
    }
}

done_testing();
