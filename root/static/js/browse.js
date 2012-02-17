dojo.require("dojo.data.ItemFileReadStore");
dojo.require("dojox.grid.EnhancedGrid");
dojo.require("dojox.grid.enhanced.plugins.Menu");
dojo.require("dojox.grid.enhanced.plugins.NestedSorting");
dojo.require("dojox.grid.enhanced.plugins.IndirectSelection");


dojo.require("dijit.form.TextBox");
dojo.require("dijit.form.Button");

/*
dojo.require("dojox.grid.enhanced.plugins.DnD");
*/
var datagrid_table;
var timeout = 0;
var last_term = '';
var row_index;

function datagrid_row_click_event(e) {
    if (dojo.hasClass(e.target, 'dojoxGridCell'))
        location.href = table_prefix_uri + '/' + datagrid_table.getItem(datagrid_table.focus.rowIndex)._esid[0] + '/update';
}

function set_row_index(e) {
    row_index = e.rowIndex;
}

function search_input_keypress(e) {
    var term = e.currentTarget.value;

    if (timeout)
        clearTimeout(timeout);
    if (last_term == term)
        return;

    timeout = setTimeout(function () { execute_search(term) }, 700);
}

function execute_search(term) {
    last_term = term;
    datagrid_table.store.close();
    datagrid_table.store.url = table_prefix_uri + '/list_json_data?q=' + encodeURI(term);
    datagrid_table.store.fetch();
    datagrid_table._refresh();
    timeout = 0;
}

function delete_row(e) {
    _delete([ datagrid_table.getItem(row_index)._esid[0] ]);
}

function delete_selected(e) {
    var selected_rows = datagrid_table.selection.getSelected();
    var ids = new Array();

    for (var i = 0; i < selected_rows.length; i++)
        ids.push(selected_rows[i]._esid[0]);

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

dojo.addOnLoad(function () {
    dojo.connect(datagrid_table, 'onRowContextMenu', set_row_index);
    dojo.connect(datagrid_table, "onRowClick", datagrid_row_click_event);
    dojo.connect(datagrid_table, "_onFetchComplete", function () { dojo.byId('input_query').focus() });
    dojo.connect(dojo.byId('input_query'), "onkeyup", search_input_keypress);

    datagrid_table.layout.setColumnVisibility(1, false);
});
