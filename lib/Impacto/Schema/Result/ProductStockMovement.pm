use utf8;
package Impacto::Schema::Result::ProductStockMovement;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Impacto::Schema::Result::ProductStockMovement

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

=head1 TABLE: C<product.stock_movement>

=cut

__PACKAGE__->table("product.stock_movement");

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
  { "foreign.stock_movement" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 ledgers

Type: has_many

Related object: L<Impacto::Schema::Result::FinanceLedger>

=cut

__PACKAGE__->has_many(
  "ledgers",
  "Impacto::Schema::Result::FinanceLedger",
  { "foreign.stock_movement" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

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

=head2 returns

Type: has_many

Related object: L<Impacto::Schema::Result::ProductReturn>

=cut

__PACKAGE__->has_many(
  "returns",
  "Impacto::Schema::Result::ProductReturn",
  { "foreign.stock_movement" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07015 @ 2012-02-17 22:27:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:7/7Ky5MiycWPqG9S3C2Yjw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
