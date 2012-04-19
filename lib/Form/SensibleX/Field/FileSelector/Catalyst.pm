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
