define([
    "dojo/_base/declare",
    "dijit/MenuBarItem",
    "dojo/query",
    "dojo/NodeList-traverse",
    "dojo/NodeList-manipulate"
], function(declare, MenuBarItem, query) {

    return declare('imp.MenuBarItem', MenuBarItem, {
        postCreate: function () {
            this.inherited(arguments);
            var nl = new query.NodeList(this.domNode);
            nl.children("span").wrapInner("<a href='" + this.get('href') + "'></a>");
        },

        onClick: function () {
            location.href = this.get('href');
        }
    });

});
