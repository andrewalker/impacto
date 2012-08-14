define([
    "dojo/_base/declare",
    "dijit/MenuBarItem",
	"dojo/text!./templates/MenuBarItem.html"
], function(declare, MenuBarItem, template) {

    return declare('imp.MenuBarItem', MenuBarItem, {
        templateString: template,
        onClick: function () {
            location.href = this.get('href');
        }
    });

});
