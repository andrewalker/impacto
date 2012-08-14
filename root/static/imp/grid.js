define([
    "dgrid/selector",
    "imp/DGridStore",
    "imp/DGrid",
    "dojo/domReady!"
],
function (selector, DGridStore, DGrid) {
    if (typeof table_prefix_uri == 'undefined')
        return;

    var datagrid_store = DGridStore({
        target:       table_prefix_uri + '/json_rest/',
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
