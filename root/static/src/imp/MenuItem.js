define([
    "dojo/_base/declare",
    "dijit/MenuItem",
	"dojo/text!./templates/MenuItem.html"
], function(declare, MenuItem, template) {

    return declare('imp.MenuItem', MenuItem, {
        templateString: template,
        onClick: function () {
            location.href = this.get('href');
        }
    });

});
