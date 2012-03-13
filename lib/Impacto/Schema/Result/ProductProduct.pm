use utf8;
package Impacto::Schema::Result::ProductProduct;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Impacto::Schema::Result::ProductProduct

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

=head1 TABLE: C<product.product>

=cut

__PACKAGE__->table("product.product");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'product.product_id_seq'

=head2 name

  data_type: 'text'
  is_nullable: 0

=head2 supplier

  data_type: 'text'
  is_foreign_key: 1
  is_nullable: 1

=head2 cost

  data_type: 'money'
  is_nullable: 0

=head2 minimum_price

  data_type: 'money'
  is_nullable: 1

=head2 price

  data_type: 'money'
  is_nullable: 0

=head2 weight

  data_type: 'double precision'
  is_nullable: 1

=head2 image

  data_type: 'bytea'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "product.product_id_seq",
  },
  "name",
  { data_type => "text", is_nullable => 0 },
  "supplier",
  { data_type => "text", is_foreign_key => 1, is_nullable => 1 },
  "cost",
  { data_type => "money", is_nullable => 0 },
  "minimum_price",
  { data_type => "money", is_nullable => 1 },
  "price",
  { data_type => "money", is_nullable => 0 },
  "weight",
  { data_type => "double precision", is_nullable => 1 },
  "image",
  { data_type => "bytea", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 consignations

Type: has_many

Related object: L<Impacto::Schema::Result::ProductConsignation>

=cut

__PACKAGE__->has_many(
  "consignations",
  "Impacto::Schema::Result::ProductConsignation",
  { "foreign.product" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 product_categories

Type: has_many

Related object: L<Impacto::Schema::Result::ProductProductCategory>

=cut

__PACKAGE__->has_many(
  "product_categories",
  "Impacto::Schema::Result::ProductProductCategory",
  { "foreign.product" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 product_metas

Type: has_many

Related object: L<Impacto::Schema::Result::ProductProductMeta>

=cut

__PACKAGE__->has_many(
  "product_metas",
  "Impacto::Schema::Result::ProductProductMeta",
  { "foreign.product" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 product_stocks

Type: has_many

Related object: L<Impacto::Schema::Result::ProductProductStock>

=cut

__PACKAGE__->has_many(
  "product_stocks",
  "Impacto::Schema::Result::ProductProductStock",
  { "foreign.product" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 stock_movements

Type: has_many

Related object: L<Impacto::Schema::Result::ProductStockMovement>

=cut

__PACKAGE__->has_many(
  "stock_movements",
  "Impacto::Schema::Result::ProductStockMovement",
  { "foreign.product" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 subscriptions

Type: has_many

Related object: L<Impacto::Schema::Result::ProductSubscription>

=cut

__PACKAGE__->has_many(
  "subscriptions",
  "Impacto::Schema::Result::ProductSubscription",
  { "foreign.product" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 supplier

Type: belongs_to

Related object: L<Impacto::Schema::Result::PeopleSupplier>

=cut

__PACKAGE__->belongs_to(
  "supplier",
  "Impacto::Schema::Result::PeopleSupplier",
  { person => "supplier" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 categories

Type: many_to_many

Composing rels: L</product_categories> -> category

=cut

__PACKAGE__->many_to_many("categories", "product_categories", "category");


# Created by DBIx::Class::Schema::Loader v0.07015 @ 2012-03-13 00:13:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:chR2XlkrkxxbXx1Huqe5WQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
