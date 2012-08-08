define([
    'dojo/ready',
    'dojo/_base/declare',
    'dijit/registry',
    'dojo/store/JsonRest',
    'dojo/store/Cache',
    'dojo/store/Memory'
], function (ready, declare, registry, Store, Cache, Memory) {
    var MyStore = declare([ Store ], {
        query: function () {
            var r = this.inherited(arguments);
            r.then(function () {
                var iq;
                if ( iq = registry.byId('input_query') )
                    iq.focus();
                else
                    ready(function() {
                        registry.byId('input_query').focus();
                    });
            });
            return r;
        }
    });

    return function (options) {
        return Cache(new MyStore(options), Memory());
    }
});
