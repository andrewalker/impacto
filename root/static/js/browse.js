var datagrid_layout;

// search
require([
    "dojo",
    "dijit/registry",
    "dojo/on",
    "dijit/form/TextBox",
    "dijit/form/Button",
    "dojo/domReady!",
],
function (dojo, registry, on) {
    var timeout = 0;
    var last_term = '';

    dojo.addOnLoad(function () {
        dojo.fadeIn({
            node: 'search'
        }).play();
        registry.byId('input_query').on('keyup', search_input_keypress);
    });

    function search_input_keypress(e) {
        var term = this.get('value');

        if (timeout)
            clearTimeout(timeout);
        if (last_term == term)
            return;

        timeout = setTimeout(function () { execute_search(term) }, 700);
    }

    function execute_search(term) {
        last_term = term;
        var dg_table = registry.byId('datagrid-table');
        dg_table.store.close();
        dg_table.store.url = table_prefix_uri + '/list_json_data?q=' + encodeURI(term);
        dg_table.store.fetch();
        dg_table._refresh();
        timeout = 0;
    }
});

// datagrid
require([
    "dojo",
    "dijit/registry",

    "dojo/dom",
    "dojo/on",

    "dijit/Menu",
    "dijit/MenuItem",

    "dojox/grid/EnhancedGrid",
    "dojox/data/QueryReadStore",

    "dojo/dom-class",

    "dojox/grid/enhanced/plugins/Menu",
    "dojox/grid/enhanced/plugins/NestedSorting",
    "dojox/grid/enhanced/plugins/IndirectSelection",
    "dojox/grid/enhanced/plugins/Pagination",
    "dojo/domReady!",
],
function (dojo, registry, dom, on, Menu, MenuItem, Grid, Store, domclass) {
    // datagrid
    var row_index;
    var datagrid_table;

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

    function datagrid_row_click_event(e) {
        if (domclass.contains(e.target, 'dojoxGridCell'))
            location.href = table_prefix_uri + '/' + datagrid_table.getItem(datagrid_table.focus.rowIndex).i._esid + '/update';
    }

    function set_row_index(e) {
        row_index = e.rowIndex;
    }

    var row_menu = new Menu();
    row_menu.addChild(new MenuItem({
        "label": "Excluir",
        "onClick": delete_row
    }));
    var selection_menu = new Menu();
    selection_menu.addChild(new MenuItem({
        "label": "Excluir",
        "onClick": delete_selected
    }));

    row_menu.startup();
    selection_menu.startup();

    dojo.addClass(row_menu.domNode, 'datagridMenu');
    dojo.addClass(selection_menu.domNode, 'datagridMenu');

    var datagrid_store = new Store({
        clearOnClose: true,
        url:          table_prefix_uri + '/list_json_data',
        identity:     '_esid'
    });

    datagrid_table = new Grid({
        plugins: {
            pagination: {
                pageSizes: [ "1", "25", "50", "100" ],
                description: true,
                sizeSwitch: true,
                pageStepper: true,
                gotoButton: true,
                maxPageStep: 4,
                position: "bottom"
            },
            menus: {
                rowMenu:            row_menu
                //selectedRegionMenu: 'selectedRegionMenu'
            },
            nestedSorting:     true,
            indirectSelection: true
        },
        structure: datagrid_layout,
        store: datagrid_store,
        rowSelector: '20px',
        id: 'datagrid-table'
    }, document.createElement('div'));

    dom.byId("datagrid").appendChild(datagrid_table.domNode);

    datagrid_table.startup();

    datagrid_table.on('rowcontextmenu', set_row_index);
    datagrid_table.on("rowclick", datagrid_row_click_event);
    dojo.connect(datagrid_table, '_onFetchComplete', function () { registry.byId('input_query').focus() });

    datagrid_table.layout.setColumnVisibility(1, false);
});
