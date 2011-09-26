package Impacto::Schema::Product::Result::Place;

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

Impacto::Schema::Product::Result::Place

=cut

__PACKAGE__->table("place");

=head1 ACCESSORS

=head2 place

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns("place", { data_type => "text", is_nullable => 0 });
__PACKAGE__->set_primary_key("place");

=head1 RELATIONS

=head2 product_stocks

Type: has_many

Related object: L<Impacto::Schema::Product::Result::ProductStock>

=cut

__PACKAGE__->has_many(
  "product_stocks",
  "Impacto::Schema::Product::Result::ProductStock",
  { "foreign.place" => "self.place" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 stock_movements

Type: has_many

Related object: L<Impacto::Schema::Product::Result::StockMovement>

=cut

__PACKAGE__->has_many(
  "stock_movements",
  "Impacto::Schema::Product::Result::StockMovement",
  { "foreign.place" => "self.place" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2011-09-26 20:07:25
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:QkxXiNGuMLyfgan70V8ZyQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
