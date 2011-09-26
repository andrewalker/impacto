package Impacto::Schema::Product::Result::Subscription;

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

Impacto::Schema::Product::Result::Subscription

=cut

__PACKAGE__->table("subscription");

=head1 ACCESSORS

=head2 client

  data_type: 'text'
  is_nullable: 0

=head2 product

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 active

  data_type: 'boolean'
  default_value: true
  is_nullable: 0

=head2 subscription_date

  data_type: 'timestamp'
  default_value: current_timestamp
  is_nullable: 0
  original: {default_value => \"now()"}

=head2 subscription_edition

  data_type: 'integer'
  is_nullable: 1

=head2 expiry_date

  data_type: 'timestamp'
  is_nullable: 1

=head2 expiry_edition

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "client",
  { data_type => "text", is_nullable => 0 },
  "product",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "active",
  { data_type => "boolean", default_value => \"true", is_nullable => 0 },
  "subscription_date",
  {
    data_type     => "timestamp",
    default_value => \"current_timestamp",
    is_nullable   => 0,
    original      => { default_value => \"now()" },
  },
  "subscription_edition",
  { data_type => "integer", is_nullable => 1 },
  "expiry_date",
  { data_type => "timestamp", is_nullable => 1 },
  "expiry_edition",
  { data_type => "integer", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("client", "product");

=head1 RELATIONS

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


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2011-09-26 20:07:25
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:d5N7X10h3wI0/ddDoN1e1w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
