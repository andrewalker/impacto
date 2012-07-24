package Impacto::Script::ReIndexSearch;
use Moose;
use Impacto;
use feature 'say';
use namespace::autoclean;

with 'Catalyst::ScriptRole';

sub run {
    my $self = shift;
    $self->reindex_db(Impacto->new);
}

sub reindex_db {
    my ($self, $c) = @_;

    my $model = $c->model('Indexer');

    for ($c->controllers) {
        my $controller = $c->controller($_);
        if ( $controller->isa('Impacto::ControllerBase::CRUD') ) {
            say $model->reindex_controller($controller);
        }
    }
}

1;
