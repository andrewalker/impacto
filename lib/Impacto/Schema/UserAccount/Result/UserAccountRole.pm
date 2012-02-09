use utf8;
package Impacto::Schema::UserAccount::Result::UserAccountRole;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Impacto::Schema::UserAccount::Result::UserAccountRole

=cut

use strict;
use warnings;

=head1 BASE CLASS: L<Impacto::DBIC::Result>

=cut

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'Impacto::DBIC::Result';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<user_account_role>

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

=head1 PRIMARY KEY

=over 4

=item * L</login>

=item * L</role>

=back

=cut

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


# Created by DBIx::Class::Schema::Loader v0.07015 @ 2012-02-09 16:32:13
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:1vITs4jYiRWyOLrFU9HVUQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
