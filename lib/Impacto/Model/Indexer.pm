package Impacto::Model::Indexer;
use Moose;
extends 'Catalyst::Model';
use Impacto::ModelBackend::Indexer;
use namespace::autoclean;

# TODO
# use Catalyst::Model::Factory

sub ACCEPT_CONTEXT {
    my ($self, $c) = @_;

    return Impacto::ModelBackend::Indexer->new(
        es         => $c->model('Search')->_es,
        index_name => 'impacto',
    );
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=encoding utf8

=head1 NAME

Impacto::Model::Indexer

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
