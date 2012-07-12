use utf8;
package Impacto::Schema;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use Moose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Schema';

__PACKAGE__->load_namespaces;


# Created by DBIx::Class::Schema::Loader v0.07015 @ 2012-02-17 22:27:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:iFRDom/yc0euZf1KFUx9Lw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable(inline_constructor => 0);
1;

__END__

=pod

=encoding utf8

=head1 NAME

Impacto::Schema - Impacto DBIC Schema

=head1 DESCRIPTION

Inherits from L<DBIx::Class::Schema> and loads namespaces.

=head1 SEE ALSO

L<DBIx::Class::Schema>.

=head1 AUTHOR

André Walker <andre@andrewalker.net>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.
