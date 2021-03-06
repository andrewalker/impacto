use utf8;
package Impacto::Schema::Result::PeopleBankAccount;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Impacto::Schema::Result::PeopleBankAccount

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

=head1 TABLE: C<people.bank_account>

=cut

__PACKAGE__->table("people.bank_account");

=head1 ACCESSORS

=head2 person

  data_type: 'text'
  is_foreign_key: 1
  is_nullable: 0

=head2 bank

  data_type: 'text'
  is_nullable: 0

=head2 account

  data_type: 'text'
  is_nullable: 0

=head2 agency

  data_type: 'text'
  is_nullable: 1

=head2 is_savings_account

  data_type: 'boolean'
  default_value: false
  is_nullable: 0

=head2 comments

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "person",
  { data_type => "text", is_foreign_key => 1, is_nullable => 0 },
  "bank",
  { data_type => "text", is_nullable => 0 },
  "account",
  { data_type => "text", is_nullable => 0 },
  "agency",
  { data_type => "text", is_nullable => 1 },
  "is_savings_account",
  { data_type => "boolean", default_value => \"false", is_nullable => 0 },
  "comments",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</person>

=item * L</bank>

=item * L</account>

=back

=cut

__PACKAGE__->set_primary_key("person", "bank", "account");

=head1 RELATIONS

=head2 person

Type: belongs_to

Related object: L<Impacto::Schema::Result::PeoplePerson>

=cut

__PACKAGE__->belongs_to(
  "person",
  "Impacto::Schema::Result::PeoplePerson",
  { slug => "person" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07015 @ 2012-02-17 22:27:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:yXU22s8hD/pgGXfnghea4w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
