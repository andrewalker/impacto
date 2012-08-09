require([ 'dojo', 'dojo/ready', 'imp/SearchBar', 'dojo/_base/fx' ],
function (dojo, ready) {
    ready(function () {
        dojo.fadeIn({
            node: 'search'
        }).play();
    });
});

function remove_selected() {
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

require([
    "dgrid/selector",
    "imp/DGridStore",
    "imp/DGrid",
    "dojo/domReady!"
],
function (selector, DGridStore, DGrid) {
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
