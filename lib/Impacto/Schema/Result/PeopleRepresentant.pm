use utf8;
package Impacto::Schema::Result::PeopleRepresentant;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Impacto::Schema::Result::PeopleRepresentant

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

=head1 TABLE: C<people.representant>

=cut

__PACKAGE__->table("people.representant");

=head1 ACCESSORS

=head2 person

  data_type: 'text'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "person",
  { data_type => "text", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</person>

=back

=cut

__PACKAGE__->set_primary_key("person");

=head1 RELATIONS

=head2 consignations

Type: has_many

Related object: L<Impacto::Schema::Result::ProductConsignation>

=cut

__PACKAGE__->has_many(
  "consignations",
  "Impacto::Schema::Result::ProductConsignation",
  { "foreign.representant" => "self.person" },
  { cascade_copy => 0, cascade_delete => 0 },
);

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
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:n/0DtoUMYZqTyh3dPyUsQw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
