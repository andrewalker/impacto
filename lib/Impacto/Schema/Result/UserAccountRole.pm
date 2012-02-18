use utf8;
package Impacto::Schema::Result::UserAccountRole;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Impacto::Schema::Result::UserAccountRole

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

=head1 TABLE: C<user_account.role>

=cut

__PACKAGE__->table("user_account.role");

=head1 ACCESSORS

=head2 role

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns("role", { data_type => "text", is_nullable => 0 });

=head1 PRIMARY KEY

=over 4

=item * L</role>

=back

=cut

__PACKAGE__->set_primary_key("role");

=head1 RELATIONS

=head2 user_account_roles

Type: has_many

Related object: L<Impacto::Schema::Result::UserAccountUserAccountRole>

=cut

__PACKAGE__->has_many(
  "user_account_roles",
  "Impacto::Schema::Result::UserAccountUserAccountRole",
  { "foreign.role" => "self.role" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 logins

Type: many_to_many

Composing rels: L</user_account_roles> -> login

=cut

__PACKAGE__->many_to_many("logins", "user_account_roles", "login");


# Created by DBIx::Class::Schema::Loader v0.07015 @ 2012-02-17 22:27:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:V75Z9POtz2ZbnX5kpaE5pQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
