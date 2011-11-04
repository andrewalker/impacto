package Impacto::Schema::Product::Result::Category;

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

Impacto::Schema::Product::Result::Category

=cut

__PACKAGE__->table("category");

=head1 ACCESSORS

=head2 slug

  data_type: 'text'
  is_nullable: 0

=head2 parent

  data_type: 'text'
  is_nullable: 1

=head2 name

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "slug",
  { data_type => "text", is_nullable => 0 },
  "parent",
  { data_type => "text", is_nullable => 1 },
  "name",
  { data_type => "text", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("slug");

=head1 RELATIONS

=head2 product_categories

Type: has_many

Related object: L<Impacto::Schema::Product::Result::ProductCategory>

=cut

__PACKAGE__->has_many(
  "product_categories",
  "Impacto::Schema::Product::Result::ProductCategory",
  { "foreign.category" => "self.slug" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2011-11-04 11:21:41
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:2Q2QFdFJ9Bnx7ifB0Qc9Tw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
