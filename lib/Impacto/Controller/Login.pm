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
