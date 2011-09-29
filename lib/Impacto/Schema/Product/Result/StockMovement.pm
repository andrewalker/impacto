package Impacto::Schema::Product::Result::StockMovement;

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

Impacto::Schema::Product::Result::StockMovement

=cut

__PACKAGE__->table("stock_movement");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'product.stock_movement_id_seq'

=head2 datetime

  data_type: 'timestamp'
  is_nullable: 0

=head2 amount

  data_type: 'integer'
  is_nullable: 0

=head2 type

  data_type: 'enum'
  extra: {custom_type_name => "stock_movement_type",list => ["sell","buy","consignation","return","donation","relocation"]}
  is_nullable: 0

=head2 place

  data_type: 'text'
  is_foreign_key: 1
  is_nullable: 0

=head2 product

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "product.stock_movement_id_seq",
  },
  "datetime",
  { data_type => "timestamp", is_nullable => 0 },
  "amount",
  { data_type => "integer", is_nullable => 0 },
  "type",
  {
    data_type => "enum",
    extra => {
      custom_type_name => "stock_movement_type",
      list => ["sell", "buy", "consignation", "return", "donation", "relocation"],
    },
    is_nullable => 0,
  },
  "place",
  { data_type => "text", is_foreign_key => 1, is_nullable => 0 },
  "product",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 consignations

Type: has_many

Related object: L<Impacto::Schema::Product::Result::Consignation>

=cut

__PACKAGE__->has_many(
  "consignations",
  "Impacto::Schema::Product::Result::Consignation",
  { "foreign.stock_movement" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 returns

Type: has_many

Related object: L<Impacto::Schema::Product::Result::Return>

=cut

__PACKAGE__->has_many(
  "returns",
  "Impacto::Schema::Product::Result::Return",
  { "foreign.stock_movement" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 place

Type: belongs_to

Related object: L<Impacto::Schema::Product::Result::Place>

=cut

__PACKAGE__->belongs_to(
  "place",
  "Impacto::Schema::Product::Result::Place",
  { place => "place" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 product

Type: belongs_to

Related object: L<Impacto::Schema::Product::Result::Product>

=cut

__PACKAGE__->belongs_to(
  "product",
  "Impacto::Schema::Product::Result::Product",
  { id => "product" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2011-09-29 20:02:46
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:JiILbY66E0zGMyk6Dwqd9g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
