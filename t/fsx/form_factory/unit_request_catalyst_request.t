#!/usr/bin/env perl
use warnings;
use strict;
use utf8;
use Test::More;
use Form::SensibleX::FormFactory::Request::Catalyst::Request;
use Test::MockObject;

my $BODY_PARAMS = {
    name   => 'André',
    sex    => 'Male',
    age    => 21,
    submit => 1,
};

test_method('GET');
test_method('POST');

sub test_method {
    my $method = shift;

    my $req = Test::MockObject->new();
    $req->set_isa( 'Catalyst::Request' );
    $req->mock( 'method',      sub { $method      } );
    $req->mock( 'body_params', sub { $BODY_PARAMS } );
    $req->mock( 'upload',      sub { ()           } );

    my $container = Form::SensibleX::FormFactory::Request::Catalyst::Request->new(
        req => $req
    );

    my $is_post = ($method eq 'POST');
    is($container->resolve(service => 'submit'), $is_post, "Submit is $is_post when method is $method");
    if ($is_post) {
        my $values = $container->resolve(service => 'form_values');
        my %expected = %{ $BODY_PARAMS };
        delete $expected{submit};

        is_deeply($values, \%expected, 'All values are set');
    }
}


done_testing();
