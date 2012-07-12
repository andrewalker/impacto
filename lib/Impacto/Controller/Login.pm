package Impacto::Controller::Login;
use Moose;
use namespace::autoclean;
extends 'CatalystX::SimpleLogin::Controller::Login';

before login => sub {
    my ($self, $ctx) = @_;

    $ctx->stash(
        static_root_uri => $ctx->uri_for('/static'),
        extra_css       => 'form.css',
    );
};

__PACKAGE__->config(
    login_form_args => {
       authenticate_username_field_name => 'login',
    },
);

1;

__END__

=pod

=encoding utf8

=head1 NAME

Impacto::Controller::Login - Login Controller for Impacto

=head1 DESCRIPTION

Login controller. Inherits from CatalystX::SimpleLogin::Controller::Login.

=head1 SEE ALSO

L<CatalystX::SimpleLogin::Controller::Login>.

=head1 AUTHOR

André Walker <andre@andrewalker.net>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.
