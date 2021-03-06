use utf8;
package Impacto::Schema::Result::ProductPlace;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Impacto::Schema::Result::ProductPlace

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

=head1 TABLE: C<product.place>

=cut

__PACKAGE__->table("product.place");

=head1 ACCESSORS

=head2 place

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns("place", { data_type => "text", is_nullable => 0 });

=head1 PRIMARY KEY

=over 4

=item * L</place>

=back

=cut

__PACKAGE__->set_primary_key("place");

=head1 RELATIONS

=head2 product_stocks

Type: has_many

Related object: L<Impacto::Schema::Result::ProductProductStock>

=cut

__PACKAGE__->has_many(
  "product_stocks",
  "Impacto::Schema::Result::ProductProductStock",
  { "foreign.place" => "self.place" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 stock_movements

Type: has_many

Related object: L<Impacto::Schema::Result::ProductStockMovement>

=cut

__PACKAGE__->has_many(
  "stock_movements",
  "Impacto::Schema::Result::ProductStockMovement",
  { "foreign.place" => "self.place" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07015 @ 2012-02-17 22:27:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:cY6idjE00CI8/B77YHreGg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
