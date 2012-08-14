define([
    "dojo/_base/declare",
    "dijit/form/TextBox",
    "dijit/form/Button",
    "dojo/on",
    "dojo/domReady!"
], function(declare, TextBox) {
    var timeout = 0;
    var last_term = '';

    function search_input_keypress(e) {
        var term = this.get('value');

        if (timeout)
            clearTimeout(timeout);
        if (last_term == term)
            return;

        timeout = setTimeout(function () { execute_search(term) }, 700);
    }

    function execute_search(term) {
        last_term = term;
        grid.set('query', '?q=' + term);
        timeout = 0;
    }

    return declare('imp.SearchBar', TextBox, {
        postCreate: function () {
            this.inherited(arguments);
            this.on('keyup', search_input_keypress);
        }
    });

});
