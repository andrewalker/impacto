require([
    "dojo",
    "dojo/query",
    "dojo/_base/fx",
    "dojo/parser",
    "dijit/form/CheckBox",
    "dijit/form/CurrencyTextBox",
    "dijit/form/NumberTextBox",
    "dijit/form/TextBox",
    "dijit/form/Textarea",
    "dijit/form/DateTextBox",
    "dijit/form/FilteringSelect",
    "dijit/form/Button",
    "dijit/Editor",
    "dojo/domReady!"
], function (dojo, $) {
    var node = $('form.fs_form').pop();
    dojo.addOnLoad(function () {
        dojo.fadeIn({
            node: node,
        }).play();
    });
});
