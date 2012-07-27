package Impacto::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Impacto::ControllerBase::Base' }

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config(namespace => '');

sub index :Path Args(0) {
    my ( $self, $c ) = @_;

    $c->forward('global_base');
    $c->res->redirect('/login') if (!$c->user);
}

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
}

sub end : ActionClass('RenderView') {}

__PACKAGE__->meta->make_immutable;

1;

__END__

=pod

=encoding utf8

=head1 NAME

Impacto::Controller::Root - Root Controller for Impacto

=head1 DESCRIPTION

Root controller.

=head1 METHODS

=head2 index

The root page (/)

=head2 default

Standard 404 error page

=head2 end

Attempt to render a view, if needed.

=head1 AUTHOR

André Walker <andre@andrewalker.net>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.
