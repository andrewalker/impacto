package Impacto::Schema::UserAccount::Result::Role;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

Impacto::Schema::UserAccount::Result::Role

=cut

__PACKAGE__->table("role");

=head1 ACCESSORS

=head2 role

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns("role", { data_type => "text", is_nullable => 0 });
__PACKAGE__->set_primary_key("role");

=head1 RELATIONS

=head2 user_account_roles

Type: has_many

Related object: L<Impacto::Schema::UserAccount::Result::UserAccountRole>

=cut

__PACKAGE__->has_many(
  "user_account_roles",
  "Impacto::Schema::UserAccount::Result::UserAccountRole",
  { "foreign.role" => "self.role" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2011-09-26 20:07:28
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:/bBwYiDll0EsJ6TBpUcQPw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
