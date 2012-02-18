use utf8;
package Impacto::Schema::Result::PeoplePerson;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Impacto::Schema::Result::PeoplePerson

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

=head1 TABLE: C<people.person>

=cut

__PACKAGE__->table("people.person");

=head1 ACCESSORS

=head2 slug

  data_type: 'text'
  is_nullable: 0

=head2 name

  data_type: 'text'
  is_nullable: 0

=head2 phone

  data_type: 'text'
  is_nullable: 1

=head2 email

  data_type: 'text'
  is_nullable: 1

=head2 site

  data_type: 'text'
  is_nullable: 1

=head2 comments

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "slug",
  { data_type => "text", is_nullable => 0 },
  "name",
  { data_type => "text", is_nullable => 0 },
  "phone",
  { data_type => "text", is_nullable => 1 },
  "email",
  { data_type => "text", is_nullable => 1 },
  "site",
  { data_type => "text", is_nullable => 1 },
  "comments",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</slug>

=back

=cut

__PACKAGE__->set_primary_key("slug");

=head1 RELATIONS

=head2 addresses

Type: has_many

Related object: L<Impacto::Schema::Result::PeopleAddress>

=cut

__PACKAGE__->has_many(
  "addresses",
  "Impacto::Schema::Result::PeopleAddress",
  { "foreign.person" => "self.slug" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 bank_accounts

Type: has_many

Related object: L<Impacto::Schema::Result::PeopleBankAccount>

=cut

__PACKAGE__->has_many(
  "bank_accounts",
  "Impacto::Schema::Result::PeopleBankAccount",
  { "foreign.person" => "self.slug" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 client

Type: might_have

Related object: L<Impacto::Schema::Result::PeopleClient>

=cut

__PACKAGE__->might_have(
  "client",
  "Impacto::Schema::Result::PeopleClient",
  { "foreign.person" => "self.slug" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 documents

Type: has_many

Related object: L<Impacto::Schema::Result::PeopleDocument>

=cut

__PACKAGE__->has_many(
  "documents",
  "Impacto::Schema::Result::PeopleDocument",
  { "foreign.person" => "self.slug" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 employee

Type: might_have

Related object: L<Impacto::Schema::Result::PeopleEmployee>

=cut

__PACKAGE__->might_have(
  "employee",
  "Impacto::Schema::Result::PeopleEmployee",
  { "foreign.person" => "self.slug" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 representant

Type: might_have

Related object: L<Impacto::Schema::Result::PeopleRepresentant>

=cut

__PACKAGE__->might_have(
  "representant",
  "Impacto::Schema::Result::PeopleRepresentant",
  { "foreign.person" => "self.slug" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 supplier

Type: might_have

Related object: L<Impacto::Schema::Result::PeopleSupplier>

=cut

__PACKAGE__->might_have(
  "supplier",
  "Impacto::Schema::Result::PeopleSupplier",
  { "foreign.person" => "self.slug" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07015 @ 2012-02-17 22:27:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:I2WzwONyIwvLPak2d1h4xA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
