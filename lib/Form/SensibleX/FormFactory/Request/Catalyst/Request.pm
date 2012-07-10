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
        service req    => {
            block => sub { $self->req },
        };
        service submit => {
            dependencies => {
                form => depends_on('/form'),
                req  => depends_on('req'),
            },
            block => sub {
                my $s = shift;
                my $req  = $self->param('req');
                my $form = $self->param('form');

                return 0 if ($req->method ne 'POST');

                my $values = $req->body_params;

                for my $field ($req->upload) {
                    $values->{$field} = $req->upload( $field );
                }

                $form->set_values( $values );

                return 1;
            },
        };
    };
}

__PACKAGE__->meta->make_immutable;

1;
