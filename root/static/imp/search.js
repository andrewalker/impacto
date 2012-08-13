define([ 'dojo', 'dojo/ready', 'imp/SearchBar' ],
function (dojo, ready) {
    ready(function () {
        var node = dojo.byId('search');
        dojo.style(node, 'opacity', 1);
    });
});

