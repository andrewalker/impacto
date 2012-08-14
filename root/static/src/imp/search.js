define([ 'dojo', 'dojo/parser', 'imp/SearchBar', 'dojo/domReady!' ],
function (dojo, parser) {
    var node = dojo.byId('search');
    if (node) {
        parser.parse('wrapper');
        dojo.style(node, 'opacity', 1);
    }
});

