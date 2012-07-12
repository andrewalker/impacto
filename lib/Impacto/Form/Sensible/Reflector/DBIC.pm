package Impacto::Form::Sensible::Reflector::DBIC;
use Moose;
use namespace::autoclean;

extends 'Form::Sensible::Reflector::DBIC';

sub BUILD {
    my $self = shift;

    $self->field_type_map->{text}->{defaults}->{field_class} = 'Text';
    $self->field_type_map->{boolean} = {
        defaults => { field_class => 'Toggle' },
    };
}

1;

__END__

=encoding utf8

=head1 NAME

Impacto::Form::Sensible::Reflector::DBIC

=head1 DESCRIPTION

L<Form::Sensible::Reflector::DBIC> with my defaults.

=head1 SEE ALSO

L<Impacto>, L<Form::Sensible::Reflector::DBIC>.

=head1 AUTHOR

André Walker

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.
