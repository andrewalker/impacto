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

=head2 slug

  data_type: 'text'
  is_foreign_key: 1
  is_nullable: 0

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_foreign_key: 1
  is_nullable: 0
  sequence: 'product.product_category_id_seq'

=cut

__PACKAGE__->add_columns(
  "slug",
  { data_type => "text", is_foreign_key => 1, is_nullable => 0 },
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_foreign_key    => 1,
    is_nullable       => 0,
    sequence          => "product.product_category_id_seq",
  },
);
__PACKAGE__->set_primary_key("slug", "id");

=head1 RELATIONS

=head2 id

Type: belongs_to

Related object: L<Impacto::Schema::Product::Result::Product>

=cut

__PACKAGE__->belongs_to(
  "id",
  "Impacto::Schema::Product::Result::Product",
  { id => "id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 slug

Type: belongs_to

Related object: L<Impacto::Schema::Product::Result::Category>

=cut

__PACKAGE__->belongs_to(
  "slug",
  "Impacto::Schema::Product::Result::Category",
  { slug => "slug" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2011-09-26 20:07:25
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:iDIUDvkpIZcraDtFCfO0QQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
