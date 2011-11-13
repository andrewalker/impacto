dojo.require("dijit.Menu");
dojo.require("dijit.MenuItem");
dojo.require("dijit.MenuBar");
dojo.require("dijit.MenuBarItem");
dojo.require("dijit.PopupMenuBarItem");
dojo.require("dijit.PopupMenuItem");
dojo.require("dijit.form.TextBox");
dojo.require("dijit.form.Button");
dojo.require("dojo.parser");
dojo.require("dojox.grid.EnhancedGrid");
dojo.require("dojox.grid.enhanced.plugins.DnD");
dojo.require("dojox.grid.enhanced.plugins.Menu");
dojo.require("dojox.grid.enhanced.plugins.NestedSorting");
dojo.require("dojox.grid.enhanced.plugins.IndirectSelection");
dojo.require("dojo.data.ItemFileWriteStore");

dojo.ready(function() {
    var dataStore = new dojo.data.ItemFileWriteStore({
        "url": "http://localhost:3000/static/js/jsondata.js"
    });

    dojo.xhrGet({
        url: "http://localhost:3000/static/js/structure.js",
        load: function (structure) {
            var grid = new dojox.grid.EnhancedGrid(
                {
                    query: {
                        id: '*'
                    },
                    store: dataStore,
                    clientSort: true,
                    rowSelector: '20px',
                    structure: eval(structure),
                    plugins: {
                        nestedSorting: true,
                        dnd: true,
                        indirectSelection: true
                    },
                    id: 'datagrid-table'
                },
                document.createElement('div')
            );
            dojo.byId("datagrid").appendChild(grid.domNode);
            grid.startup();
        }
    });
});
