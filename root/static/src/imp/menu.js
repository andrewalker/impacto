define([
    "dojo",
    "dojo/parser",
    "dijit/Menu",
    "imp/MenuItem",
    "imp/MenuBarItem",
    "dijit/MenuBar",
    "dijit/PopupMenuBarItem",
    "dijit/PopupMenuItem",
    "dojo/domReady!"
], function (dojo, parser) {
    var menu = dojo.byId('top-menu');
    if (menu) {
        parser.parse('top-menu');
        dojo.style(menu, 'opacity', 1);
    }
});
