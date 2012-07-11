package Form::SensibleX::Field::FileSelector::Catalyst;

use Moose;
use namespace::autoclean;

extends 'Form::Sensible::Field::FileSelector';

has 'file_ref' => (
    is       => 'rw',
    isa      => 'IO::File',
    required => 0,
);

has 'tempname' => (
    is       => 'rw',
    isa      => 'Str',
    default  => '',
);

sub field_type { 'fileselector' }

around value => sub {
    my $orig = shift;
    my $self = shift;
    my ( $value ) = @_;

    return $self->$orig(@_) unless (
        $value &&
        ref $value &&
        eval { $value->isa('Catalyst::Request::Upload') }
    );

    $self->file_ref($value->fh);
    $self->filename($value->basename);
    $self->full_path($value->tempname);
    $self->tempname($value->tempname);

    $self->$orig($value->tempname);
};

__PACKAGE__->meta->make_immutable;

1;

__END__

=encoding utf8

=head1 NAME

Form::SensibleX::Field::FileSelector::Catalyst

=head1 DESCRIPTION

=head1 METHODS

=head2 field_type

Forces the field_type attribute to be 'fileselector'.

=head1 AUTHOR

André Walker <andre@andrewalker.net>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify it under
the same terms as Perl itself.
