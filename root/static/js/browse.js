dojo.require("dojo.data.ItemFileReadStore");
dojo.require("dojo.parser");
dojo.require("dojox.grid.EnhancedGrid");

dojo.require("dijit.Menu");
dojo.require("dijit.MenuItem");
dojo.require("dijit.MenuBar");
dojo.require("dijit.MenuBarItem");
dojo.require("dijit.PopupMenuBarItem");
dojo.require("dijit.PopupMenuItem");
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
    dojo.connect(datagrid_table, "onRowClick", datagrid_row_click_event)

    datagrid_table.layout.setColumnVisibility(0, false);

    function datagrid_row_click_event(evento) {
        /* console.log(evento.currentTarget);
        console.log(datagrid_table.focus.rowIndex);
        console.log();
        console.log(datagrid_table.store.getIdentityAttributes(datagrid_table.getItem(datagrid_table.focus.rowIndex))); */
        location.href = './' + datagrid_table.getItem(datagrid_table.focus.rowIndex)._esid[0] + '/update';
    }
});
