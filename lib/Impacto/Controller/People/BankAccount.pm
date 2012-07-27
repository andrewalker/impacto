package Impacto::Controller::People::BankAccount;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Impacto::ControllerBase::CRUD' }

has '+crud_model_name' => ( default => 'DB::PeopleBankAccount' );

sub datagrid_columns {
    [qw/ person bank account agency /];
}

sub datagrid_columns_extra_params {
    {
        person => { fk => 'person.name' }
    }
}

sub form_columns_extra_params {
    {
        person => { x_field_factory => "DBIC::BelongsTo", option_label => 'name', option_value => 'slug', },
        comments => { field_class => 'LongText' },
    }
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=encoding utf8

=head1 NAME

Impacto::Controller::People::BankAccount - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=head1 AUTHOR

André Walker

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.
