package Form::SensibleX::FormFactory::Request::Catalyst::Request;
use Moose;
use namespace::autoclean;

has req => (
    isa => 'Catalyst::Request',
    is  => 'ro',
);

sub submit {
    my ( $self, $form ) = @_;
    my $req  = $self->req;

    return 0 if ($req->method ne 'POST');

    my $values = $req->body_params;

    for my $field ($req->upload) {
        $values->{$field} = $req->upload( $field );
    }

    $form->set_values( $values );

    return 1;
}

1;
