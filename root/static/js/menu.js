require([
    "dojo/ready",
    "dojo",
    "dojo/_base/fx",
    "dojo/parser",
    "dijit/Menu",
    "imp/MenuItem",
    "imp/MenuBarItem",
    "dijit/MenuBar",
    "dijit/PopupMenuBarItem",
    "dijit/PopupMenuItem",
    "dojo/domReady!",
], function (ready, dojo) {
/*
    var hideLoader = function(){
        dojo.fadeOut({
            node:"preloader",
            duration:700,
            onEnd: function(){
                dojo.style("preloader", "display", "none");
            }
        }).play();
    };
*/
    ready(function () {
        dojo.fadeIn({
            node: 'top-menu'
//          onEnd: hideLoader
        }).play();
    });
});
