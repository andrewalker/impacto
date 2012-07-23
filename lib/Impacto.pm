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

# Start the application
__PACKAGE__->setup();

1;

__END__

=encoding utf8

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
