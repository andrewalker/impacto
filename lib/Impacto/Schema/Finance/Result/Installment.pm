package Impacto::Schema::Finance::Result::Installment;

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

Impacto::Schema::Finance::Result::Installment

=cut

__PACKAGE__->table("installment");

=head1 ACCESSORS

=head2 ledger

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 due

  data_type: 'date'
  is_nullable: 0

=head2 amount

  data_type: 'money'
  is_nullable: 0

=head2 payed

  data_type: 'boolean'
  default_value: false
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "ledger",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "due",
  { data_type => "date", is_nullable => 0 },
  "amount",
  { data_type => "money", is_nullable => 0 },
  "payed",
  { data_type => "boolean", default_value => \"false", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("ledger", "due");

=head1 RELATIONS

=head2 ledger

Type: belongs_to

Related object: L<Impacto::Schema::Finance::Result::Ledger>

=cut

__PACKAGE__->belongs_to(
  "ledger",
  "Impacto::Schema::Finance::Result::Ledger",
  { id => "ledger" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 installment_payments

Type: has_many

Related object: L<Impacto::Schema::Finance::Result::InstallmentPayment>

=cut

__PACKAGE__->has_many(
  "installment_payments",
  "Impacto::Schema::Finance::Result::InstallmentPayment",
  { "foreign.due" => "self.due", "foreign.ledger" => "self.ledger" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2011-09-29 20:02:48
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:tqQVyxvN5CwfBoTc0sHAXQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
