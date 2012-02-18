use utf8;
package Impacto::Schema::Result::PeopleContact;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Impacto::Schema::Result::PeopleContact

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

=head1 TABLE: C<people.contact>

=cut

__PACKAGE__->table("people.contact");

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

=head1 PRIMARY KEY

=over 4

=item * L</client>

=back

=cut

__PACKAGE__->set_primary_key("client");

=head1 RELATIONS

=head2 client

Type: belongs_to

Related object: L<Impacto::Schema::Result::PeopleClient>

=cut

__PACKAGE__->belongs_to(
  "client",
  "Impacto::Schema::Result::PeopleClient",
  { person => "client" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07015 @ 2012-02-17 22:27:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:S5CTtLxhjEm3xhaGmorF4w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
