package Impacto::Schema::Product::Result::ProductCategory;

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

Impacto::Schema::Product::Result::ProductCategory

=cut

__PACKAGE__->table("product_category");

=head1 ACCESSORS

=head2 product

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 category

  data_type: 'text'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "product",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "category",
  { data_type => "text", is_foreign_key => 1, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("product", "category");

=head1 RELATIONS

=head2 category

Type: belongs_to

Related object: L<Impacto::Schema::Product::Result::Category>

=cut

__PACKAGE__->belongs_to(
  "category",
  "Impacto::Schema::Product::Result::Category",
  { slug => "category" },
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


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2011-11-04 11:21:41
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:WLe6fRRMqfGtlNnqsu6scw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
