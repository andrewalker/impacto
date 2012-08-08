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
        grid.set('query', '?q=' + term);
        timeout = 0;
    }
});

// datagrid
require([
    "dojo",
    "dojo/_base/declare",
    "dijit/registry",

    "dojo/dom",
    "dojo/on",

    "dgrid/Grid",
    "dgrid/Keyboard",
    "dgrid/selector",
    "dgrid/Selection",
    "dgrid/extensions/Pagination",
    "dojo/store/Cache",
    "dojo/store/JsonRest",
    "dojo/store/Memory",

    "dojo/dom-class",
    "dojo/domReady!",
],
function (dojo, declare, registry, dom, on, /* Menu, MenuItem, */ Grid, Keyboard, selector, Selection, Pagination, Cache, JsonStore, Memory, domclass) {

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

    var datagrid_store = Cache(new JsonStore({
        target:       table_prefix_uri + '/list_json_data',
        sortParam:    'sort',
        idProperty:   '_esid',
        query: function (query, options) {
            var r = JsonStore.prototype.query.call(this, query, options);
            var iq;
            if ( iq = registry.byId('input_query') )
                iq.focus();
            else
                dojo.addOnLoad(function() {
                    registry.byId('input_query').focus();
                });
            return r;
        }
    }), Memory());

    datagrid_layout.unshift(selector({ field: 'checkbox', label: ' ' }));

    window.grid = new declare([Grid, Pagination, Keyboard, Selection], {
        gotoPage: function () {
            var args = arguments;
            args[1] = false;
            this.inherited(args);
        }
    })({
        rowsPerPage:        15,
        previousNextArrows: true,
        firstLastArrows:    true,
        pageSizeOptions:    [ 15, 50, 100 ],
        columns:            datagrid_layout,
        store:              datagrid_store,
        selectionMode:      'single',
        id:                 'datagrid-table'
    }, 'datagrid');

    grid.on(".dgrid-content .dgrid-row:click", function(evt){
        var row = grid.row(evt);
        location.href = table_prefix_uri + '/' + row.data._esid + '/update';
    });
});
