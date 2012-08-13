require([ 'imp/menu', 'imp/search', 'imp/grid' ]);

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
