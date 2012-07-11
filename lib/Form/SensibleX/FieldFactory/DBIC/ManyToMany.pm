package Form::SensibleX::FieldFactory::DBIC::ManyToMany;

use Moose;
use namespace::autoclean;
use Form::SensibleX::Field::DBIC::ManyToMany;

extends 'Form::SensibleX::FieldFactory::DBIC::Base';

around BUILDARGS => sub {
    my $orig  = shift;
    my $class = shift;

    my %field_args = ref $_[0] && ref $_[0] eq 'HASH' ? %{$_[0]} : @_;
    my %args;

    $field_args{resultset} = $field_args{model}->resultset if $field_args{model};
    delete $field_args{model};
    delete $field_args{request};

    $args{names}  = [ $field_args{name} ];
    $args{fields} = [ Form::SensibleX::Field::DBIC::ManyToMany->new(%field_args) ];
    $args{fields}->[0]->{from_factory} = __PACKAGE__;
    $args{fields}->[0]->{_fname}       = $field_args{name};

    return $class->$orig(%args);
};

sub add_field {
    my ( $self, $args ) = @_;

    my $field = Form::SensibleX::Field::DBIC::ManyToMany->new($args);
    $field->{from_factory} = __PACKAGE__;
    $field->{_fname}       = $args->{name};
    $self->push_field($field);
    $self->add_name($args->{name});

    return 1;
}

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
