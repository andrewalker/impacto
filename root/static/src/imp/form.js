require({ cache: {} }, [
    "dojo",
    "dojo/query",
    "dojo/parser",
    "imp/menu",
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
], function (dojo, $, parser) {
    var node = $('form').pop();
    if (node) {
        dojo.style(node, 'opacity', 1);
        parser.parse(node);
    }
});
