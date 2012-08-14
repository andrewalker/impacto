var profile = (function () {
    function copyOnly(filename, mid) {
        return mid in {
            'put-selector/node-html': 1
        };
    }
    return {
        releaseDir:     '../dist',
        basePath:       '..',
        action:         'release',
        cssOptimize:    'comments',
        mini:           true,
        optimize:       'closure',
        layerOptimize:  'closure',
        stripConsole:   'all',
        selectorEngine: 'lite',
        localeList:     'pt-br',

        layers: {
            /*
            'dojo/dojo': {
                include:    [ 'dojo/dojo', 'dojo/i18n', 'dojo/domReady', 'imp/menu' ],
                boot:       true,
                customBase: true
            },
            'imp/list': {
                include: [ 'dojo/dojo', 'dojo/i18n', 'dojo/domReady', 'imp/menu', 'imp/list' ],
                boot:       true,
                customBase: true
            },
            */
            'dojo/dojo': {
                include: [ 'dojo/dojo', 'dojo/i18n', 'dojo/domReady', 'smoke/smoke', 'imp/menu', 'imp/form', 'imp/list' ],
                boot:       true,
                customBase: true
            }
        },

        staticHasFeatures: {
            'dojo-trace-api':0,
            'dojo-log-api':0,
            'dojo-publish-privates':0,
            'dojo-sync-loader':0,
            'dojo-xhr-factory':0,
            'dojo-test-sniff':0
        },

        resourceTags: {
            test: function (filename, mid) {
                return false;
            },

            copyOnly: function (filename, mid) {
                return copyOnly(filename, mid);
            },

            amd: function (filename, mid) {
                return !copyOnly(filename,mid) && /\.js$/.test(filename);
            },

            miniExclude: function (filename, mid) {
                return mid in {
                    'imp/imp.profile': 1
                };
            }
        }
    }
})();
