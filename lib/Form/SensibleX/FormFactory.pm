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

has path_to_forms => (
    isa        => 'Str',
    is         => 'ro',
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

    $container->add_service(
        Bread::Board::ConstructorInjection->new(
            name         => 'field_factory_manager',
            class        => 'Form::SensibleX::FieldFactory::Manager',
            dependencies => {
                column_order => depends_on('column_order'),
                model        => depends_on('model'),
                request      => depends_on('request'),
            },
            lifecycle => 'Singleton',
        )
    );

    # XXX: kludge!
    $container->add_service(
        Bread::Board::Literal->new(
            name  => 'request',
            value => $self->request,
        )
    );
    $container->add_service(
        Bread::Board::Literal->new(
            name  => 'model',
            value => $self->model,
        )
    );

    $container->add_service(
        Bread::Board::Literal->new(
            name  => 'path_to_forms',
            value => $self->path_to_forms,
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
            name         => 'set_field_factories',
            lifecycle    => 'Singleton',
            dependencies => {
                extra_params    => depends_on('extra_params'),
                mgr             => depends_on('field_factory_manager'),
            },
            block        => sub {
                my $s = shift;
                my %extra_params    = %{ $s->param('extra_params') };
                my $mgr             = $s->param('mgr');

                foreach my $field (keys %extra_params) {
                    my $field_definition = Form::SensibleX::FormFactory::FieldDefinition->new(
                        definition      => {},
                        extra_params    => $extra_params{$field},
                        name            => $field,
                        field_factories => $mgr,
                    );

                    $field_definition->merge_definition;
                    $field_definition->check_field_factory;
                }
            },
        )
    );

    $container->add_service(
        Bread::Board::BlockInjection->new(
            name         => 'form_name',
            dependencies => [
                depends_on('/Model/result_source'),
            ],
            block        => sub {
                my $s = shift;
                return $s->param('result_source')->from;
            },
            lifecycle    => 'Singleton',
        )
    );
}

sub get_row {
    my $self = shift;

    my $c      = $self->container->get_sub_container('Model');
    my $row    = $c->resolve(service => 'complete_row');
    my $rs     = $c->resolve(service => 'resultset');

    # $row->id returns the primary keys for the recently added row
    # so I fetch the $row again from the database.
    # I do this because otherwise some inflated fields (dates, etc),
    # or fields formatted from the RDBMS such as money are not correctly
    # inflated for ElasticSearch.
    return $rs->find($row->id);
}

sub execute {
    my ( $self, $action ) = @_;

    # sets the value to the form too, using the request params
    if ( $self->container->resolve(service => '/Request/submit') ) {
        my $ok = $self->container->get_sub_container('Model')->execute( $action );
        if (!$ok) {
            die "Execute failed";
        }
        return $ok;
    }

#    $self->container->resolve(service => '/Model/set_values_from_row');

    return 0;
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=encoding utf8

=head1 NAME

Form::SensibleX::FormFactory - Create Form::Sensible forms

=head1 SYNOPSYS

    # in MyApp::Controller::Product
    my $form_factory = Form::SensibleX::FormFactory->new(
        controller_name => ref $self,
        columns         => [ qw/name supplier category size weight price description/ ],
        extra_params    => {
            supplier => { x_field_factory => 'DBIC::BelongsTo', option_label => 'name', option_value => 'id' },
            category => { x_field_factory => 'DBIC::BelongsTo', option_label => 'name', option_value => 'id' },
        },
        request_args    => { req => $ctx->req },
        model_args      => {
            resultset => $ctx->model('DBIC')->resultset('Product'),
        },
    );

    # when updating
    if ( $form_factory->execute('update') ) {
        return $ctx->res->redirect(
            $ctx->uri_for( $self->action_for( 'successfuly_updated' ) )
        );
    }

    # when inserting
    if ( $form_factory->execute('create') ) {
        return $ctx->res->redirect(
            $ctx->uri_for( $self->action_for( 'successfuly_created' ) )
        );
    }

    # or simply
    $ctx->stash(
        form => $form_factory->get_form,
    );

=head1 DESCRIPTION

A smart way to handle form creation, complex fields, and saving them to the
database.

=head1 METHODS

=head2 BUILD

Builds the Bread::Board container.

=head2 get_row

Shortcut to get the row from Bread::Board.

=head2 get_form

Shortcut to get the form from Bread::Board.

=head2 execute

If the form has been submitted (according to the Request sub-container), save
to the database (using the Model sub-container). Else, load the values into the
form.

=head1 SERVICES IN THE CONTAINER

=head2 model

Returns the model attribute, a class which is also a sub-container called
"Model".

=head2 request

Returns the request attribute, a class which is also a sub-container called
"Request".

=head2 column_order

The columns in the database in the desired order to be printed in the form.

=head2 extra_params

Any extra parameters to be merged with the form definition automatically
generated using the schema.

=head2 field_factory_manager

A class which handles all the field factories applied to the form.

=head2 form_definition

The final hash which will be handed to Form::Sensible to create the form.

=head2 form_without_factories

The object returned by Form::Sensible->create_form, before the factories are
applied.

=head2 form

The final form object, with all the bells and whistles.

=head1 AUTHOR

André Walker <andre@andrewalker.net>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify it under
the same terms as Perl itself.
