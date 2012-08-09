package Form::SensibleX::FieldFactory::DBIC::BelongsTo;

use Moose;
use namespace::autoclean;
use Form::SensibleX::Field::DBIC::BelongsTo;

extends 'Form::SensibleX::FieldFactory::DBIC::Base';

has model => ( is => 'ro' );

sub _field_class {
    'Form::SensibleX::Field::DBIC::BelongsTo'
}

around BUILDARGS => sub {
    my $orig  = shift;
    my $class = shift;

    my %field_args = $class->_get_buildargs_args(@_);
    my %args;

    $field_args{resultset} = $field_args{model}->resolve(
        service    => 'related_resultset',
        parameters => { field => $field_args{name} },
    );
    $args{model} = $field_args{model};

    return $class->$orig(
        $class->_field_factory_buildargs(
            field_args   => \%field_args,
            factory_args => \%args,
        )
    );
};

around add_field => sub {
    my ( $orig, $self, $args ) = @_;

    $args->{resultset} = $self->model->resolve(
        service    => 'related_resultset',
        parameters => { field => $args->{name} },
    );

    return $self->$orig($args);
};

sub prepare_execute {
    my ( $self, $row ) = @_;
    my $i = 0;

    foreach my $field (@{ $self->fields }) {
        my $value   = $field->value;
        if (ref $value) {
            for my $k (keys %$value) {
                $row->set_column($k => $value->{$k});
            }
        }
        else {
            $row->set_column($field->name => $value);
        }
        $i++;
    }

    return $i > 0;
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=encoding utf8

=head1 NAME

Form::SensibleX::FieldFactory::DBIC::BelongsTo - Foreign keys in the form

=head1 DESCRIPTION

=head1 METHODS

=head2 prepare_execute

=head1 AUTHOR

André Walker <andre@andrewalker.net>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify it under
the same terms as Perl itself.
