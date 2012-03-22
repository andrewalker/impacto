package Form::SensibleX::FormFactory;
use Moose;
use Form::Sensible;
use Form::SensibleX::Field::FileSelector::CatalystByteA;
use Form::SensibleX::Field::Select::DBIC;
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

    my $model_class   = $model =~ /^\+/
                      ? ( $model =~ s/^\+// )
                      : __PACKAGE__ . '::Model::'   . $model
                      ;
    my $request_class = $request =~ /^\+/
                      ? ( $request =~ s/^\+// )
                      : __PACKAGE__ . '::Request::' . $request
                      ;

    require $model_class;
    $model_class->import;

    require $request_class;
    $request_class->import;

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

        if (delete $field_extra_params{is_file_bytea}) {
            delete $field_definition->{field_type};

            $field_definition->{field_class} = '+Form::SensibleX::Field::FileSelector::CatalystByteA';
        }

        if (delete $field_extra_params{fk}) {
            delete $field_definition->{field_type};

            $field_definition->{field_class} = '+Form::SensibleX::Field::Select::DBIC';
            $field_definition->{resultset}   = $self->model->related_resultset( $field );
        }

        # merge extra params with definition
        $field_definition->{$_} = $field_extra_params{$_} for (keys %field_extra_params);
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
