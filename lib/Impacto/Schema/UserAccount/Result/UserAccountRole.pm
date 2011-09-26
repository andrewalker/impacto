package Impacto::Schema::UserAccount::Result::UserAccountRole;

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

Impacto::Schema::UserAccount::Result::UserAccountRole

=cut

__PACKAGE__->table("user_account_role");

=head1 ACCESSORS

=head2 login

  data_type: 'text'
  is_foreign_key: 1
  is_nullable: 0

=head2 role

  data_type: 'text'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "login",
  { data_type => "text", is_foreign_key => 1, is_nullable => 0 },
  "role",
  { data_type => "text", is_foreign_key => 1, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("login", "role");

=head1 RELATIONS

=head2 login

Type: belongs_to

Related object: L<Impacto::Schema::UserAccount::Result::UserAccount>

=cut

__PACKAGE__->belongs_to(
  "login",
  "Impacto::Schema::UserAccount::Result::UserAccount",
  { login => "login" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 role

Type: belongs_to

Related object: L<Impacto::Schema::UserAccount::Result::Role>

=cut

__PACKAGE__->belongs_to(
  "role",
  "Impacto::Schema::UserAccount::Result::Role",
  { role => "role" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2011-09-26 20:07:28
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:MjDfkfKkk6z5PmZF4c5nWg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
