package Form::SensibleX::FieldFactory::DBIC::ManyToMany;

use Moose;
use namespace::autoclean;
use Form::SensibleX::Field::DBIC::ManyToMany;

extends 'Form::SensibleX::FieldFactory::DBIC::Base';

sub _field_class {
    'Form::SensibleX::Field::DBIC::ManyToMany'
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
# categories => { x_field_factory => 'DBIC::ManyToMany', option_label => 'name', option_value => 'id' }

sub execute {
    my ( $self, $row, $fields ) = @_;
    my $i = 0;

    foreach my $keys (values %$fields) {
        my $name    = $self->fields->[$i]->name;
        my $setter  = "set_${name}";
        my $rs      = $self->fields->[$i]->get_rs;

        my @records = map { $rs->find($_) } @$keys;

        $row->$setter(\@records);
        $i++;
    }

    return $i > 0;
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=encoding utf8

=head1 NAME

Form::SensibleX::FieldFactory::DBIC::ManyToMany - Many to Many relationships in forms

=head1 DESCRIPTION

=head1 METHODS

=head2 execute

=head2 add_field

=head1 AUTHOR

André Walker <andre@andrewalker.net>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify it under
the same terms as Perl itself.
