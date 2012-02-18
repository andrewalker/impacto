use utf8;
package Impacto::Schema::Result::FinanceAccount;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Impacto::Schema::Result::FinanceAccount

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

=head1 TABLE: C<finance.account>

=cut

__PACKAGE__->table("finance.account");

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
  default_value: 'R$0,00'
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
  { data_type => "money", default_value => "R\$0,00", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</name>

=back

=cut

__PACKAGE__->set_primary_key("name");

=head1 RELATIONS

=head2 installment_payments

Type: has_many

Related object: L<Impacto::Schema::Result::FinanceInstallmentPayment>

=cut

__PACKAGE__->has_many(
  "installment_payments",
  "Impacto::Schema::Result::FinanceInstallmentPayment",
  { "foreign.account" => "self.name" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 ledgers

Type: has_many

Related object: L<Impacto::Schema::Result::FinanceLedger>

=cut

__PACKAGE__->has_many(
  "ledgers",
  "Impacto::Schema::Result::FinanceLedger",
  { "foreign.account" => "self.name" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07015 @ 2012-02-18 03:08:01
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:mCCtTIIYo5R5usjTdTVlKw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
