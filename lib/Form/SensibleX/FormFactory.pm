package Form::SensibleX::FormFactory;
use Bread::Board;
use Moose;
use Form::Sensible;
use Class::Load qw/load_class/;
use Form::SensibleX::FormFactory::FieldDefinition;
use namespace::autoclean;

has container => (
    isa => 'Bread::Board::Container',
    is  => 'ro',
    lazy => 1,
    default => sub {
        Bread::Board::Container->new( name => 'FormFactory' )
    },
);

has columns => (
    isa        => 'ArrayRef',
    is         => 'ro',
);

has extra_params => (
    isa        => 'HashRef',
    is         => 'ro',
    lazy_build => 1,
);

has form => (
    is => 'ro',
    isa => 'Form::Sensible::Form',
    lazy_build => 1,
);

has request => (
    is => 'ro',
);

has model => (
    is => 'ro',
);

around BUILDARGS => sub {
    my $orig = shift;
    my $self = shift;

    my $args = ref $_[0] && ref $_[0] eq 'HASH' ? $_[0] : {@_};

    my $model   = $args->{model}   || 'DBIC';
    my $request = $args->{request} || 'Catalyst::Request';

    my $model_class   = $model =~ m[^\+]
                      ? ( $model =~ s[^\+][] )
                      : __PACKAGE__ . '::Model::'   . $model
                      ;
    my $request_class = $request =~ m[^\+]
                      ? ( $request =~ s[^\+][] )
                      : __PACKAGE__ . '::Request::' . $request
                      ;

    load_class( $model_class   );
    load_class( $request_class );

# I'm only interested in the instance here
    $args->{model}   = $model_class->new(   delete $args->{model_args}   );
    $args->{request} = $request_class->new( delete $args->{request_args} );

    return $self->$orig($args);
};

sub BUILD {
    my $self = shift;

    my $container = $self->container;

    $container->add_sub_container( $self->model   );
    $container->add_sub_container( $self->request );

    # circular dependecies!! untested!
    $container->add_service(
        Bread::Board::ConstructorInjection->new(
            name         => 'field_factory_manager',
            class        => 'Form::SensibleX::FieldFactory::Manager',
            dependencies => {
                form         => depends_on('plain_form'),
                column_order => depends_on('column_order'),
                model        => depends_on('/Model'),
                request      => depends_on('/Request')
            },
            lifecycle => 'Singleton',
        )
    );
    $container->add_service(
        Bread::Board::Literal->new(
            name  => 'column_order',
            value => $self->columns,
        )
    );
    $container->add_service(
        Bread::Board::Literal->new(
            name  => 'extra_params',
            value => $self->extra_params,
        )
    );
    $container->add_service(
        Bread::Board::BlockInjection->new(
            name         => 'form_definition',
            lifecycle    => 'Singleton',
            dependencies => {
                reflection      => depends_on('/Model/flattened_reflection'),
                extra_params    => depends_on('extra_params'),
                field_factories => depends_on('field_factory_manager'),
            },
            block        => sub {
                my $s = shift;
                my $form_definition = $s->param('reflection');
                my %extra_params    = %{ $s->param('extra_params') };
                my $field_factories = $s->param('field_factories');

                foreach my $field (keys %extra_params) {
                    my $flat_field       = delete $form_definition->{fields}{$field} || +{};

                    my $field_definition = Form::SensibleX::FormFactory::FieldDefinition->new(
                        definition      => $flat_field,
                        extra_params    => $extra_params{$field},
                        name            => $field,
                        field_factories => $field_factories,
                    );

                    if (my $result = $field_definition->get_definition) {
                        $form_definition->{fields}{$field} = $result;
                    }
                }

                return $form_definition;
            },
        )
    );
    $container->add_service(
        Bread::Board::BlockInjection->new(
            name         => 'plain_form',
            lifecycle    => 'Singleton',
            dependencies => [
                depends_on('form_definition'),
            ],
            block        => sub {
                return Form::Sensible->create_form( shift->param('form_definition') );
            },
        )
    );

    $container->add_service(
        Bread::Board::BlockInjection->new(
            name         => 'form',
            lifecycle    => 'Singleton',
            dependencies => [
                depends_on('field_factory_manager'),
            ],
            block        => sub {
                my $s = shift;
                $s->param('field_factory_manager')->add_factories_to_form();
            },
        )
    );
}

sub get_row {
    my $self = shift;
    return $self->container->resolve(service => '/Model/row');
}

sub execute {
    my ( $self, $action ) = @_;

    # sets the value to the form too, using the request params
    if ( $self->container->resolve(service => '/Request/submit') ) {
        return $self->container->get_sub_container('Model')->execute( $action );
    }

    $self->container->resolve(service => '/Model/set_values_from_row');

    return 0;
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=encoding utf8

=head1 NAME

Form::SensibleX::FormFactory - Create Form::Sensible forms

=head1 DESCRIPTION

A smart way to handle form creation, complex fields, and saving them to the
database.

=head1 METHODS

=head2 BUILD

Builds the Bread::Board container.

=head2 get_row

Shortcut to get the row from Bread::Board.

=head2 execute

If the form has been submitted (according to the Request sub-container), save
to the database (using the Model sub-container). Else, load the values into the
form.

=head1 AUTHOR

André Walker <andre@andrewalker.net>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.
