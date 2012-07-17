package Form::SensibleX::FieldFactory::Manager;
use Moose;
use Class::Load qw/load_class/;
use namespace::autoclean;

has form => (
    isa    => 'Form::Sensible::Form',
    is     => 'ro',
    writer => '_set_form',
);

has column_order => (
    isa => 'ArrayRef',
    is  => 'ro',
);

has model => (
    isa => 'Bread::Board::Container',
    is  => 'ro',
);

has request => (
    isa => 'Bread::Board::Container',
    is  => 'ro',
);

has factories => (
    isa        => 'HashRef',
    is         => 'ro',
    default    => sub { +{} },
    traits     => ['Hash'],
    handles => {
        set_factory   => 'set',
        get_factory   => 'get',
        all_factories => 'values',
    }
);

sub _fix_definition_and_get_class_name {
    my $definition = shift;

    delete $definition->{field_type};
    delete $definition->{field_class};
    delete $definition->{integer_only};

    my $x_field_factory     = delete $definition->{x_field_factory};
    my $field_factory_class = 'Form::SensibleX::FieldFactory::' . $x_field_factory;

    return $field_factory_class;
}

sub init_factory {
    my ($self, $class, $definition) = @_;

    load_class( $class );

    $definition->{model}   = $self->model;
    $definition->{request} = $self->request;

    my $obj = $class->new( $definition );

    $self->set_factory($class, $obj);
}

sub add_to_factory {
    my ($self, $definition) = @_;

    my $class_name = _fix_definition_and_get_class_name($definition);

    if (my $f = $self->get_factory($class_name)) {
        $f->add_field( $definition );
    }
    else {
        $self->init_factory($class_name, $definition);
    }
}

sub add_factories_to_form {
    my ($self, $form) = @_;

    $self->_set_form($form)
        if $form;

    for my $factory_class ($self->all_factories) {
        for my $factory_name (@{ $factory_class->names }) {
            $self->add_factory_to_form(
                $factory_name,
                $factory_class->build_fields($factory_name),
            );
        }
    }

    $form->field_order([ @{ $self->column_order }, 'submit' ]);
}

sub add_factory_to_form {
    my ($self, $factory, $factory_fields) = @_;
    my @fact_field_names;
    my $form = $self->form;

    foreach my $factory_field (@$factory_fields) {
        my ($definition, $name) = @$factory_field;
        push @fact_field_names, $name;
        $form->add_field( $definition, $name );
    }

    $self->_replace_fields($factory, \@fact_field_names);
}

sub _replace_fields {
    my ($self, $needle, $to_insert) = @_;

    my $columns = $self->column_order;

    for my $i ( 0 .. scalar @$columns - 1 ) {
        return splice @$columns, $i, 1, @$to_insert
            if $columns->[$i] eq $needle;
    }
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=encoding utf8

=head1 NAME

Form::SensibleX::FieldFactory::Manager - Manage field factories

=head1 DESCRIPTION

When building a Form::Sensible form object, and having complex field factories
(classes which generate one or more fields, and handle their communication with
the database), this is their manager. It has pointer to each one of them, and
is able to apply them to the form in the end. It's supposed to be used by
L<Form::SensibleX::FormFactory>.

=head1 METHODS

=head2 add_factories_to_form

Run through all the factories in memory and call L</add_factory_to_form> on
them, to apply them on the form.

=head2 add_factory_to_form

Add one factory to the form.

=head2 init_factory

When adding a new instance to a factory class, if it's the first time this
class has been seen, it must be initialized with this method.

=head2 add_to_factory

Add new instance to an initialized factory class, or initialize a new one.

=head2 _replace_fields

=head2 _fix_definition_and_get_class_name

=head1 AUTHOR

André Walker <andre@andrewalker.net>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify it under
the same terms as Perl itself.
