#!/usr/bin/env perl
use warnings;
use strict;
use utf8;
use FindBin '$Bin';
use lib "$Bin/../../lib";
use Schema;
use Test::More;

#my $product_rs = Schema->connect("dbi:SQLite:$Bin/../../db/test.db")->resultset(
#    'Product'
#);

{
    package BrokenTest;
    use Moose;
    use namespace::autoclean;
    extends 'Form::SensibleX::FieldFactory::DBIC::Base';

    __PACKAGE__->meta->make_immutable;
    1;
}

{
    package BaseTest;
    use Moose;
    use namespace::autoclean;
    use Form::Sensible::Field::Text;
    extends 'Form::SensibleX::FieldFactory::DBIC::Base';

    sub _field_class { 'Form::Sensible::Field::Text' }

    around BUILDARGS => sub {
        my $orig = shift;
        my $self = shift;

        return $self->$orig(
            $self->_field_factory_buildargs(
                field_args   => { $self->_get_buildargs_args(@_) },
                factory_args => {},
            )
        );
    };

    __PACKAGE__->meta->make_immutable;
    1;
}

is(BaseTest->_field_class(), 'Form::Sensible::Field::Text', 'making sure our packages are right (BaseTest)');
ok(!BrokenTest->_field_class(), 'same for BrokenTest');

ok(!eval { BrokenTest->create_field({ name => 'broken' }) }, 'BrokenTest breakes');
like($@, qr/_field_class is not defined for BrokenTest/, 'with expected message');

ok(my $working = eval { BaseTest->create_field({ name => 'working' }) }, "BaseTest doesn't break");
isa_ok($working, q/Form::Sensible::Field::Text/);
is($working->{from_factory}, 'BaseTest', 'from_factory is correct');
is($working->{_ff_name}, 'working', '_ff_name too');

my %sample_args = (
    model         => 'x',
    request       => 'y',
    random_number => 27,
    field         => $working,
);

is_deeply({ BaseTest->_get_buildargs_args(%sample_args) }, { BaseTest->_get_buildargs_args(\%sample_args) }, '_get_buildargs_args');

my $field_args = {
    name    => 'mytext',
    model   => 'bogus',
    request => 'bogus',
};

my $factory_args = {
    foo => 'bar',
};

ok(my $result = BaseTest->_field_factory_buildargs(field_args => $field_args, factory_args => $factory_args), '_field_factory_buildargs');
ok(!exists $field_args->{model},   'model was deleted');
ok(!exists $field_args->{request}, 'request was deleted');
is($result->{foo}, 'bar', 'foo is bar');
isa_ok($result->{fields}, 'ARRAY');
is(scalar @{ $result->{fields} }, 1, 'with one element');
isa_ok($result->{fields}->[0], 'Form::Sensible::Field::Text');
is_deeply([ sort keys %$result ], [ qw/fields foo/ ], 'checking the returned hash only has expected keys');

ok(my $instance = BaseTest->new({
    name    => 'btext',
    model   => 'bogus',
    request => 'bogus',
}), 'instance builds ok');

ok($instance->add_field({ name => 'atext' }), 'add_field ok');
is($instance->field_count, 2, 'field_count is correct');
is_deeply([ sort @{ $instance->field_factory_names } ], [ qw/atext btext/ ], 'names are correct');
is($instance->execute, 1, 'base execute returns true');
is($instance->prepare_execute, 1, 'base prepare_execute returns true');

done_testing();
