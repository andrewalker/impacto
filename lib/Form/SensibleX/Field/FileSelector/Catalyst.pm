package Form::SensibleX::Field::FileSelector::Catalyst;

use Moose;
use namespace::autoclean;

extends 'Form::Sensible::Field::FileSelector';

has 'file_ref' => (
    is       => 'rw',
    isa      => 'IO::File',
    required => 0,
);

sub field_type { 'fileselector' }

before value => sub {
    my ( $self, $value ) = @_;

    return unless (
        $value &&
        ref $value &&
        eval { $value->isa('Catalyst::Request::Upload') }
    );

    $self->file_ref($value->fh);
    $self->filename($value->basename);
    $self->full_path($value->tempname);
    $self->value($value->tempname);
};

__PACKAGE__->meta->make_immutable;

1;
