package Impacto::Schema::Finance::Result::Account;

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

Impacto::Schema::Finance::Result::Account

=cut

__PACKAGE__->table("account");

=head1 ACCESSORS

=head2 name

  data_type: 'text'
  is_nullable: 0

=head2 bank

  data_type: 'text'
  is_nullable: 1

=head2 account_number

  data_type: 'text'
  is_nullable: 1

=head2 agency

  data_type: 'text'
  is_nullable: 1

=head2 balance

  data_type: 'money'
  default_value: '$0.00'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "name",
  { data_type => "text", is_nullable => 0 },
  "bank",
  { data_type => "text", is_nullable => 1 },
  "account_number",
  { data_type => "text", is_nullable => 1 },
  "agency",
  { data_type => "text", is_nullable => 1 },
  "balance",
  { data_type => "money", default_value => "\$0.00", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("name");

=head1 RELATIONS

=head2 installment_payments

Type: has_many

Related object: L<Impacto::Schema::Finance::Result::InstallmentPayment>

=cut

__PACKAGE__->has_many(
  "installment_payments",
  "Impacto::Schema::Finance::Result::InstallmentPayment",
  { "foreign.account" => "self.name" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 ledgers

Type: has_many

Related object: L<Impacto::Schema::Finance::Result::Ledger>

=cut

__PACKAGE__->has_many(
  "ledgers",
  "Impacto::Schema::Finance::Result::Ledger",
  { "foreign.account" => "self.name" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2011-09-26 20:07:27
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:dRRN1tkz8CztxccKNyP6xw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
