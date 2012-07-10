#!/usr/bin/env perl
use warnings;
use strict;
use utf8;
use Test::More;
use Form::SensibleX::FormFactory::Request::Catalyst::Request;
use Test::MockObject;
use Bread::Board;
use Form::Sensible;

my $BODY_PARAMS = {
    name => 'André',
    sex  => 'Male',
    age  => 21,
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
    };

    $container->add_sub_container(
        Form::SensibleX::FormFactory::Request::Catalyst::Request->new(
            req => $req
        )
    );

    my $is_post = $method eq 'POST' ? 1 : 0;
    use Data::Dumper;
    use feature 'say';
    is($container->resolve(service => '/Request/submit'), $is_post, "Submit is $is_post when method is $method");
    if ($is_post) {
        my $values = $container->resolve(service => 'form')->get_all_values;
        my %expected = %{ $BODY_PARAMS };
        $expected{submit} = undef;

        is_deeply($values, \%expected, 'All values are set');
    }
}


done_testing();
