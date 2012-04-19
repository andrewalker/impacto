package Form::SensibleX::FormFactory;
use Moose;
use Form::Sensible;
use Class::Load qw/load_class/;
use namespace::autoclean;
use Hash::Merge 'merge';

has field_factories => (
    isa        => 'HashRef',
    is         => 'ro',
    default    => sub { +{} },
    traits     => ['Hash'],
    handles => {
        set_field_factory => 'set',
        get_field_factory => 'get',
    }
);

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

sub BUILD {
    my $self = shift;

    $self->model->_factory(   $self );
    $self->request->_factory( $self );
}

sub _build_form {
    my $self = shift;

    # FIXME: use some sort of cache? CHI?
    # for now, lets comment it to save memory
    # it's too early to worry about it anyway
    # if (defined $self->form_sensible_flattened) {
    #    return Form::Sensible->create_form($self->form_sensible_flattened);
    # }

    my $form_definition = $self->model->reflect( $self->columns )->flatten;
    delete $form_definition->{field_order};
    my @factory_fields;

    foreach my $field (keys %{ $self->extra_params }) {
        $form_definition->{fields}{$field} ||= {};
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
        }

        if ($field_extra_params{x_field_factory}) {
            my $x_field_factory     = delete $field_extra_params{x_field_factory};
            my $field_factory_class = 'Form::SensibleX::FieldFactory::' . $x_field_factory;

            load_class( $field_factory_class );

            $field_definition->{model}   = $self->model;
            $field_definition->{request} = $self->request;
            $field_definition->{name}    = $field;

            my $field_factory = $field_factory_class->new( merge( $field_definition, \%field_extra_params ) );

            push @factory_fields, $field_factory->build_fields;

            $self->set_field_factory($field_factory_class, $field_factory);

            delete $form_definition->{fields}{$field};
        }
        else {
            # merge extra params with definition
            $field_definition->{$_} = $field_extra_params{$_} for (keys %field_extra_params);
        }
    }

    my $form = Form::Sensible->create_form($form_definition);

    my $i = 0;
    my %index = map { $_ => $i++ } @{ $self->columns };

    foreach my $factory_field (@factory_fields) {
        my ($def, $name) = @$factory_field;
        $form->add_field( $def, $name );
    }

    my @columns = @{ $self->columns };
    push @columns, 'submit';
    $form->field_order(\@columns);

    return $form;
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
