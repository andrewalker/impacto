package Form::SensibleX::FormFactory;
use Moose;
use Form::Sensible;
use Class::Load qw/load_class/;
use namespace::autoclean;

has columns => (
    isa        => 'ArrayRef',
    is         => 'ro',
    lazy_build => 1,
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

sub _build_form {
    my $self = shift;

    # FIXME: use some sort of cache? CHI?
    # for now, lets comment it to save memory
    # it's too early to worry about it anyway
    # if (defined $self->form_sensible_flattened) {
    #    return Form::Sensible->create_form($self->form_sensible_flattened);
    # }

    my $form_definition = $self->model->reflect( $self->columns )->flatten;

    foreach my $field (keys %{ $self->extra_params }) {
        my $field_definition   = $form_definition->{fields}{$field};
        my %field_extra_params = %{ $self->extra_params->{$field} };

        if ($field_extra_params{field_class}) {
            delete $field_definition->{field_type};
        }

        if ($field_extra_params{x_field_class}) {
            delete $field_definition->{field_type};

            my $x_field_class = delete $field_extra_params{x_field_class};
            my $field_class   = 'Form::SensibleX::Field::' . $x_field_class;
            $field_definition->{field_class} = '+' . $field_class;

            load_class( $field_class );

            # FIXME: not so cool. maybe bread::board could help
            if ($field_class->can('x_field_dependencies')) {
                for (@{ $field_class->x_field_dependencies }) {
                    $field_definition->{$_} = $self->$_;
                }
            }
        }

        if ($field_extra_params{x_field_factory}) {
            my $x_field_factory     = delete $field_extra_params{x_field_factory};
            my $field_factory_class = 'Form::SensibleX::FieldFactory::' . $x_field_factory;

            load_class( $field_factory_class );

            my $field_factory = $field_factory_class->new($field_definition)

            # FIXME: it's ugly, but it's just an idea
            for my $f ( $field_factory->build_fields ) {
                $form_definition->{fields}->{shift @$f} = {@$f};
            }

            delete $form_definition->{fields}{$field};
        }
        else {
            # merge extra params with definition
            $field_definition->{$_} = $field_extra_params{$_} for (keys %field_extra_params);
        }
    }

    return Form::Sensible->create_form($form_definition);
}

sub get_row {
    my $self = shift;
    return $self->model->row;
}

sub execute {
    my ( $self, $action ) = @_;

    # sets the value to the form too, using the request params
    if ( $self->request->submit( $self->form ) ) {
        return $self->model->execute( $self->form, $action );
    }

    $self->model->set_values_from_row( $self->form );

    return 0;
}

__PACKAGE__->meta->make_immutable;

1;
