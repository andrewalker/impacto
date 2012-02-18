package Impacto;
use utf8;
use Moose;
use namespace::autoclean;
use CatalystX::RoleApplicator;
use Catalyst::Runtime 5.80;

# Set flags and add plugins for the application.
#
# Note that ORDERING IS IMPORTANT here as plugins are initialized in order,
# therefore you almost certainly want to keep ConfigLoader at the head of the
# list if you're using it.
#
#         -Debug: activates the debug mode for very useful log messages
#   ConfigLoader: will load the configuration from a Config::General file in the
#                 application's home directory
# Static::Simple: will serve static files from the application's root
#                 directory

use Catalyst qw/
    +CatalystX::I18N::Role::Base
    +CatalystX::I18N::Role::Maketext
    +CatalystX::I18N::Role::GetLocale
    ConfigLoader
    +CatalystX::SimpleLogin
    Authentication
    Session
    Session::Store::File
    Session::State::Cookie
    Static::Simple
    Unicode::Encoding
/;

__PACKAGE__->apply_request_class_roles('CatalystX::I18N::TraitFor::Request');
__PACKAGE__->apply_response_class_roles('CatalystX::I18N::TraitFor::Response');

extends 'Catalyst';

our $VERSION = '0.01';

# Configure the application.
#
# Note that settings in impacto.conf (or other external
# configuration file that you set up manually) take precedence
# over this when using ConfigLoader. Thus configuration
# details given here can function as a default configuration,
# with an external configuration file acting as an override for
# local deployment.

__PACKAGE__->config(
    name => 'Impacto',
    default_view => 'TT',
    authentication => {
       default_realm => 'user_account',
       realms        => {
          user_account => {
             credential => {
                class          => 'Password',
                password_field => 'password',
                password_type  => 'clear'
             },
             store => {
                class         => 'DBIx::Class',
                user_model    => 'DB::UserAccountUserAccount',
                role_relation => 'roles',
                role_field    => 'role',
             }
          }
       },
    },
    I18N => {
        default_locale => 'pt_BR',
        locales     => {
            'pt_BR' => {},
            'pt' => {},
            'en' => {},
        },
    },
    # Disable deprecated behavior needed by old applications
    disable_component_resolution_regex_fallback => 1,
);

# Start the application
__PACKAGE__->setup();


=head1 NAME

Impacto - Catalyst based application

=head1 SYNOPSIS

    script/impacto_server.pl

=head1 DESCRIPTION

[enter your description here]

=head1 SEE ALSO

L<Impacto::Controller::Root>, L<Catalyst>

=head1 AUTHOR

André Walker <andre@andrewalker.net>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
