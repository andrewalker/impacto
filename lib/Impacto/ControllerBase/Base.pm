package Impacto::ControllerBase::Base;
use utf8;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

sub global_base : Chained('/') PathPart('') CaptureArgs(0) {
    my ( $self, $c ) = @_;

    return $c->res->redirect(
        $c->uri_for_action('/user/login')
    ) if (!$c->user_exists);
}

__PACKAGE__->meta->make_immutable;

1;
