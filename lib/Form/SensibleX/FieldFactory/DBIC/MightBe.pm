package Form::SensibleX::FieldFactory::DBIC::MightBe;

use Moose;
use namespace::autoclean;
use Form::SensibleX::Field::DBIC::MightBe;

extends 'Form::SensibleX::FieldFactory::DBIC::Base';

sub _field_class {
    'Form::SensibleX::Field::DBIC::MightBe'
}

around BUILDARGS => sub {
    my $orig  = shift;
    my $class = shift;

    my %field_args = $class->_get_buildargs_args(@_);

    $field_args{resultset} = $field_args{model}->resolve(service => 'resultset') if $field_args{model};

    return $class->$orig(
        $class->_field_factory_buildargs(
            field_args   => \%field_args,
            factory_args => {},
        )
    );
};

# form extra params:
# client => { x_field_factory => 'DBIC::MightBe', option_label => 'Client', option_value => 'person' }

sub execute {
    my ( $self, $row, $fields ) = @_;
    my $i = 0;

    foreach my $keys (values %$fields) {
        my $name    = $self->fields->[$i]->name;
        my $value   = $self->fields->[$i]->value;

        if ($value) {
            $row->find_or_create_related($name, {});
        }
        else {
            if (my $r = $row->find_related($name, {})) {
                $r->delete;
            }
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

Form::SensibleX::FieldFactory::DBIC::MightBe

=head1 DESCRIPTION

=head1 METHODS

=head1 AUTHOR

André Walker <andre@andrewalker.net>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify it under
the same terms as Perl itself.
