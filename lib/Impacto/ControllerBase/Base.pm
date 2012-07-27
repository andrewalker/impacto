package Impacto::ControllerBase::Base;
use utf8;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

sub global_base : Chained('/login/required') PathPart('') CaptureArgs(0) {
    my ( $self, $c ) = @_;

    $c->set_locale('pt_BR');
    $c->stash(
        root_uri        => $c->uri_for('/'),
        static_root_uri => $c->uri_for('/static'),
        user            => $c->user,
    );

#    return $c->res->redirect(
#        $c->uri_for_action('/user/login')
#    ) if (!$c->user_exists);
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=encoding utf8

=head1 NAME

Impacto::ControllerBase::Base - Base controller class for Impacto

=head1 DESCRIPTION

All Impacto controller inherit from this one. Set locale stuff, check if
user is logged in, etc.

=head1 METHODS

=head2 global_base

Beginning of the chain in every action in this application.

=head1 AUTHOR

André Walker <andre@andrewalker.net>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.
