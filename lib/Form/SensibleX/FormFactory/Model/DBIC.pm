package Form::SensibleX::FormFactory::Model::DBIC;
use Moose;
use Impacto::Form::Sensible::Reflector::DBIC;
use namespace::autoclean;

has row => (
    isa => 'DBIx::Class::Row',
    is  => 'ro',
);

has resultset => (
    isa => 'DBIx::Class::ResultSet',
    is  => 'ro',
);

around BUILDARGS => sub {
    my $orig = shift;
    my $self = shift;

    my $args = ref $_[0] && ref $_[0] eq 'HASH' ? $_[0] : {@_};
    $args->{row} ||= $args->{resultset}->new_result({});

    return $self->$orig($args);
};

sub reflect {
    my ( $self, $columns ) = @_;

    my $source    = $self->resultset->result_source;
    my $reflector = Impacto::Form::Sensible::Reflector::DBIC->new();

    my $form_options = {
        form             => { name => $source->from },
        with_trigger     => 1,
        fieldname_filter => sub { @{ $columns } },
    };

    return $reflector->reflect_from($self->resultset, $form_options);
}

sub set_values_from_row {
    my ( $self, $form ) = @_;

    $form->set_values({ $self->row->get_columns() });
}

sub related_resultset {
    my ( $self, $field ) = @_;
    return $self->resultset->result_source->related_source( $field )->resultset;
}

sub execute {
    my ($self, $form, $action) = @_;

    my $result = $form->validate();

    return 0 if (! $result->is_valid);

    my $values = $form->get_all_values();
    delete $values->{submit};

    for (keys %$values) {
        if (defined $values->{$_} && $values->{$_} eq '') {
            delete $values->{$_};
        }
    }

    my $execute_action = "execute_$action";

    return $self->$execute_action($values);
}

sub execute_create {
    my ( $self, $values ) = @_;

    $self->row->set_columns( $values );
    $self->row->insert;

    return 1;
}

sub execute_update {
    my ( $self, $values ) = @_;

    $self->row->update( $values );

    return 1;
}

__PACKAGE__->meta->make_immutable;

1;
