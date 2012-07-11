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

__END__

=encoding utf8

=head1 NAME

Form::SensibleX::FieldRole::FileSelector::ByteA - Load files as byte arrays

=head1 DESCRIPTION

Moose::Role to be applied to FileSelector fields in a Form::Sensible form, so
that instead of saving the filename in the database, the file contents are
saved as byte_a (byte array).

=head1 AUTHOR

André Walker <andre@andrewalker.net>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify it under
the same terms as Perl itself.
