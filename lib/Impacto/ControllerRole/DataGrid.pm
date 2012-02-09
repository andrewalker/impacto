package Impacto::ControllerRole::DataGrid;
use utf8;
use Moose::Role;
use List::Util qw/first reduce/;
use namespace::autoclean;

has datagrid_columns => (
    isa        => 'ArrayRef',
    is         => 'ro',
    lazy_build => 1,
);

has datagrid_columns_extra_params => (
    isa        => 'HashRef',
    is         => 'ro',
    lazy_build => 1,
);

requires 'crud_model_instance';

# in the controller it would be like:
# sub _build_datagrid_columns {
#   return [ qw/ name date special_date_time customer_name custom_width_column / ]
# }
# sub _build_datagrid_columns_extra_params {
#    return {
#       special_date_time   => { format => '%d - %m - %Y' },
#       customer_name       => { fk => 'customer.name' },
#       custom_width_column => { width => '40%' },
#    }
# }
sub _build_datagrid_columns { shift->get_all_columns(@_) }
sub _build_datagrid_columns_extra_params { +{} }

# FIXME: Dependency Injection: the $c makes this untestable
sub get_browse_structure {
    my ( $self, $c ) = @_;

    my $from = $self->crud_model_instance->result_source->from;

    return [
        {
            field => '_esid',
            name => 'ID',
        },
        map {
            +{
                field => $_,
                name => $c->model('Maketext')->maketext("crud." . $from . ".$_"),
                editable => 0,
                width => 'auto',
            }
        } @{ $self->datagrid_columns }
    ];
}

sub get_elastic_search_insert_data {
    my ( $self, $row ) = @_;

    my $columns_info = $row->result_source->columns_info;
    my $extra_params = $self->datagrid_columns_extra_params;

    my %data = (
        _pks => {
            map { $_ => $row->get_column( $_ ) }
                $row->result_source->primary_columns
        }
    );

    for my $column ( @{ $self->datagrid_columns } ) {
        my $column_info   = $columns_info->{$column};
        my $column_params = $extra_params->{$column};

        if ( $column_info && _is_date($column_info->{data_type}) ) {
            my $format     = $column_params && $column_params->{format}
                           ? $column_params->{format}
                           : '%d/%m/%Y'
                           ;

            $data{$column} = $row->$column->strftime( $format );
        }
        elsif (my $fk = $column_params->{fk}) {
            my @items      = split /\./, $fk;
            $data{$column} = reduce { $a->$b } $row, @items;
        }
        else {
            $data{$column} = $row->get_column($column);
        }
    }

    return \%data;
}

sub _is_date {
    my $type = shift;

    my @date_types = qw(
        date datetime timestamp
    );

    return first { $_ eq $type } @date_types;
}

1;
