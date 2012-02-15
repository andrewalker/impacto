package Impacto::View::TT;

use utf8;
use strict;
use warnings;

use base 'Catalyst::View::TT';

sub get_first_existing_template {
    my ($self, @names) = @_;

    my @paths = @{ $self->include_path };
    my $ext   = $self->config->{TEMPLATE_EXTENSION};

    foreach my $path (@paths) {
        foreach my $name (@names) {
            return "$name$ext" if -e "$path/$name$ext";
        }
    }
}

=head1 NAME

Impacto::View::TT - TT View for Impacto

=head1 DESCRIPTION

TT View for Impacto.

=head1 SEE ALSO

L<Impacto>

=head1 AUTHOR

André Walker

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
