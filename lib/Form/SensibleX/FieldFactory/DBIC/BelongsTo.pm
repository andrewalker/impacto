package Form::SensibleX::FieldFactory::DBIC::BelongsTo;

use Moose;
use namespace::autoclean;
use Form::SensibleX::Field::DBIC::BelongsTo;

extends 'Form::SensibleX::FieldFactory::DBIC::Base';

has model => ( is => 'ro' );

around BUILDARGS => sub {
    my $orig  = shift;
    my $class = shift;

    my %field_args = ref $_[0] && ref $_[0] eq 'HASH' ? %{$_[0]} : @_;
    my %args;

    $field_args{resultset} = $field_args{model}->related_resultset( $field_args{name} );
    $args{model} = $field_args{model};
    delete $field_args{model};
    delete $field_args{request};

    $args{names}  = [ $field_args{name} ];
    $args{fields} = [ Form::SensibleX::Field::DBIC::BelongsTo->new(%field_args) ];
    $args{fields}->[0]->{from_factory} = __PACKAGE__;
    $args{fields}->[0]->{_fname}       = $field_args{name};

    return $class->$orig(%args);
};

sub add_field {
    my ( $self, $args ) = @_;

    $args->{resultset} = $self->model->related_resultset( $args->{name} );
    my $field = Form::SensibleX::Field::DBIC::BelongsTo->new($args);
    $field->{from_factory} = __PACKAGE__;
    $field->{_fname}       = $args->{name};
    $self->_add_field($field);
    $self->add_name($args->{name});

    return 1;
}

sub prepare_execute {
    my ( $self, $row, $fields ) = @_;
    my $i = 0;

    foreach my $keys (values %$fields) {
        my $value   = $self->fields->[$i]->value;
        if (ref $value) {
            for my $k (keys %$value) {
                $row->set_column($k => $value->{$k});
            }
        }
        else {
            $row->set_column($self->fields->[$i]->name => $value);
        }
        $i++;
    }

    return $i > 0;
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=head1 NAME

Form::SensibleX::FieldFactory::DBIC::BelongsTo - Foreign keys in the form

=head1 DESCRIPTION

=head1 METHODS

=head2 prepare_execute

=head2 add_field

=head1 AUTHOR

André Walker <andre@andrewalker.net>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify it under
the same terms as Perl itself.
