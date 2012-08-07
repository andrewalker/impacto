define([
    "dojo/_base/declare",
    "dijit/MenuItem",
    "dojo/query",
    "dojo/NodeList-traverse",
    "dojo/NodeList-manipulate"
], function(declare, MenuItem, query) {

    return declare('imp.MenuItem', MenuItem, {
        postCreate: function () {
            this.inherited(arguments);
            var nl = new query.NodeList(this.domNode);
            nl.children(".dijitMenuItemLabel").wrapInner("<a href='" + this.get('href') + "'></a>");
        },

        onClick: function () {
            location.href = this.get('href');
        }
    });

});
