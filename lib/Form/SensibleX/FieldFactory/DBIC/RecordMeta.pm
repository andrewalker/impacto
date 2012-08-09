package Form::SensibleX::FieldFactory::DBIC::RecordMeta;

use Moose;
use Carp;
use List::MoreUtils qw/distinct/;
use Form::Sensible::Field::Text;
use namespace::autoclean;

extends 'Form::SensibleX::FieldFactory::DBIC::Base';

has resultset => (
    is => 'ro',
);

sub _field_class {
    'Form::Sensible::Field::Text'
}

around BUILDARGS => sub {
    my $orig  = shift;
    my $class = shift;

    my %args = $class->_get_buildargs_args(@_);

    $args{resultset} = $args{model}->resolve(service => 'resultset') if $args{model};
    my $metas        = delete $args{metas};

    $args{fields} = [
        map {
            $_->{_ff_name} = $args{name};
            $class->create_field($_)
        } @$metas
    ];

    delete $args{model};
    delete $args{request};

    return $class->$orig(\%args);
};

sub add_field {
    croak 'not implemented';
}

around field_factory_names => sub {
    my $orig = shift;
    my $self = shift;

    return [ distinct @{ $self->$orig(@_) } ];
};

sub execute {
    my ( $self, $row ) = @_;
    my $i = 0;

    foreach my $field (@{ $self->fields }) {
        my $name  = $field->name;
        my $value = $field->value;

        # TODO!
        # {
        #     name  => $name,
        #     value => $value,
        # }
        # shouldn't be hardcoded like this.
        #
        # It should be instead:
        # {
        #     $field->name_column  => $name,
        #     $field->value_column => $value,
        # }
        if ($value) {
            $row->update_or_create_related($field->{_ff_name}, { name => $name, value => $value });
        }
        elsif (my $r = $row->find_related($field->{_ff_name}, { name => $name })) {
            $r->delete;
        }

        $i++;
    }

    return $i > 0;
}

sub get_values_from_row {
    my ( $self, $row ) = @_;

    return {
        map {
            my $name = $_->name;
            $name =>
                ( $row->count_related($_->{_ff_name}, { name => $name }) == 1 )
                ? $row->find_related($_->{_ff_name}, { name => $name })->value
                : ''
                ;
        } @{ $self->fields }
    };
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=encoding utf8

=head1 NAME

Form::SensibleX::FieldFactory::DBIC::RecordMeta

=head1 METHODS

=head1 AUTHOR

André Walker <andre@andrewalker.net>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify it under
the same terms as Perl itself.
