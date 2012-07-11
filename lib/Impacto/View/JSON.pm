package Impacto::View::JSON;

use utf8;
use warnings;
use strict;
use base 'Catalyst::View::JSON';

__PACKAGE__->config(
    expose_stash => [ qw/list_json_structure items identifier numRows/ ],
);

1;

__END__

=encoding utf8

=head1 NAME

Impacto::View::JSON - Catalyst JSON View

=head1 SYNOPSIS

See L<Impacto>

=head1 DESCRIPTION

Catalyst JSON View.

=head1 AUTHOR

André Walker

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.
