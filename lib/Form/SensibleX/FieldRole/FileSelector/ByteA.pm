package Form::SensibleX::FieldRole::FileSelector::ByteA;

use File::Slurp qw/read_file/;

use Moose::Role;
use namespace::autoclean;

requires 'tempname';

around value => sub {
    my $orig = shift;
    my $self = shift;

    return $self->$orig(@_) if @_;
    return $self->$orig()   if !$self->tempname;

    my $bytea = read_file( $self->tempname );
    return $bytea;
};

1;
