package Impacto::Schema::People::Result::Person;

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

Impacto::Schema::People::Result::Person

=cut

__PACKAGE__->table("person");

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
__PACKAGE__->set_primary_key("slug");

=head1 RELATIONS

=head2 addresses

Type: has_many

Related object: L<Impacto::Schema::People::Result::Address>

=cut

__PACKAGE__->has_many(
  "addresses",
  "Impacto::Schema::People::Result::Address",
  { "foreign.person" => "self.slug" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 bank_accounts

Type: has_many

Related object: L<Impacto::Schema::People::Result::BankAccount>

=cut

__PACKAGE__->has_many(
  "bank_accounts",
  "Impacto::Schema::People::Result::BankAccount",
  { "foreign.person" => "self.slug" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 client

Type: might_have

Related object: L<Impacto::Schema::People::Result::Client>

=cut

__PACKAGE__->might_have(
  "client",
  "Impacto::Schema::People::Result::Client",
  { "foreign.person" => "self.slug" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 documents

Type: has_many

Related object: L<Impacto::Schema::People::Result::Document>

=cut

__PACKAGE__->has_many(
  "documents",
  "Impacto::Schema::People::Result::Document",
  { "foreign.person" => "self.slug" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 employee

Type: might_have

Related object: L<Impacto::Schema::People::Result::Employee>

=cut

__PACKAGE__->might_have(
  "employee",
  "Impacto::Schema::People::Result::Employee",
  { "foreign.person" => "self.slug" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 representant

Type: might_have

Related object: L<Impacto::Schema::People::Result::Representant>

=cut

__PACKAGE__->might_have(
  "representant",
  "Impacto::Schema::People::Result::Representant",
  { "foreign.person" => "self.slug" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 supplier

Type: might_have

Related object: L<Impacto::Schema::People::Result::Supplier>

=cut

__PACKAGE__->might_have(
  "supplier",
  "Impacto::Schema::People::Result::Supplier",
  { "foreign.person" => "self.slug" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2011-09-26 20:07:24
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:OUxuCj96/YHuXcFqjcyh5w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
