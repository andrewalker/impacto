package Impacto::Model::Indexer;
use Moose;
extends 'Catalyst::Model';
use Impacto::ModelBackend::Indexer;
use namespace::autoclean;

has indexer => (
    isa => 'Impacto::ModelBackend::Indexer',
    is  => 'ro',
    writer => '_set_indexer',
    handles => [qw/
        reindex_controller
        initialize_mapping
        initialize_index
    /],
);

sub ACCEPT_CONTEXT {
    my ($self, $c) = @_;
    $self->_set_indexer(
        Impacto::ModelBackend::Indexer->new(
            es         => $c->model('Search')->_es,
            index_name => 'impacto',
        )
    );
    return $self;
}

sub reindex_db {
    my ($self, $c) = @_;

    foreach my $controller ($c->controllers) {
        $controller = $c->controller($controller);
        next unless $controller->isa('Impacto::ControllerBase::CRUD');
        $self->reindex_controller($controller);
    }
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=encoding utf8

=head1 NAME

Impacto::Model::SearchIndex

=head1 SYNOPSIS

See L<Impacto>.

=head1 DESCRIPTION

=head1 METHODS

=head1 SEE ALSO

L<Impacto::Model::Search>

=head1 AUTHOR

André Walker

=head1 LICENSE

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.
