package Form::SensibleX::Field::FileSelector::CatalystByteA;

use Moose;
use namespace::autoclean;

extends 'Form::SensibleX::Field::FileSelector::Catalyst';
with 'Form::SensibleX::FieldRole::FileSelector::ByteA';

__PACKAGE__->meta->make_immutable;

1;

__END__

=encoding utf8

=head1 NAME

Form::SensibleX::Field::FileSelector::CatalystByteA

=head1 DESCRIPTION

Inherits from L<Form::SensibleX::Field::FileSelector::Catalyst> and applies the
role L<Form::SensibleX::FieldRole::FileSelector::ByteA>.

=head1 AUTHOR

André Walker <andre@andrewalker.net>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify it under
the same terms as Perl itself.
