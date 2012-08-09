package Form::SensibleX::FieldFactory::DBIC::Slug;

use Moose;
use namespace::autoclean;
use Form::SensibleX::Field::DBIC::Slug;

extends 'Form::SensibleX::FieldFactory::DBIC::Base';

has field_sources => (
    is      => 'ro',
    isa     => 'ArrayRef[Str]',
    default => sub { [] },
    traits  => ['Array'],
    handles => {
        _add_field_source  => 'push',
    }
);

has resultset => (
    is => 'ro',
);

sub _field_class {
    'Form::SensibleX::Field::DBIC::Slug'
}

around BUILDARGS => sub {
    my $orig  = shift;
    my $class = shift;

    my %field_args = $class->_get_buildargs_args(@_);

    $field_args{resultset} = $field_args{model}->resolve(service => 'resultset') if $field_args{model};

    return $class->$orig(
        $class->_field_factory_buildargs(
            field_args   => \%field_args,
            factory_args => {
                resultset     => $field_args{resultset},
                field_sources => [ delete $field_args{field_source} ],
            },
        )
    );
};

around add_field => sub {
    my ( $orig, $self, $args ) = @_;

    $args->{resultset} = $self->resultset;
    $self->_add_field_source(delete $args->{field_source});

    return $self->$orig($args);
};

# form extra params:
# slug => { x_field_factory => 'DBIC::Slug' }

sub prepare_execute {
    my ( $self, $row ) = @_;
    my $i = 0;

    foreach my $field (@{ $self->fields }) {
        my $name    = $field->name;
        my $value   = $field->value
            || $field->generate_slug_and_set_value(
                $row->get_column($self->field_sources->[$i])
            );

        $row->set_column($name => $value);

        $i++;
    }

    return $i > 0;
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=encoding utf8

=head1 NAME

Form::SensibleX::FieldFactory::DBIC::Slug

=head1 DESCRIPTION

See L<Form::SensibleX::Field::DBIC::Slug>.

=head1 METHODS

=head2 prepare_execute

=head1 AUTHOR

André Walker <andre@andrewalker.net>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify it under
the same terms as Perl itself.
