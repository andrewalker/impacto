define([ 'dojo', 'imp/SearchBar', 'dojo/domReady!' ],
function (dojo) {
    var node = dojo.byId('search');
    if (node)
        dojo.style(node, 'opacity', 1);
});

