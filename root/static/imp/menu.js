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
    "dojo/domReady!",
], function (dojo, ready) {
    ready(function () {
        dojo.style(dojo.byId('top-menu'), 'opacity', 1);
    });
});
