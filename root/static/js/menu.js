require([
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
], function (dojo) {
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
    dojo.addOnLoad(function () {
        dojo.fadeIn({
            node: 'top-menu'
//          onEnd: hideLoader
        }).play();
    });
});
