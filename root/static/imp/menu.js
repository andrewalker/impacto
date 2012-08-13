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
        dojo.byId('top-menu').style('opacity', 1);
    });
});
