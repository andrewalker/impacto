define([
    "dojo",
    "dojo/ready",
    "dojo/parser",
    "dijit/Menu",
    "imp/MenuItem",
    "imp/MenuBarItem",
    "dijit/MenuBar",
    "dijit/PopupMenuBarItem",
    "dijit/PopupMenuItem",
    "dojo/domReady!"
], function (dojo, ready) {
    var menu = dojo.byId('top-menu');
    if (menu)
        dojo.style(menu, 'opacity', 1);
});
