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

    var first_column = datagrid_layout[1].field;
    datagrid_layout.unshift(selector({ field: 'checkbox', label: ' ' }));

    window.grid = new DGrid({
        sort:               [ { attribute: first_column, descending: false } ],
        rowsPerPage:        15,
        previousNextArrows: true,
        firstLastArrows:    true,
        pageSizeOptions:    [ 15, 50, 100 ],
        columns:            datagrid_layout,
        store:              datagrid_store,
        selectionMode:      'single',
        idProperty:         '_esid'
    }, 'datagrid');

    window.remove_selected = function () {
        smoke.confirm("Tem certeza que deseja remover?", function (answer) {
            if (!answer)
                return;

            var how_many = 0, finished = 0, done_all = false, alerted = false;
            var alert_message_p = 'Registros removidos';
            var alert_message   = 'Registro removido';

            for (var i in grid.selection) {
                how_many++;
                grid.store.remove(i).then(function () {
                    finished++;
                    if (done_all && finished == how_many) {
                        alerted = true;
                        smoke.alert(finished > 1 ? alert_message_p : alert_message);
                        grid.refresh();
                    }
                });
            }

            done_all = true;

            if (!alerted && finished == how_many) {
                smoke.alert(finished > 1 ? alert_message_p : alert_message);
                grid.refresh();
            }
        });
    }
});
