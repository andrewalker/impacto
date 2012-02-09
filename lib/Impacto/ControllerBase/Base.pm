package Impacto::ControllerBase::Base;
use utf8;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

sub global_base : Chained('/') PathPart('') CaptureArgs(0) {
    my ( $self, $c ) = @_;

    $c->get_locale();
    $c->stash(static_root_uri => $c->uri_for('/static'));

#    return $c->res->redirect(
#        $c->uri_for_action('/user/login')
#    ) if (!$c->user_exists);
}

__PACKAGE__->meta->make_immutable;

1;
