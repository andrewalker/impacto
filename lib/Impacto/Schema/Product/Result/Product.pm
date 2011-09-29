package Impacto::Schema::Product::Result::Product;

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

Impacto::Schema::Product::Result::Product

=cut

__PACKAGE__->table("product");

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

=head2 custom_fields

  data_type: 'text'
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
  { data_type => "text", is_nullable => 1 },
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
  "custom_fields",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 product_categories

Type: has_many

Related object: L<Impacto::Schema::Product::Result::ProductCategory>

=cut

__PACKAGE__->has_many(
  "product_categories",
  "Impacto::Schema::Product::Result::ProductCategory",
  { "foreign.id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 product_stocks

Type: has_many

Related object: L<Impacto::Schema::Product::Result::ProductStock>

=cut

__PACKAGE__->has_many(
  "product_stocks",
  "Impacto::Schema::Product::Result::ProductStock",
  { "foreign.product" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 stock_movements

Type: has_many

Related object: L<Impacto::Schema::Product::Result::StockMovement>

=cut

__PACKAGE__->has_many(
  "stock_movements",
  "Impacto::Schema::Product::Result::StockMovement",
  { "foreign.product" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 subscriptions

Type: has_many

Related object: L<Impacto::Schema::Product::Result::Subscription>

=cut

__PACKAGE__->has_many(
  "subscriptions",
  "Impacto::Schema::Product::Result::Subscription",
  { "foreign.product" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2011-09-29 20:09:18
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:C3/pCDSGJ4bO/mcPufiwig


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
