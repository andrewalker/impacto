use utf8;
package Impacto::Schema::Result::PeopleSupplier;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Impacto::Schema::Result::PeopleSupplier

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

=head1 TABLE: C<people.supplier>

=cut

__PACKAGE__->table("people.supplier");

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

=head2 products

Type: has_many

Related object: L<Impacto::Schema::Result::ProductProduct>

=cut

__PACKAGE__->has_many(
  "products",
  "Impacto::Schema::Result::ProductProduct",
  { "foreign.supplier" => "self.person" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07015 @ 2012-02-17 22:27:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:jvirLIiXMDj3XRn7wMu76A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
