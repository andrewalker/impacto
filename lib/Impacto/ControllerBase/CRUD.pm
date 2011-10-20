package Impacto::ControllerBase::CRUD;
use utf8;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Impacto::ControllerBase::Base' }

has name => (
    isa        => 'Str',
    is         => 'ro',
    default    => '',
);

#has form => (
#    isa        => 'HTML::FormHandler',
#    is         => 'rw',
#    lazy_build => 1,
#);

#sub _build_form {
#    my ( $self ) = @_;
#    my $class = 'Impacto::Form::' . $self->name;
#
#    return $class->new;
#}

sub base : Chained('global_base') PathPrefix CaptureArgs(0) {
    my ( $self, $c ) = @_;
}

sub base_id : Chained('base') PathPart('') CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;

    $c->stash(id => $id);
}

sub list   : Chained('base') PathPart Args(0) {}
sub view   : Chained('base') PathPart Args(0) {}
sub delete : Chained('base') PathPart Args(0) {}
sub create : Chained('base') PathPart Args(0) {}
sub edit   : Chained('base') PathPart Args(0) {}

__PACKAGE__->meta->make_immutable;

1;
