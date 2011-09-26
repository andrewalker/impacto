package Impacto::Schema::People::Result::BankAccount;

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

Impacto::Schema::People::Result::BankAccount

=cut

__PACKAGE__->table("bank_account");

=head1 ACCESSORS

=head2 person

  data_type: 'text'
  is_foreign_key: 1
  is_nullable: 0

=head2 bank

  data_type: 'text'
  is_nullable: 0

=head2 account

  data_type: 'text'
  is_nullable: 0

=head2 agency

  data_type: 'text'
  is_nullable: 1

=head2 is_savings_account

  data_type: 'boolean'
  default_value: false
  is_nullable: 0

=head2 comments

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "person",
  { data_type => "text", is_foreign_key => 1, is_nullable => 0 },
  "bank",
  { data_type => "text", is_nullable => 0 },
  "account",
  { data_type => "text", is_nullable => 0 },
  "agency",
  { data_type => "text", is_nullable => 1 },
  "is_savings_account",
  { data_type => "boolean", default_value => \"false", is_nullable => 0 },
  "comments",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("person", "bank", "account");

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


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2011-09-26 20:07:24
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:4KegXE5T3HOKh1dBaHey0Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
