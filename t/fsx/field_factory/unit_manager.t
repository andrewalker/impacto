#!/usr/bin/env perl
use warnings;
use strict;
use utf8;
use Test::More;

use Form::Sensible;

use Form::SensibleX::FieldFactory::Manager;

use Form::SensibleX::FormFactory::Model::DBIC;
use Form::SensibleX::FormFactory::Request::Catalyst::Request;

use Test::MockObject;

use Bread::Board;

use FindBin '$Bin';

use lib "$Bin/../../lib";
use Schema;
use namespace::autoclean;

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
                        { name => 'submit', field_class => 'Trigger' },
                    ],
                });
            },
        );
        service column_order => [ qw/product category/ ];
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

    ok(my $manager = Form::SensibleX::FieldFactory::Manager->new(
        model        => $container->get_sub_container('Model'),
        request      => $container->get_sub_container('Request'),
        column_order => $container->resolve(service => 'column_order'),
    ), 'it builds');

    isa_ok($manager, 'Form::SensibleX::FieldFactory::Manager');
    ok($manager->add_to_factory({ name => 'product',  option_value => 'id', option_label => 'name', x_field_factory => 'DBIC::BelongsTo'  }), 'add_to_factory ok');
    is_deeply([ keys %{ $manager->factories } ], [ 'Form::SensibleX::FieldFactory::DBIC::BelongsTo' ], 'added');
    is_deeply($manager->get_factory('Form::SensibleX::FieldFactory::DBIC::BelongsTo')->field_factory_names, [ 'product' ], 'product added');
    ok($manager->add_to_factory({ name => 'category', option_value => 'slug', option_label => 'name', x_field_factory => 'DBIC::BelongsTo'  }), 'add_to_factory ok');
    is_deeply([ keys %{ $manager->factories } ], [ 'Form::SensibleX::FieldFactory::DBIC::BelongsTo' ], 'still only one factory class');
    is_deeply($manager->get_factory('Form::SensibleX::FieldFactory::DBIC::BelongsTo')->field_factory_names, [ 'product', 'category' ], 'both names were added');

    ok($manager->add_factories_to_form( $container->resolve(service => 'form') ), 'added to form ok');
    is_deeply([ $container->resolve(service => 'form')->fieldnames ], [ 'product', 'category', 'submit' ], 'the names are right');
}

done_testing();
