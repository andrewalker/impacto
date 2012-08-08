define([
    "dojo/_base/declare",

    "dgrid/Grid",
    "dgrid/extensions/Pagination",
    "dgrid/Keyboard",
    "dgrid/Selection",

    "dojo/on"
], function (declare, Grid, Pagination, Keyboard, Selection) {
    return declare([Grid, Pagination, Keyboard, Selection], {
        gotoPage: function () {
            var args = arguments;
            args[1] = false;
            this.inherited(args);
        },
        postCreate: function () {
            this.inherited(arguments);
            this.on(".dgrid-content .dgrid-row:click", function(evt){
                var row = grid.row(evt);
                location.href = table_prefix_uri + '/' + row.data._esid + '/update';
            });
        }
    });
});
