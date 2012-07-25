package Form::SensibleX::FormFactory::FormDefinition;
use Moose;
use JSON;
use File::Slurp;
use namespace::autoclean;

has path_to_form => (
    isa => 'Str',
    is  => 'ro',
);

around BUILDARGS => sub {
    my $orig = shift;
    my $self = shift;

    my $args = $self->$orig(@_);

    my $path = delete $args->{path_to_forms}
        or die "path_to_forms is required!";

    my $name = delete $args->{form_name}
        or die "form_name is required!";

    substr($path, -1) eq '/'
        or $path .= '/';

    $args->{path_to_form} = $path . $name . '.json';

    return $args;
};

sub save {
    my ($self, $hash) = @_;
    my $json_text   = to_json( $hash, { pretty => 1 } );
    write_file($self->path_to_form, $json_text);
}

sub load {
    my $self = shift;
    my $file = read_file($self->path_to_form);
    return from_json($file);
}

__PACKAGE__->meta->make_immutable;

1;
