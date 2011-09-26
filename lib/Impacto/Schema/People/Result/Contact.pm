package Impacto::Schema::People::Result::Contact;

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

Impacto::Schema::People::Result::Contact

=cut

__PACKAGE__->table("contact");

=head1 ACCESSORS

=head2 client

  data_type: 'text'
  is_foreign_key: 1
  is_nullable: 0

=head2 date

  data_type: 'date'
  default_value: current_timestamp
  is_nullable: 0
  original: {default_value => \"now()"}

=head2 answered

  data_type: 'boolean'
  default_value: false
  is_nullable: 0

=head2 type

  data_type: 'text'
  is_nullable: 0

=head2 abstract

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "client",
  { data_type => "text", is_foreign_key => 1, is_nullable => 0 },
  "date",
  {
    data_type     => "date",
    default_value => \"current_timestamp",
    is_nullable   => 0,
    original      => { default_value => \"now()" },
  },
  "answered",
  { data_type => "boolean", default_value => \"false", is_nullable => 0 },
  "type",
  { data_type => "text", is_nullable => 0 },
  "abstract",
  { data_type => "text", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("client");

=head1 RELATIONS

=head2 client

Type: belongs_to

Related object: L<Impacto::Schema::People::Result::Client>

=cut

__PACKAGE__->belongs_to(
  "client",
  "Impacto::Schema::People::Result::Client",
  { person => "client" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2011-09-26 20:07:24
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:iJJyQqoB60qvKL+vO9uG0w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
