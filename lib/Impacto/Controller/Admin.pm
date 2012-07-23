package Impacto::Controller::Admin;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Impacto::ControllerBase::Base' }

sub rebuild_indexes :Chained('global_base') :PathPart Args(0) {}

__PACKAGE__->meta->make_immutable;

1;

__END__

=encoding utf8

=head1 NAME

Impacto::Controller::Admin - Catalyst Controller

=head1 DESCRIPTION

Administrative methods.

=head1 METHODS

Rebuild indexes.

=head1 AUTHOR

André Walker

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.
