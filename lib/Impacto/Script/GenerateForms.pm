package Impacto::Script::GenerateForms;
use Moose;
use Impacto;
use feature 'say';
use namespace::autoclean;
use Data::Dumper;

with 'Catalyst::ScriptRole';

sub run {
    my $self = shift;
    $self->generate_forms(Impacto->new);
}

sub generate_forms {
    my ($self, $c) = @_;

    for ($c->controllers) {
        my $controller = $c->controller($_);
        if ( $controller->isa('Impacto::ControllerBase::CRUD') ) {
            my $form_factory = $controller->build_form_factory( $c );
            say Dumper( $form_factory->container->resolve(service => 'form_raw_definition') );
        }
    }
}

1;
