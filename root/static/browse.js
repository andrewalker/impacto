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
    var jsondata = {
        items: [
            {
                "id": '0001',
                "name": 'Deus Me Ama',
                "supplier": 'Editora X',
                "cost": 'R$ 15,00',
                "minimum_price": 'R$ 20,00',
                "price": 'R$ 30,00',
            },
            {
                "id": '0002',
                "name": 'Por que você não quer mais ir à igreja?',
                "supplier": 'Editora Y',
                "cost": 'R$ 15,00',
                "minimum_price": 'R$ 20,00',
                "price": 'R$ 30,00',
            },
            {
                "id": '0003',
                "name": 'Igreja Verdadeira / Igreja Falsa',
                "supplier": 'Editora Z',
                "cost": 'R$ 15,00',
                "minimum_price": 'R$ 20,00',
                "price": 'R$ 30,00',
            },
        ],
        identifier: "id"
    };
    var structure = [
        {
            "field": 'id',
            "name": "Código",
            "editable": true,
            "width": '10%',
        },
        {
            "field": 'name',
            "name": "Nome",
            "editable": true,
            "width": '30%',
        },
        {
            "field": 'supplier',
            "name": "Editora",
            "editable": true,
            "width": '20%'
        },
        {
            "field": 'cost',
            "name": "Custo",
            "editable": true,
            "width": '10%'
        },
        {
            "field": 'minimum_price',
            "name": "Preço Mínimo",
            "editable": true,
            "width": '10%'
        },
        {
            "field": 'price',
            "name": "Preço",
            "editable": true,
            "width": '20%'
        }
    ];

    var dataStore = new dojo.data.ItemFileWriteStore({
        "data": jsondata
    });
    var grid = new dojox.grid.EnhancedGrid(
        {
            query: {
                id: '*'
            },
            store: dataStore,
            clientSort: true,
            rowSelector: '20px',
            structure: structure,
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
});
