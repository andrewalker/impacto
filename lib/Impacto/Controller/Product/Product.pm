package Impacto::Controller::Product::Product;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Impacto::ControllerBase::CRUD' }

sub form_columns {
    [qw/
         name supplier cost minimum_price price weight image categories product_metas
    /]
}
sub form_columns_extra_params {
    {
        supplier      => { x_field_factory => "DBIC::BelongsTo", option_label => 'person', option_value => 'person' },
        image         => { x_field_class => 'FileSelector::CatalystByteA' },
        categories    => { x_field_factory => 'DBIC::ManyToMany', option_label => 'name', option_value => 'slug' },
        product_metas => { x_field_factory => 'DBIC::RecordMeta',
            metas => [
                { name => 'ISBN' },
            ]
        },
    }
}

sub datagrid_columns {
    [qw/
        name supplier price
    /]
}

sub datagrid_columns_extra_params {
    {
        supplier => { fk => 'supplier.person.name' }
    }
}

has '+crud_model_name' => ( default => 'DB::ProductProduct' );

__PACKAGE__->meta->make_immutable;

1;

__END__

=encoding utf8

=head1 NAME

Impacto::Controller::Product::Product - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=head1 AUTHOR

André Walker

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.
