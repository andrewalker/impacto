package Impacto::View::Kolon;

use utf8;

use Moose;
use namespace::autoclean;

extends 'Catalyst::View::Xslate';

sub get_first_existing_template {
    my ($self, @names) = @_;

    my @paths = @{ $self->path };
    my $ext   = $self->template_extension;

    foreach my $path (@paths) {
        foreach my $name (@names) {
            return "$name$ext" if -e "$path/$name$ext";
        }
    }
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=encoding utf8

=head1 NAME

Impacto::View::Kolon - Kolon View for Impacto

=head1 DESCRIPTION

Kolon View for Impacto.

=head1 METHODS

=head2 get_first_existing_template

Given a list of template names (without the extension), returns the
first one which exists in the filesystem (with the extension).

=head1 SEE ALSO

L<Impacto>

=head1 AUTHOR

André Walker

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.
