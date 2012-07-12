package Impacto::FormFactory;
use Moose;
use Catalyst::Utils;
use Class::Load qw/ load_optional_class /;
use namespace::autoclean;

extends 'Form::SensibleX::FormFactory';

around BUILDARGS => sub {
    my $orig = shift;
    my $self = shift;

    my $args = ref $_[0] && ref $_[0] eq 'HASH' ? $_[0] : {@_};

    return $self->$orig(@_) unless defined $args->{controller_name};

    if (! defined $args->{model}) {
        my $class = get_class_name($args->{controller_name}, 'Model');
        if ( load_optional_class( $class ) ) {
            $args->{model} = '+' . $class;
        }
    }

    if (! defined $args->{request}) {
        my $class = get_class_name($args->{controller_name}, 'Request');
        if ( load_optional_class( $class ) ) {
            $args->{request} = '+' . $class;
        }
    }

    return $self->$orig($args);
};

sub get_class_name {
    my ($controller_name, $what) = @_;
    my $prefix = Catalyst::Utils::class2classprefix($controller_name);
    $controller_name =~ s/^$prefix//;
    return __PACKAGE__ . "::${what}" . $controller_name;
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=encoding utf8

=head1 NAME

Impacto::FormFactory

=head1 DESCRIPTION

Loads a custom model or request class for you FormFactory, if they exist.
Extends L<Form::SensibleX::FormFactory>.

=head1 METHODS

=head2 get_class_name

Returns the class name for the hypothetical request or model class, to check
its existence.

=head1 SEE ALSO

L<Impacto>, L<Form::SensibleX::FormFactory>.

=head1 AUTHOR

André Walker

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.
