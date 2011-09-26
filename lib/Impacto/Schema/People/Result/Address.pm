package Impacto::Schema::People::Result::Address;

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

Impacto::Schema::People::Result::Address

=cut

__PACKAGE__->table("address");

=head1 ACCESSORS

=head2 person

  data_type: 'text'
  is_foreign_key: 1
  is_nullable: 0

=head2 name

  data_type: 'text'
  is_nullable: 0

=head2 is_main_address

  data_type: 'boolean'
  default_value: true
  is_nullable: 0

=head2 number

  data_type: 'integer'
  is_nullable: 0

=head2 street

  data_type: 'text'
  is_nullable: 0

=head2 zip_code

  data_type: 'text'
  is_nullable: 0

=head2 city

  data_type: 'text'
  is_nullable: 0

=head2 state

  data_type: 'text'
  is_nullable: 0

=head2 country

  data_type: 'text'
  is_nullable: 0

=head2 phone

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "person",
  { data_type => "text", is_foreign_key => 1, is_nullable => 0 },
  "name",
  { data_type => "text", is_nullable => 0 },
  "is_main_address",
  { data_type => "boolean", default_value => \"true", is_nullable => 0 },
  "number",
  { data_type => "integer", is_nullable => 0 },
  "street",
  { data_type => "text", is_nullable => 0 },
  "zip_code",
  { data_type => "text", is_nullable => 0 },
  "city",
  { data_type => "text", is_nullable => 0 },
  "state",
  { data_type => "text", is_nullable => 0 },
  "country",
  { data_type => "text", is_nullable => 0 },
  "phone",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("person", "name");

=head1 RELATIONS

=head2 person

Type: belongs_to

Related object: L<Impacto::Schema::People::Result::Person>

=cut

__PACKAGE__->belongs_to(
  "person",
  "Impacto::Schema::People::Result::Person",
  { slug => "person" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2011-09-26 20:07:24
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:pORYJL297ByOk2vU+NceGQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
