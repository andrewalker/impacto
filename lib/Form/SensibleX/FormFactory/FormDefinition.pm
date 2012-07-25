package Form::SensibleX::FormFactory::FormDefinition;
use Moose;
use feature 'say';
use Config::General qw/ParseConfig SaveConfig/;
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

    $args->{path_to_form} = $path . $name . '.conf';

    return $args;
};

sub save {
    my ($self, $hash) = @_;
    SaveConfig($self->path_to_form, $hash);
}

sub load {
    my $self = shift;
    return {
        ParseConfig(-ConfigFile => $self->path_to_form)
    };
}

__PACKAGE__->meta->make_immutable;

1;
