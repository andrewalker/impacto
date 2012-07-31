use utf8;
package Impacto::Schema::Result::PeopleAddress;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Impacto::Schema::Result::PeopleAddress

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

=head1 TABLE: C<people.address>

=cut

__PACKAGE__->table("people.address");

=head1 ACCESSORS

=head2 person

  data_type: 'text'
  is_foreign_key: 1
  is_nullable: 0

=head2 is_main_address

  data_type: 'boolean'
  default_value: true
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

=head2 post_office_box

  data_type: 'text'
  is_nullable: 1

=head2 borough

  data_type: 'text'
  is_nullable: 1

=head2 street_address_line1

  data_type: 'text'
  is_nullable: 0

=head2 street_address_line2

  data_type: 'text'
  is_nullable: 1

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'people.address_id_seq'

=cut

__PACKAGE__->add_columns(
  "person",
  { data_type => "text", is_foreign_key => 1, is_nullable => 0 },
  "is_main_address",
  { data_type => "boolean", default_value => \"true", is_nullable => 0 },
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
  "post_office_box",
  { data_type => "text", is_nullable => 1 },
  "borough",
  { data_type => "text", is_nullable => 1 },
  "street_address_line1",
  { data_type => "text", is_nullable => 0 },
  "street_address_line2",
  { data_type => "text", is_nullable => 1 },
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "people.address_id_seq",
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

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


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2012-07-30 19:49:46
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:4CrNuY40osIVTL742KlS7w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
