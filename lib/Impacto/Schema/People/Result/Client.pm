package Impacto::Schema::People::Result::Client;

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

Impacto::Schema::People::Result::Client

=cut

__PACKAGE__->table("client");

=head1 ACCESSORS

=head2 person

  data_type: 'text'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "person",
  { data_type => "text", is_foreign_key => 1, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("person");

=head1 RELATIONS

=head2 person

Type: belongs_to

Related object: L<Impacto::Schema::People::Result::Person>

=cut

__PACKAGE__->belongs_to(
  "person",
  "Impacto::Schema::People::Result::Person",
  { slug => "person" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 contact

Type: might_have

Related object: L<Impacto::Schema::People::Result::Contact>

=cut

__PACKAGE__->might_have(
  "contact",
  "Impacto::Schema::People::Result::Contact",
  { "foreign.client" => "self.person" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2011-09-26 20:07:24
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:bXlirNAH+laYr7d+ucaFhg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;