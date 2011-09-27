package Impacto::View::TT;

use strict;
use warnings;

use base 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt2',
    render_die => 1,
    INCLUDE_PATH => [
        Impacto->path_to( 'root', 'templates' ),
    ],
    WRAPPER => 'wrapper.tt2',
);

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
