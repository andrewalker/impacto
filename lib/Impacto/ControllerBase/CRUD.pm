package Impacto::ControllerBase::CRUD;
use utf8;
use Form::Sensible;
use Form::Sensible::Reflector::DBIC;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Impacto::ControllerBase::Base' }

has name => (
    isa        => 'Str',
    is         => 'ro',
    default    => '',
);

has current_model_instance => (
    is         => 'rw',
    required   => 0,
);

sub base : Chained('global_base') PathPrefix CaptureArgs(0) {
    my ( $self, $c ) = @_;
    my $rs = $self->current_model_instance;

    my $form = Form::Sensible::Reflector::DBIC->new()->reflect_from(
        $rs,
        {
            form => { name => $rs->result_source->from },
            with_trigger => 1
        }
    );

    my $output = Form::Sensible->get_renderer('HTML')->render($form)->complete;
    $c->stash( form => $output );
}

sub base_id : Chained('base') PathPart('') CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;

    $c->stash(id => $id);
}

sub list      : Chained('base') PathPart Args(0) {}
sub list_json : Chained('base') PathPart Args(0) {}
sub view      : Chained('base') PathPart Args(0) {}
sub delete    : Chained('base') PathPart Args(0) {}
sub create    : Chained('base') PathPart Args(0) {}
sub edit      : Chained('base') PathPart Args(0) {}

__PACKAGE__->meta->make_immutable;

1;
