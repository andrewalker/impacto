package Form::SensibleX::FormFactory::Request::Catalyst::Request;
use Moose;
use Bread::Board;
use namespace::autoclean;

extends 'Bread::Board::Container';

has '+name' => ( default => 'Request' );

has req => (
    isa => 'Catalyst::Request',
    is  => 'ro',
);

sub BUILD {
    my $self = shift;

    container $self => as {
        service req    => (
            block => sub { $self->req },
        );
        service submit => (
            dependencies => {
                form => depends_on('/form'),
                req  => depends_on('req'),
            },
            block => sub {
                my $s = shift;
                my $req  = $s->param('req');
                my $form = $s->param('form');

                return 0 if ($req->method ne 'POST');

                my $values = $req->body_params;

                for my $field ($req->upload) {
                    $values->{$field} = $req->upload( $field );
                }

                $form->set_values( $values );

                return 1;
            },
        );
    };
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=head1 NAME

Form::SensibleX::FormFactory::Request::Catalyst::Request - Handle Catalyst requests

=head1 DESCRIPTION

Checks whether the form has been submitted, if there are files to upload, and sets the values on the form fields.

=head1 METHODS

=head2 BUILD

Builds the Bread::Board container.

=head1 AUTHOR

André Walker <andre@andrewalker.net>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.
