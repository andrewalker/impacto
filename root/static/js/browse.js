dojo.require("dojox.grid.EnhancedGrid");
dojo.require("dojox.grid.enhanced.plugins.Menu");
dojo.require("dojox.grid.enhanced.plugins.NestedSorting");
dojo.require("dojox.grid.enhanced.plugins.IndirectSelection");
dojo.require("dojox.grid.enhanced.plugins.Pagination");
dojo.require("dojox.data.QueryReadStore");


dojo.require("dijit.form.TextBox");
dojo.require("dijit.form.Button");

/*
dojo.require("dojox.grid.enhanced.plugins.DnD");
*/
var datagrid_layout;
var datagrid_table;
var timeout = 0;
var last_term = '';
var row_index;

function datagrid_row_click_event(e) {
    if (dojo.hasClass(e.target, 'dojoxGridCell'))
        location.href = table_prefix_uri + '/' + datagrid_table.getItem(datagrid_table.focus.rowIndex).i._esid + '/update';
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

dojo.addOnLoad(function () {
    dojo.connect(datagrid_table, 'onRowContextMenu', set_row_index);
    dojo.connect(datagrid_table, "onRowClick", datagrid_row_click_event);
    dojo.connect(datagrid_table, "_onFetchComplete", function () { dojo.byId('input_query').focus() });
    dojo.connect(dojo.byId('input_query'), "onkeyup", search_input_keypress);

    var datagrid_store = new dojox.data.QueryReadStore({
        clearOnClose: true,
        url:          table_prefix_uri + '/list_json_data',
        identity:     '_esid'
    });

    datagrid_table = new dojox.grid.EnhancedGrid({
        plugins: {
            pagination: {
                pageSizes: [ "10", "25", "50", "100", "All" ],
                description: true,
                sizeSwitch: true,
                pageStepper: true,
                gotoButton: true,
                maxPageStep: 4,
                position: "bottom"
            },
            menus: {
                rowMenu:            'rowMenu',
                selectedRegionMenu: 'selectedRegionMenu'
            },
            nestedSorting:     true,
            indirectSelection: true
        },
        structure: datagrid_layout,
        store: datagrid_store,
        rowSelector: '20px',
        id: 'datagrid-table'
    }, document.createElement('div'));

    dojo.byId("datagrid").appendChild(datagrid_table.domNode);

    datagrid_table.startup();


/*
    <table data-dojo-id="datagrid_table"  id="datagrid_table" data-dojo-type="dojox.grid.EnhancedGrid" data-dojo-props="datagrid_props" style="height: 400px">
        <thead>
            <tr>
            </tr>
        </thead>
    </table>
    */
    datagrid_table.layout.setColumnVisibility(1, false);
});
