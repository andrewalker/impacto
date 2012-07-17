package Form::SensibleX::Field::DBIC::Slug;

use Moose;
use namespace::autoclean;
use Carp;
use utf8;

extends 'Form::Sensible::Field::Text';

has resultset => (
    isa      => 'DBIx::Class::ResultSet',
    is       => 'ro',
    required => 1,
);

sub BUILD {
    #my $self = shift;
    #$self->render_hints->{field_type} = 'hidden';
}

sub _default_field_type {
    'hidden'
}

sub generate_slug {
    my ($self, $source) = @_;

    my $slug = lc($source);

    $slug =~ tr[áàäãâéèëẽêíìïĩîóòöõôúùüũûç]
                 [aaaaaeeeeeiiiiiooooouuuuuc];
    $slug =~ s/\W/_/g;

    my $name = $self->name;

    my $row = $self->resultset->search({
        $name => { like => $slug .'%' },
    }, {
        columns  => [ $name ],
        rows     => 1,
        offset   => 0,
        order_by => { -desc => $name },
    })->single;

    return $slug if (!$row);

    my $slug_from_row = $row->get_column($name);

    if ($slug_from_row =~ m|\[(\d+)\]$|) {
        my $num = $1+1;
        return $slug . "[$num]";
    }

    return $slug . "[1]";
}

sub generate_slug_and_set_value {
    my ( $self, $source ) = @_;

    return $self->value(
        $self->generate_slug( $source )
    );
}

sub get_values_from_row {
    my ( $self, $row ) = @_;

    my $name = $self->name;

    return $row->$name;
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=encoding utf8

=head1 NAME

Form::SensibleX::Field::DBIC::Slug

=head1 DESCRIPTION

=head1 METHODS

=head1 AUTHOR

André Walker <andre@andrewalker.net>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify it under
the same terms as Perl itself.
