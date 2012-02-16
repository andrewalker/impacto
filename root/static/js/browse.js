dojo.require("dojo.data.ItemFileReadStore");
dojo.require("dojox.grid.EnhancedGrid");

dojo.require("dijit.form.TextBox");
dojo.require("dijit.form.Button");

/*
dojo.require("dojox.grid.enhanced.plugins.DnD");
dojo.require("dojox.grid.enhanced.plugins.Menu");
dojo.require("dojox.grid.enhanced.plugins.NestedSorting");
dojo.require("dojox.grid.enhanced.plugins.IndirectSelection");
*/

var datagrid_table;

dojo.addOnLoad(function () {
    dojo.connect(datagrid_table, "onRowClick", datagrid_row_click_event);
    dojo.connect(datagrid_table, "_onFetchComplete", function () { dojo.byId('input_query').focus() });
    dojo.connect(dojo.byId('input_query'), "onkeyup", search_input_keypress);

    datagrid_table.layout.setColumnVisibility(0, false);

    function datagrid_row_click_event(e) {
        location.href = table_prefix_uri + '/' + datagrid_table.getItem(datagrid_table.focus.rowIndex)._esid[0] + '/update';
    }
    function search_input_keypress(e) {
        var search_value = e.currentTarget.value;
        datagrid_table.store.close();
        datagrid_table.store.url = table_prefix_uri + '/list_json_data?q=' + encodeURI(search_value);
        datagrid_table.store.fetch();
        datagrid_table._refresh();
    }
});
