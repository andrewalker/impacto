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
        service form_values => (
            dependencies => {
                req  => depends_on('req'),
            },
            lifecycle => 'Singleton',
            block => sub {
                my $s = shift;
                my $req = $s->param('req');
                my $values = $req->body_params;

                for my $field ($req->upload) {
                    $values->{$field} = $req->upload( $field );
                }

                return $values;
            },
        );
        service submit => (
            dependencies => {
                req  => depends_on('req'),
                form_values  => depends_on('form_values'),
            },
            block => sub {
                my $s = shift;
                my $req  = $s->param('req');
                my $v    = $s->param('form_values');

                return ($req->method eq 'POST' && delete $v->{submit});
            },
        );
    };
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=encoding utf8

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
