require([ 'dojo', 'imp/SearchBar', 'dojo/_base/fx' ],
function (dojo) {
    dojo.addOnLoad(function () {
        dojo.fadeIn({
            node: 'search'
        }).play();
    });
});

// datagrid
require([
    "dgrid/selector",
    "imp/DGridStore",
    "imp/DGrid",
    "dojo/domReady!"
],
function (selector, DGridStore, DGrid) {
/*
    function delete_row(e) {
        _delete([ datagrid_table.getItem(row_index).i._esid ]);
    }

    function delete_selected(e) {
        var selected_rows = datagrid_table.selection.getSelected();
        var ids = new Array();

        for (var i = 0; i < selected_rows.length; i++)
            ids.push(selected_rows[i].i._esid);

        _delete(ids);
    }

    function _delete(rows) {
        dojo.xhrPost({
            url: table_prefix_uri + '/delete',
            content: rows,
            load: function(data){
                datagrid_table.store.close();
                datagrid_table.store.url = table_prefix_uri + '/list_json_data?q=' + encodeURI(last_term);
                datagrid_table.store.fetch();
                datagrid_table._refresh();
                alert(data);
            },
            error: function(error){
                alert(error);
            }
        });
    }
    */

    var datagrid_store = DGridStore({
        target:       table_prefix_uri + '/list_json_data',
        sortParam:    'sort',
        idProperty:   '_esid'
    });

    datagrid_layout.unshift(selector({ field: 'checkbox', label: ' ' }));

    window.grid = new DGrid({
        rowsPerPage:        15,
        previousNextArrows: true,
        firstLastArrows:    true,
        pageSizeOptions:    [ 15, 50, 100 ],
        columns:            datagrid_layout,
        store:              datagrid_store,
        selectionMode:      'single',
        idProperty:         '_esid'
    }, 'datagrid');
});
