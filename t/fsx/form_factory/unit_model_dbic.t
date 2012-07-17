#!/usr/bin/env perl
use warnings;
use strict;
use utf8;
use Test::More;
use Bread::Board;
use Form::Sensible;
use FindBin '$Bin';

use lib "$Bin/../../lib";
use Schema;
use Form::SensibleX::FormFactory::Model::DBIC;
use Form::SensibleX::FormFactory::Request::Catalyst::Request;
use Form::SensibleX::FieldFactory::Manager;
use Test::MockObject;

my $product_rs = Schema->connect("dbi:SQLite:$Bin/../../db/test.db")->resultset(
    'Product'
);

sub create_container {
    my $id = shift;
    my @row;

    if ($id) {
        @row = (row => $product_rs->find($id));
    }
    my $model = Form::SensibleX::FormFactory::Model::DBIC->new(
        resultset => $product_rs, @row,
    );

    my $req = Test::MockObject->new();
    $req->set_isa( 'Catalyst::Request' );
    $req->mock( 'method',      sub { 'GET'        } );
    $req->mock( 'body_params', sub { +{}          } );
    $req->mock( 'upload',      sub { ()           } );
    my $fs_req = Form::SensibleX::FormFactory::Request::Catalyst::Request->new(
        req => $req
    );

    my $form = {
        name => 'test',
        fields => [
            { name => 'id',    field_class => 'Number' },
            { name => 'name',  field_class => 'Text'   },
            { name => 'cost',  field_class => 'Number' },
            { name => 'price', field_class => 'Number' },
        ],
    };

    my $container = container FormFactory => as {
        service column_order => [ qw/id name supplier cost price/ ];
        service form         => (
            lifecycle    => 'Singleton',
            dependencies => [ depends_on('Model/flattened_reflection') ],
            block => sub { Form::Sensible->create_form(shift->param('flattened_reflection')) }
        );
        service field_factory_manager => (
            class        => 'Form::SensibleX::FieldFactory::Manager',
            dependencies => {
                column_order => depends_on('column_order'),
                model        => depends_on('model'),
                request      => depends_on('request'),
            },
            lifecycle => 'Singleton',
        );
        service model => $model;
        service request => $fs_req;
    };

    $container->add_sub_container($model);
    $container->add_sub_container($fs_req);
    return $container;
}

{
    my $container = create_container();

    my $set     = $container->resolve(service => '/Model/resultset');
    my $source  = $container->resolve(service => '/Model/result_source');
    my $row     = $container->resolve(service => '/Model/row');
    my $related = $container->resolve(service => '/Model/related_resultset', parameters => { field => 'supplier' });

    # test literal services
    isa_ok($set,     'DBIx::Class::ResultSet');
    isa_ok($source,  'DBIx::Class::ResultSource');
    isa_ok($row,     'DBIx::Class::Row');
    isa_ok($related, 'DBIx::Class::ResultSet');

    # this proves that the loaded result_source is the one we want
    # and that the row and resultset we have also are coherent
    is($set->result_source, $source, "result_source matches resultset's result_source");
    is($row->result_source, $source, "result_source matches row's result_source");

    is($related->result_source->from, 'supplier', "the related resultset is a supplier");

    isa_ok($container->resolve(service => '/Model/reflect'), 'Form::Sensible::Form');
    my $flattened = $container->resolve( service => '/Model/flattened_reflection');
    ok($flattened, "the flattened form is ok");


    my $columns = $container->resolve( service => 'column_order' );
    push @$columns, 'submit';

    is($flattened->{name}, 'product', 'name is correct');

    my %got      = map { $_ => 1 } keys %{ $flattened->{fields} };
    my %expected = map { $_ => 1 } @$columns;

    is_deeply(\%got, \%expected, 'all the fields are there');
}

my $plain_values = {
    'id'       => 4,
    'name'     => 'Test',
    'cost'     => 5,
    'price'    => 11,
    'supplier' => 'person4',
};

{
    my $container = create_container();

    $container->resolve(service => 'form')->set_values($plain_values);

    ok($container->resolve(service => 'Model/validate_form'), 'form is valid');
    is_deeply($container->resolve(service => 'Model/get_db_values_and_factories_from_form'), {
        plain_values => $plain_values,
        field_factories => {},
    }, 'values are expected');

    is_deeply($container->resolve(service => 'Model/values_from_plain_fields_from_form'), $plain_values, 'plain values are expected');
    is_deeply($container->resolve(service => 'Model/field_factories_from_form'), {}, 'no field factories');

    ok($container->get_sub_container('Model')->execute('create'), 'execute works');
    is($product_rs->find(4)->name, 'Test', 'product was inserted');
}

{
    my $container = create_container(4);

    $plain_values->{cost} = 7;
    $container->resolve(service => 'form')->set_values($plain_values);

    ok($container->resolve(service => 'Model/validate_form'), 'form is valid');
    is_deeply($container->resolve(service => 'Model/get_db_values_and_factories_from_form'), {
        plain_values => $plain_values,
        field_factories => {},
    }, 'values are expected');

    is_deeply($container->resolve(service => 'Model/values_from_plain_fields_from_form'), $plain_values, 'plain values are expected');
    is_deeply($container->resolve(service => 'Model/field_factories_from_form'), {}, 'no field factories');

    ok($container->get_sub_container('Model')->execute('update'), 'execute works');
    is($product_rs->find(4)->name, 'Test', 'product is the same');
    is($product_rs->find(4)->cost, 7, 'cost is updated');
}

$product_rs->find(4)->delete;

{
    my $container = create_container(3);

    eval { $container->resolve(service => 'Model/set_values_from_row') };
    ok(!$@, 'set_values_from_row doesnt die');
    my $form = $container->resolve(service => 'form');
    my $values = $form->get_all_values;

    # nobody cares about the trigger
    delete $values->{submit};
    is_deeply($values, {
      id    => 3,
      cost  => 25,
      name  => 'Product 3',
      price => 50,
      supplier => 'person4',
    }, 'the values in the form are filled accordingly');
}

done_testing();
