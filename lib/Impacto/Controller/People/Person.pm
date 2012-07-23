package Impacto::Controller::People::Person;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Impacto::ControllerBase::CRUD' }

has '+crud_model_name' => ( default => 'DB::PeoplePerson' );

sub form_columns {
    [ qw/ slug name phone email site client employee representant supplier comments / ]
}

sub form_columns_extra_params {
    {
        slug         => { x_field_factory => 'DBIC::Slug', field_source => 'name' },
        comments     => { field_class     => 'LongText'                           },
        client       => { x_field_factory => 'DBIC::MightBe'                      },
        employee     => { x_field_factory => 'DBIC::MightBe'                      },
        representant => { x_field_factory => 'DBIC::MightBe'                      },
        supplier     => { x_field_factory => 'DBIC::MightBe'                      },
    }
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=encoding utf8

=head1 NAME

Impacto::Controller::People::Person - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=head1 AUTHOR

André Walker

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.
