require([
    "dojo",
    "dojo/query",
    "dojo/ready",
    "imp/menu",
    "dojo/parser",
    "dijit/form/CheckBox",
    "dijit/form/CurrencyTextBox",
    "dijit/form/NumberTextBox",
    "dijit/form/TextBox",
    "dijit/form/ValidationTextBox",
    "dijit/form/Textarea",
    "dijit/form/DateTextBox",
    "dijit/form/FilteringSelect",
    "dijit/form/Button",
    "dijit/form/Form",
    "dijit/Editor",
    "dojo/domReady!"
], function (dojo, $, ready) {
    var node = $('form').pop();
    if (node)
        dojo.style(node, 'opacity', 1);
});
