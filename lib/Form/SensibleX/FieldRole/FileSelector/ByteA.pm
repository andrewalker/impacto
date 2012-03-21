package Form::SensibleX::FieldRole::FileSelector::ByteA;

use File::Slurp qw/read_file/;

use Moose::Role;
use namespace::autoclean;

requires 'full_path';

around value => sub {
    my $orig = shift;
    my $self = shift;

    return $self->$orig(@_) if @_;

    my $bytea = read_file( $self->full_path );
    return $bytea;
};

1;
