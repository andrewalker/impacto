package Impacto::Controller::Product::ProductStock;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Impacto::ControllerBase::CRUD' }

has '+crud_model_name' => ( default => 'DB::ProductProductStock' );
sub datagrid_columns {
    [qw/ place product amount /];
}

sub datagrid_columns_extra_params {
    {
        product => { fk => 'product.name' }
    }
}

sub form_columns_extra_params {
    {
        product => { x_field_factory => "DBIC::BelongsTo", option_label => 'name', option_value => 'id' },
        place   => { x_field_factory => "DBIC::BelongsTo", option_label => 'place' }
    }
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=encoding utf8

=head1 NAME

Impacto::Controller::Product::ProductStock - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=head1 AUTHOR

André Walker

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.
