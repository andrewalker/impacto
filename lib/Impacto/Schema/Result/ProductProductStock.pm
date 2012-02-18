use utf8;
package Impacto::Schema::Result::ProductProductStock;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Impacto::Schema::Result::ProductProductStock

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

=head1 TABLE: C<product.product_stock>

=cut

__PACKAGE__->table("product.product_stock");

=head1 ACCESSORS

=head2 product

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 place

  data_type: 'text'
  is_foreign_key: 1
  is_nullable: 0

=head2 amount

  data_type: 'integer'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "product",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "place",
  { data_type => "text", is_foreign_key => 1, is_nullable => 0 },
  "amount",
  { data_type => "integer", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</product>

=item * L</place>

=back

=cut

__PACKAGE__->set_primary_key("product", "place");

=head1 RELATIONS

=head2 place

Type: belongs_to

Related object: L<Impacto::Schema::Result::ProductPlace>

=cut

__PACKAGE__->belongs_to(
  "place",
  "Impacto::Schema::Result::ProductPlace",
  { place => "place" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 product

Type: belongs_to

Related object: L<Impacto::Schema::Result::ProductProduct>

=cut

__PACKAGE__->belongs_to(
  "product",
  "Impacto::Schema::Result::ProductProduct",
  { id => "product" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07015 @ 2012-02-17 22:27:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:1AQiomFFWQPmkXqbeLOd3g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
