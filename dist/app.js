// modules are defined as an array
// [ module function, map of requires ]
//
// map of requires is short require name -> numeric require
//
// anything defined in a previous bundle is accessed via the
// orig method which is the require for previous bundles

(function(modules, entry, mainEntry, parcelRequireName, globalName) {
  /* eslint-disable no-undef */
  var globalObject =
    typeof globalThis !== 'undefined'
      ? globalThis
      : typeof self !== 'undefined'
      ? self
      : typeof window !== 'undefined'
      ? window
      : typeof global !== 'undefined'
      ? global
      : {};
  /* eslint-enable no-undef */

  // Save the require from previous bundle to this closure if any
  var previousRequire =
    typeof globalObject[parcelRequireName] === 'function' &&
    globalObject[parcelRequireName];

  var cache = previousRequire.cache || {};
  // Do not use `require` to prevent Webpack from trying to bundle this call
  var nodeRequire =
    typeof module !== 'undefined' &&
    typeof module.require === 'function' &&
    module.require.bind(module);

  function newRequire(name, jumped) {
    if (!cache[name]) {
      if (!modules[name]) {
        // if we cannot find the module within our internal map or
        // cache jump to the current global require ie. the last bundle
        // that was added to the page.
        var currentRequire =
          typeof globalObject[parcelRequireName] === 'function' &&
          globalObject[parcelRequireName];
        if (!jumped && currentRequire) {
          return currentRequire(name, true);
        }

        // If there are other bundles on this page the require from the
        // previous one is saved to 'previousRequire'. Repeat this as
        // many times as there are bundles until the module is found or
        // we exhaust the require chain.
        if (previousRequire) {
          return previousRequire(name, true);
        }

        // Try the node require function if it exists.
        if (nodeRequire && typeof name === 'string') {
          return nodeRequire(name);
        }

        var err = new Error("Cannot find module '" + name + "'");
        err.code = 'MODULE_NOT_FOUND';
        throw err;
      }

      localRequire.resolve = resolve;
      localRequire.cache = {};

      var module = (cache[name] = new newRequire.Module(name));

      modules[name][0].call(
        module.exports,
        localRequire,
        module,
        module.exports,
        this
      );
    }

    return cache[name].exports;

    function localRequire(x) {
      return newRequire(localRequire.resolve(x));
    }

    function resolve(x) {
      return modules[name][1][x] || x;
    }
  }

  function Module(moduleName) {
    this.id = moduleName;
    this.bundle = newRequire;
    this.exports = {};
  }

  newRequire.isParcelRequire = true;
  newRequire.Module = Module;
  newRequire.modules = modules;
  newRequire.cache = cache;
  newRequire.parent = previousRequire;
  newRequire.register = function(id, exports) {
    modules[id] = [
      function(require, module) {
        module.exports = exports;
      },
      {},
    ];
  };

  Object.defineProperty(newRequire, 'root', {
    get: function() {
      return globalObject[parcelRequireName];
    },
  });

  globalObject[parcelRequireName] = newRequire;

  for (var i = 0; i < entry.length; i++) {
    newRequire(entry[i]);
  }

  if (mainEntry) {
    // Expose entry point to Node, AMD or browser globals
    // Based on https://github.com/ForbesLindesay/umd/blob/master/template.js
    var mainExports = newRequire(mainEntry);

    // CommonJS
    if (typeof exports === 'object' && typeof module !== 'undefined') {
      module.exports = mainExports;

      // RequireJS
    } else if (typeof define === 'function' && define.amd) {
      define(function() {
        return mainExports;
      });

      // <script>
    } else if (globalName) {
      this[globalName] = mainExports;
    }
  }
})({"5MabY":[function(require,module,exports) {
var HMR_HOST = null;
var HMR_PORT = null;
var HMR_SECURE = false;
var HMR_ENV_HASH = "69f74e7f31319ffd";
module.bundle.HMR_BUNDLE_ID = "d839e75310fa75bc";
"use strict";
function _createForOfIteratorHelper(o, allowArrayLike) {
    var it;
    if (typeof Symbol === "undefined" || o[Symbol.iterator] == null) {
        if (Array.isArray(o) || (it = _unsupportedIterableToArray(o)) || allowArrayLike && o && typeof o.length === "number") {
            if (it) o = it;
            var i = 0;
            var F = function F1() {
            };
            return {
                s: F,
                n: function n() {
                    if (i >= o.length) return {
                        done: true
                    };
                    return {
                        done: false,
                        value: o[i++]
                    };
                },
                e: function e(_e) {
                    throw _e;
                },
                f: F
            };
        }
        throw new TypeError("Invalid attempt to iterate non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method.");
    }
    var normalCompletion = true, didErr = false, err;
    return {
        s: function s() {
            it = o[Symbol.iterator]();
        },
        n: function n() {
            var step = it.next();
            normalCompletion = step.done;
            return step;
        },
        e: function e(_e2) {
            didErr = true;
            err = _e2;
        },
        f: function f() {
            try {
                if (!normalCompletion && it.return != null) it.return();
            } finally{
                if (didErr) throw err;
            }
        }
    };
}
function _unsupportedIterableToArray(o, minLen) {
    if (!o) return;
    if (typeof o === "string") return _arrayLikeToArray(o, minLen);
    var n = Object.prototype.toString.call(o).slice(8, -1);
    if (n === "Object" && o.constructor) n = o.constructor.name;
    if (n === "Map" || n === "Set") return Array.from(o);
    if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen);
}
function _arrayLikeToArray(arr, len) {
    if (len == null || len > arr.length) len = arr.length;
    for(var i = 0, arr2 = new Array(len); i < len; i++)arr2[i] = arr[i];
    return arr2;
}
/* global HMR_HOST, HMR_PORT, HMR_ENV_HASH, HMR_SECURE */ /*::
import type {
  HMRAsset,
  HMRMessage,
} from '@parcel/reporter-dev-server/src/HMRServer.js';
interface ParcelRequire {
  (string): mixed;
  cache: {|[string]: ParcelModule|};
  hotData: mixed;
  Module: any;
  parent: ?ParcelRequire;
  isParcelRequire: true;
  modules: {|[string]: [Function, {|[string]: string|}]|};
  HMR_BUNDLE_ID: string;
  root: ParcelRequire;
}
interface ParcelModule {
  hot: {|
    data: mixed,
    accept(cb: (Function) => void): void,
    dispose(cb: (mixed) => void): void,
    // accept(deps: Array<string> | string, cb: (Function) => void): void,
    // decline(): void,
    _acceptCallbacks: Array<(Function) => void>,
    _disposeCallbacks: Array<(mixed) => void>,
  |};
}
declare var module: {bundle: ParcelRequire, ...};
declare var HMR_HOST: string;
declare var HMR_PORT: string;
declare var HMR_ENV_HASH: string;
declare var HMR_SECURE: boolean;
*/ var OVERLAY_ID = '__parcel__error__overlay__';
var OldModule = module.bundle.Module;
function Module(moduleName) {
    OldModule.call(this, moduleName);
    this.hot = {
        data: module.bundle.hotData,
        _acceptCallbacks: [],
        _disposeCallbacks: [],
        accept: function accept(fn) {
            this._acceptCallbacks.push(fn || function() {
            });
        },
        dispose: function dispose(fn) {
            this._disposeCallbacks.push(fn);
        }
    };
    module.bundle.hotData = undefined;
}
module.bundle.Module = Module;
var checkedAssets, acceptedAssets, assetsToAccept;
function getHostname() {
    return HMR_HOST || (location.protocol.indexOf('http') === 0 ? location.hostname : 'localhost');
}
function getPort() {
    return HMR_PORT || location.port;
} // eslint-disable-next-line no-redeclare
var parent = module.bundle.parent;
if ((!parent || !parent.isParcelRequire) && typeof WebSocket !== 'undefined') {
    var hostname = getHostname();
    var port = getPort();
    var protocol = HMR_SECURE || location.protocol == 'https:' && !/localhost|127.0.0.1|0.0.0.0/.test(hostname) ? 'wss' : 'ws';
    var ws = new WebSocket(protocol + '://' + hostname + (port ? ':' + port : '') + '/'); // $FlowFixMe
    ws.onmessage = function(event) {
        checkedAssets = {
        };
        acceptedAssets = {
        };
        assetsToAccept = [];
        var data = JSON.parse(event.data);
        if (data.type === 'update') {
            // Remove error overlay if there is one
            removeErrorOverlay();
            var assets = data.assets.filter(function(asset) {
                return asset.envHash === HMR_ENV_HASH;
            }); // Handle HMR Update
            var handled = assets.every(function(asset) {
                return asset.type === 'css' || asset.type === 'js' && hmrAcceptCheck(module.bundle.root, asset.id, asset.depsByBundle);
            });
            if (handled) {
                console.clear();
                assets.forEach(function(asset) {
                    hmrApply(module.bundle.root, asset);
                });
                for(var i = 0; i < assetsToAccept.length; i++){
                    var id = assetsToAccept[i][1];
                    if (!acceptedAssets[id]) hmrAcceptRun(assetsToAccept[i][0], id);
                }
            } else window.location.reload();
        }
        if (data.type === 'error') {
            // Log parcel errors to console
            var _iterator = _createForOfIteratorHelper(data.diagnostics.ansi), _step;
            try {
                for(_iterator.s(); !(_step = _iterator.n()).done;){
                    var ansiDiagnostic = _step.value;
                    var stack = ansiDiagnostic.codeframe ? ansiDiagnostic.codeframe : ansiDiagnostic.stack;
                    console.error('🚨 [parcel]: ' + ansiDiagnostic.message + '\n' + stack + '\n\n' + ansiDiagnostic.hints.join('\n'));
                } // Render the fancy html overlay
            } catch (err) {
                _iterator.e(err);
            } finally{
                _iterator.f();
            }
            removeErrorOverlay();
            var overlay = createErrorOverlay(data.diagnostics.html); // $FlowFixMe
            document.body.appendChild(overlay);
        }
    };
    ws.onerror = function(e) {
        console.error(e.message);
    };
    ws.onclose = function() {
        console.warn('[parcel] 🚨 Connection to the HMR server was lost');
    };
}
function removeErrorOverlay() {
    var overlay = document.getElementById(OVERLAY_ID);
    if (overlay) {
        overlay.remove();
        console.log('[parcel] ✨ Error resolved');
    }
}
function createErrorOverlay(diagnostics) {
    var overlay = document.createElement('div');
    overlay.id = OVERLAY_ID;
    var errorHTML = '<div style="background: black; opacity: 0.85; font-size: 16px; color: white; position: fixed; height: 100%; width: 100%; top: 0px; left: 0px; padding: 30px; font-family: Menlo, Consolas, monospace; z-index: 9999;">';
    var _iterator2 = _createForOfIteratorHelper(diagnostics), _step2;
    try {
        for(_iterator2.s(); !(_step2 = _iterator2.n()).done;){
            var diagnostic = _step2.value;
            var stack = diagnostic.codeframe ? diagnostic.codeframe : diagnostic.stack;
            errorHTML += "\n      <div>\n        <div style=\"font-size: 18px; font-weight: bold; margin-top: 20px;\">\n          \uD83D\uDEA8 ".concat(diagnostic.message, "\n        </div>\n        <pre>\n          ").concat(stack, "\n        </pre>\n        <div>\n          ").concat(diagnostic.hints.map(function(hint) {
                return '<div>' + hint + '</div>';
            }).join(''), "\n        </div>\n      </div>\n    ");
        }
    } catch (err) {
        _iterator2.e(err);
    } finally{
        _iterator2.f();
    }
    errorHTML += '</div>';
    overlay.innerHTML = errorHTML;
    return overlay;
}
function getParents(bundle, id) /*: Array<[ParcelRequire, string]> */ {
    var modules = bundle.modules;
    if (!modules) return [];
    var parents = [];
    var k, d, dep;
    for(k in modules)for(d in modules[k][1]){
        dep = modules[k][1][d];
        if (dep === id || Array.isArray(dep) && dep[dep.length - 1] === id) parents.push([
            bundle,
            k
        ]);
    }
    if (bundle.parent) parents = parents.concat(getParents(bundle.parent, id));
    return parents;
}
function updateLink(link) {
    var newLink = link.cloneNode();
    newLink.onload = function() {
        if (link.parentNode !== null) // $FlowFixMe
        link.parentNode.removeChild(link);
    };
    newLink.setAttribute('href', link.getAttribute('href').split('?')[0] + '?' + Date.now()); // $FlowFixMe
    link.parentNode.insertBefore(newLink, link.nextSibling);
}
var cssTimeout = null;
function reloadCSS() {
    if (cssTimeout) return;
    cssTimeout = setTimeout(function() {
        var links = document.querySelectorAll('link[rel="stylesheet"]');
        for(var i = 0; i < links.length; i++){
            // $FlowFixMe[incompatible-type]
            var href = links[i].getAttribute('href');
            var hostname = getHostname();
            var servedFromHMRServer = hostname === 'localhost' ? new RegExp('^(https?:\\/\\/(0.0.0.0|127.0.0.1)|localhost):' + getPort()).test(href) : href.indexOf(hostname + ':' + getPort());
            var absolute = /^https?:\/\//i.test(href) && href.indexOf(window.location.origin) !== 0 && !servedFromHMRServer;
            if (!absolute) updateLink(links[i]);
        }
        cssTimeout = null;
    }, 50);
}
function hmrApply(bundle, asset) {
    var modules = bundle.modules;
    if (!modules) return;
    if (asset.type === 'css') {
        reloadCSS();
        return;
    }
    var deps = asset.depsByBundle[bundle.HMR_BUNDLE_ID];
    if (deps) {
        var fn = new Function('require', 'module', 'exports', asset.output);
        modules[asset.id] = [
            fn,
            deps
        ];
    } else if (bundle.parent) hmrApply(bundle.parent, asset);
}
function hmrAcceptCheck(bundle, id, depsByBundle) {
    var modules = bundle.modules;
    if (!modules) return;
    if (depsByBundle && !depsByBundle[bundle.HMR_BUNDLE_ID]) {
        // If we reached the root bundle without finding where the asset should go,
        // there's nothing to do. Mark as "accepted" so we don't reload the page.
        if (!bundle.parent) return true;
        return hmrAcceptCheck(bundle.parent, id, depsByBundle);
    }
    if (checkedAssets[id]) return;
    checkedAssets[id] = true;
    var cached = bundle.cache[id];
    assetsToAccept.push([
        bundle,
        id
    ]);
    if (cached && cached.hot && cached.hot._acceptCallbacks.length) return true;
    return getParents(module.bundle.root, id).some(function(v) {
        return hmrAcceptCheck(v[0], v[1], null);
    });
}
function hmrAcceptRun(bundle, id) {
    var cached = bundle.cache[id];
    bundle.hotData = {
    };
    if (cached && cached.hot) cached.hot.data = bundle.hotData;
    if (cached && cached.hot && cached.hot._disposeCallbacks.length) cached.hot._disposeCallbacks.forEach(function(cb) {
        cb(bundle.hotData);
    });
    delete bundle.cache[id];
    bundle(id);
    cached = bundle.cache[id];
    if (cached && cached.hot && cached.hot._acceptCallbacks.length) cached.hot._acceptCallbacks.forEach(function(cb) {
        var assetsToAlsoAccept = cb(function() {
            return getParents(module.bundle.root, id);
        });
        if (assetsToAlsoAccept && assetsToAccept.length) // $FlowFixMe[method-unbinding]
        assetsToAccept.push.apply(assetsToAccept, assetsToAlsoAccept);
    });
    acceptedAssets[id] = true;
}

},{}],"g1M29":[function(require,module,exports) {
var parcelHelpers = require("@parcel/transformer-js/src/esmodule-helpers.js");
var _searchRouting = require("./js/search-routing");
var _searchRoutingDefault = parcelHelpers.interopDefault(_searchRouting);
// window functions
window.formatter = new Intl.NumberFormat('en-US', {
    style: 'currency',
    currency: 'USD'
});
window.stripHTML = (s)=>s.toString().replace(/(<([^>]+)>)/gi, '')
;
window.integerOnly = (n)=>n.toString().replace(/[^0-9]/g, '')
;
window.formatNumber = (n)=>addCommas(integerOnly(n))
;
// https://stackoverflow.com/questions/2901102/how-to-print-a-number-with-commas-as-thousands-separators-in-javascript
// window.addCommas = (x) => x.toString().replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ',');
window.addCommas = (x)=>{
    var parts = x.toString().split(".");
    parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    return parts.join(".");
};
window.validTelNumber = (n)=>n.toString().replace(/[^0-9\s-\+()\.]/g, '')
;
window.formatCurrency = (val, blur)=>{
    if (!val) return '';
    const mapper = (e, i)=>i == 1 ? blur === "blur" ? formatNumber(e).concat('00').substring(0, 2) : formatNumber(e).substring(0, 2) : formatNumber(e)
    ;
    return val.indexOf(".") >= 0 ? val.split(".").map(mapper).join(".") : blur === "blur" ? formatNumber(val).concat('.00') : formatNumber(val);
};
window.iti = (el)=>{
    const phone = document.getElementById(el);
    if (phone) {
        // const errorMap = ["Invalid number", "Invalid country code", "Too short", "Too long", "Invalid number"];
        const phoneInput = window.intlTelInput(phone, {
            utilsScript: "https://cdn.jsdelivr.net/npm/intl-tel-input@17/build/js/utils.min.js"
        });
        const blurHandler = (val)=>{
            if (!val) return {
                success: true
            };
            const phoneNumber = phoneInput.getNumber().trim();
            if (phoneInput.isValidNumber()) {
                phoneInput.setNumber(phoneNumber);
                return {
                    success: true,
                    e164: phoneNumber
                };
            } else return {
                success: false,
                error: 'Invalid Number'
            };
        };
        return blurHandler;
    }
};
const searchClient = algoliasearch('S16PTK744D', 'de0e3624732a96eacb0ed095dd52339c');
const search1 = instantsearch({
    indexName: 'cbi',
    searchClient,
    routing: _searchRoutingDefault.default
});
const refinementListWithPanel = instantsearch.widgets.panel({
    collapsed: true,
    templates: {
        header: 'Manufacturer'
    }
})(instantsearch.widgets.refinementList);
const HMWithPanel = instantsearch.widgets.panel({
    collapsed: true,
    templates: {
        header: `Categories`
    }
})(instantsearch.widgets.hierarchicalMenu);
const searchbox = instantsearch.widgets.searchBox({
    container: '#searchbox',
    placeholder: 'keyword, category, make, model...',
    searchAsYouType: document.getElementById('breadcrumb') ? true : false,
    queryHook (query, search) {
        if (document.getElementById('breadcrumb')) search(query);
        else location.href = `/search/?query=${query}`;
    },
    templates: {
        submit: `\n      <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 18 18">\n        <g fill="none" fill-rule="evenodd" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.67" transform="translate(1 1)">\n          <circle cx="7.11" cy="7.11" r="7.11"/>\n          <path d="M16 16l-3.87-3.87"/>\n        </g>\n      </svg>\n          `
    }
});
// <div class="togglebc">
//           <button class="ais-Panel-collapseButton" @click.stop="showBreadCrumb = false">
//             <span>
//               <svg class="ais-Panel-collapseIcon" width="1em" height="1em" viewBox="0 0 500 500" >
//                 <path d="M250 400l150-300H100z" fill="currentColor"></path>
//               </svg>
//             </span>
//           </button>
//         </div> 
search1.addWidgets([
    searchbox
]);
// only add other widgets when the placeholders are present on the page
if (document.getElementById('breadcrumb')) search1.addWidgets([
    instantsearch.widgets.breadcrumb({
        container: '#breadcrumb',
        templates: {
            home: `All Categories`
        },
        cssClasses: {
            noRefinementRoot: 'noCrumbs'
        },
        attributes: [
            'categories.lvl0',
            'categories.lvl1',
            'categories.lvl2', 
        ]
    }),
    instantsearch.widgets.clearRefinements({
        container: '#clear-refinements',
        templates: {
            resetLabel: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">\n          <path fill-rule="evenodd" d="M4 2a1 1 0 011 1v2.101a7.002 7.002 0 0111.601 2.566 1 1 0 11-1.885.666A5.002 5.002 0 005.999 7H9a1 1 0 010 2H4a1 1 0 01-1-1V3a1 1 0 011-1zm.008 9.057a1 1 0 011.276.61A5.002 5.002 0 0014.001 13H11a1 1 0 110-2h5a1 1 0 011 1v5a1 1 0 11-2 0v-2.101a7.002 7.002 0 01-11.601-2.566 1 1 0 01.61-1.276z" clip-rule="evenodd" />\n        </svg>clear filters`
        },
        cssClasses: {
            button: [
                'btn-small',
                'btn-gray'
            ]
        }
    }),
    instantsearch.widgets.sortBy({
        container: '#sort-by',
        items: [
            {
                label: 'Most relevant',
                value: 'cbi'
            },
            {
                label: 'Recently added',
                value: 'recently_added'
            }, 
        ]
    }),
    HMWithPanel({
        container: '#categories',
        attributes: [
            'categories.lvl0',
            'categories.lvl1',
            'categories.lvl2'
        ],
        limit: 15
    }),
    refinementListWithPanel({
        container: '#mfr',
        attribute: 'mfr',
        showMore: true,
        showMoreLimit: 20,
        searchable: true,
        searchablePlaceholder: 'search a mfr...',
        sortBy: [
            'name:asc'
        ]
    }),
    instantsearch.widgets.stats({
        container: '#stats',
        templates: {
            text: `\n            {{#hasNoResults}}No results{{/hasNoResults}}\n            {{#hasOneResult}}1 result{{/hasOneResult}}\n            {{#hasManyResults}}{{#helpers.formatNumber}}{{nbHits}}{{/helpers.formatNumber}} results{{/hasManyResults}}\n          `
        }
    }),
    instantsearch.widgets.stats({
        container: '#statsfilter',
        templates: {
            text: `\n            {{#hasNoResults}}No results{{/hasNoResults}}\n            {{#hasOneResult}}View 1 result{{/hasOneResult}}\n            {{#hasManyResults}}<button class="btn-small btn-gray"  @click.prevent="$dispatch('blur-bg', !showFilter);showFilter = !showFilter"> View {{#helpers.formatNumber}}{{nbHits}}{{/helpers.formatNumber}} results</button>{{/hasManyResults}}\n          `
        }
    }),
    instantsearch.widgets.hits({
        container: '#hits',
        templates: {
            item (hit) {
                const plural = hit.qty > 1 ? 's' : '';
                return `\n            <article class="hit" itemscope itemtype="http://schema.org/Product">\n              <header>\n                <a href="#" @click.prevent="$dispatch('show-modal', { itemno: '${hit.itemno}' })" >\n                  <svg xmlns="http://www.w3.org/2000/svg" class="hit-svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">\n                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14" />\n                  </svg>\n                     \n                  <div class="hit-image">\n                        <img itemprop="image"src="${hit.imgbase}${hit.imgMain}" alt="{{headline}}" />\n                  </div>\n                </a> \n                <link itemprop="url" href="${hit.imgbase}${hit.imgMain}" />\n              </header>\n\n              <main>\n                <div class="hit-detail">\n                  <p itemprop="category" class="category">${instantsearch.highlight({
                    attribute: 'category',
                    hit
                })}</p> \n                  <h1 itemprop="name"  class="headline">${instantsearch.highlight({
                    attribute: 'headline',
                    hit
                })}</h1> \n                  <p itemprop="description" class="description">${instantsearch.highlight({
                    attribute: 'description',
                    hit
                })}</p> \n                </div>\n              </main>\n            \n              <footer>\n                <p itemprop="manufacturer" class="hit-mfr">Make: <span>${instantsearch.highlight({
                    attribute: 'mfr',
                    hit
                })}</span></p>\n                <p itemprop="model" class="hit-model">Model: <span>${instantsearch.highlight({
                    attribute: 'model',
                    hit
                })}</span></p>\n                <p itemprop="offers" itemscope itemtype="http://schema.org/Offer">\n                  <span class="hit-qty">${hit.qty} unit${plural} @</span> <span itemprop="price" content="${hit.price}" class="hit-price">${hit.price}</span>\n                </p>\n                <div class="hit-footer">\n                  <p><span  class="location">${hit.location}</span></p>\n                  <p>Item &bull; <a href="/items/${hit.itemno}"><span itemprop="productID" class="itemno">${hit.itemno}</span></a></p>\n              </div>\n              </footer>\n            </article>\n\n          `;
            }
        }
    }),
    instantsearch.widgets.pagination({
        container: '#pagination'
    }),
    instantsearch.widgets.configure({
        hitsPerPage: 16
    })
]);
search1.start();
/*****************
 Spruce Stores
*****************/ Spruce.store('tabs', ()=>{
    return {
        openTab: 1,
        content: {
            specstable: ''
        },
        activeTabClasses: 'activeTab',
        inactiveTabClasses: 'inActiveTab',
        activeBtnClasses: 'activeBtn',
        inactiveBtnClasses: 'inActiveBtn',
        showActiveTab (tab) {
            return this.openTab === tab ? this.activeTabClasses : this.inactiveTabClasses;
        },
        showActiveButton (tab) {
            return this.openTab === tab ? this.activeBtnClasses : this.inactiveBtnClasses;
        }
    };
});
Spruce.store('carousel', ()=>{
    var e = document.getElementById("slider");
    // return {
    //   direction: 'leftoright', 
    //   activeSlide: 0, 
    //   slides: [], 
    // }
    return {
        slides: [],
        active: 0,
        pageX: 0,
        pageEndX: 0,
        mousedown: function(e1) {
            e1.stopPropagation(), this.pageX = e1.pageX;
        },
        mouseup: function(t) {
            t.stopPropagation();
            var r = t.pageX - this.pageX;
            r < -3 ? e.scrollLeft = e.scrollLeft + e.scrollWidth / this.slides.length : r > 3 && (e.scrollLeft = e.scrollLeft - e.scrollWidth / this.slides.length);
        },
        mousemove: function(e1) {
            e1.preventDefault();
        }
    };
});
// showItem details in modal
Spruce.store('imodal', ()=>{
    return {
        modal: false,
        content: false,
        showModal () {
        // document.body.style.overflow = 'hidden';
        },
        closeModal (e) {
            document.body.style.overflow = 'unset';
            this.modal = false;
        },
        showItem (itemno) {
            try {
                fetch(`/data/${itemno}.json`, {
                    method: 'GET'
                }).then((response)=>response.json()
                ).then((data)=>{
                    this.content = data;
                    // Spruce.store('carousel').slides = [ `${data.imgbase}${data.imgMain}`, ... data.imagesXtra.map( image => `${data.imgbase}${image}`)]
                    // Spruce.store('tabs').content.specstable =  data.specstable;
                    // setTimeout(() => {
                    //     this.modal = true;
                    // }, 200);
                    // if(/Android/.test(navigator.appVersion)){
                    //   // $('input[type="text"]').attr('autocomplete', "off");
                    //   document.querySelector('input[type="text"]').setAttribute("autocomplete", "off");
                    //  }
                    this.modal = true;
                });
            } catch (error) {
                console.log(error);
            }
        }
    };
});
Spruce.store('offer', ()=>{
    const textLimit = 250;
    // intl-tel-input plugin
    const itiBlur = iti('phone1');
    return {
        qtyStated: {
            blurred: false,
            errorMessage: '',
            value: 1
        },
        priceStated: {
            blurred: false,
            errorMessage: '',
            value: ''
        },
        firstName: {
            blurred: false,
            errorMessage: ''
        },
        lastName: {
            blurred: false,
            errorMessage: ''
        },
        email: {
            blurred: false,
            errorMessage: ''
        },
        phone1: {
            blurred: false,
            errorMessage: ''
        },
        terms: '',
        message: '',
        maxqty: 1,
        submitting: false,
        submitted: false,
        validate (e) {
            this.toTarget(e.target);
        },
        toTarget (el) {
            //const el = e.target;
            const input = el.name.charAt(0).toUpperCase() + el.name.slice(1);
            // custom function exist call that over the validateEle
            if (typeof this['validate' + input] === "function") this['validate' + input](el);
            else this.validateEle(el);
        },
        validateEle (el) {
            this[el.name].blurred = true;
            if (!el.checkValidity()) {
                const messages = el.dataset.msg ? JSON.parse(el.dataset.msg) : [];
                const msg = messages.find((msg1)=>el.validity[msg1.split(':')[0]]
                );
                this[el.name].errorMessage = msg != undefined ? msg.split(':')[1] : el.validationMessage;
                //   this[el.name].errorMessage = el.validationMessage;
                return false;
            // no error
            } else {
                this[el.name].errorMessage = '';
                return true;
            }
        },
        validateTerms () {
            this.terms = stripHTML(this.terms, 'blur');
        },
        validateMessage () {
            this.message = stripHTML(this.message, 'blur');
        },
        validatePriceStated (el) {
            this.priceStated.value = formatCurrency(this.priceStated.value, 'blur');
            this.validateEle(el);
        },
        validatePhone1 (el) {
            const result = itiBlur(el.value);
            this[el.name].blurred = true;
            result.success ? this.validateEle(el) : this[el.name].errorMessage = result.error;
        },
        get total () {
            return this.priceStated.value && this.qtyStated.value ? formatter.format(parseFloat(this.priceStated.value.replace(/[^0-9.]/g, '')).toFixed(2) * this.qtyStated.value) : '$0.00';
        },
        get termsRemain () {
            return textLimit - this.terms.length;
        },
        get messageRemain () {
            return textLimit - this.message.length;
        },
        submit () {
            const data = new FormData(document.getElementById("offerfrm"));
            let error;
            // get the inputs that are to be validated (they have a blurred property)
            const inputs = Object.entries(this).filter((ele)=>ele[1].hasOwnProperty('blurred')
            );
            // for those inputs, call any custom methods for validation otherwise call standard validateele
            inputs.forEach((ele)=>{
                this.toTarget(document.getElementById(ele[0]));
            });
            const errors = inputs.find((ele)=>ele[1].errorMessage
            );
            if (!errors) {
                this.submitting = true;
                let success = false;
                try {
                    fetch('/offer', {
                        method: 'POST',
                        body: data
                    }).then((response)=>response.json()
                    ).then((data1)=>{
                        if (!data1.res) for (const [key, value] of Object.entries(data1.errors)){
                            this[key].blurred = true;
                            this[key].errorMessage = value;
                        }
                        else success = true;
                    });
                } catch (error1) {
                    console.log(error1);
                } finally{
                    setTimeout(()=>{
                        this.submitting = false;
                        this.submitted = success;
                    }, 700);
                }
            }
        }
    };
});
/***********
 watchers 
************/ // when modal closes reset some defaults
Spruce.watch('imodal.modal', (value)=>{
    if (!value) {
        const reset = {
            blurred: false,
            errorMessage: ''
        };
        Spruce.store('carousel').direction = 'leftoright';
        Spruce.store('carousel').activeSlide = 0;
        Spruce.store('offer').priceStated.value = '';
        Spruce.store('offer').submitted = false;
        Spruce.store('offer').priceStated = {
            ...Spruce.store('offer').priceStated,
            ...reset,
            value: ''
        };
        Spruce.store('offer').qtyStated = {
            ...Spruce.store('offer').qtyStated,
            ...reset
        };
    }
});
// when new content is fetched for the item; pass image/tab data off to their respective components for mgmt.
Spruce.watch('imodal.content', (content)=>{
    if (content) {
        Spruce.store('carousel').slides = [
            `${content.imgbase}${content.imgMain}`,
            ...content.imagesXtra.map((image)=>`${content.imgbase}${image}`
            )
        ];
        Spruce.store('tabs').content.specstable = content.specstable;
        Spruce.store('offer').qtyStated.value = content.qty;
        Spruce.store('offer').maxqty = content.qty;
        Spruce.store('offer').itemno = content.itemno;
        content = {
            ...content,
            specstable: undefined,
            imagesXtra: undefined,
            imgMain: undefined
        };
    }
});
/***********************
  Helper functions
***********************/ let domReady = (cb)=>{
    document.readyState === 'interactive' || document.readyState === 'complete' ? cb() : document.addEventListener('DOMContentLoaded', cb);
};
domReady(()=>{
// setTimeout(() => {
//      document.querySelector('.ais-Breadcrumb-item--selected') ? document.getElementById('togglebc').style.visibility = 'visible' : '';
//  let toggles = document.querySelectorAll('.togglebc');
//  toggles.forEach(function(item) {
//   item.style.visibility = 'visible';
// });
// }, 200);
});

},{"./js/search-routing":"VvLS4","@parcel/transformer-js/src/esmodule-helpers.js":"JacNc"}],"VvLS4":[function(require,module,exports) {
var parcelHelpers = require("@parcel/transformer-js/src/esmodule-helpers.js");
parcelHelpers.defineInteropFlag(exports);
/* global instantsearch */ //import instantsearch from 'instantsearch.js';
// import {
// 	history as historyRouter
//   } from 'instantsearch.js/es/lib/routers';
// import { simple as simpleMapping } from 'instantsearch.js/es/lib/stateMappings';
// const encodedCategories = {
// 	Cameras: 'Cameras & Camcorders',
// 	Cars: 'Car Electronics & GPS',
// 	Phones: 'Cell Phones',
// 	TV: 'TV & Home Theater',
//   };
//   const decodedCategories = Object.keys(encodedCategories).reduce((acc, key) => {
// 	const newKey = encodedCategories[key];
// 	const newValue = key;
// 	return {
// 	  ...acc,
// 	  [newKey]: newValue,
// 	};
//   }, {});
// Returns a slug from the category name.
// Spaces are replaced by "+" to make
// the URL easier to read and other
// characters are encoded.
function getCategorySlug(name) {
    //const encodedName = decodedCategories[name] || name;
    return name.split(' ').map(encodeURIComponent).join('+');
}
// Returns a name from the category slug.
// The "+" are replaced by spaces and other
// characters are decoded.
function getCategoryName(slug) {
    //const decodedSlug = encodedCategories[slug] || slug;
    return slug.split('+').map(decodeURIComponent).join(' ');
}
// const router = historyRouter({
const router = instantsearch.routers.history({
    windowTitle (routeState) {
        const { category , query  } = routeState;
        const queryTitle = query ? `CBI Results for "${query}"` : 'CBI Search';
        if (category) return `${category} – ${queryTitle}`;
        return queryTitle;
    },
    createURL ({ qsModule , routeState , location  }) {
        const urlParts = location.href.match(/^(.*?)\/search/);
        const baseUrl = `${urlParts ? urlParts[1] : ''}/`;
        const categoryPath = routeState.category ? `${getCategorySlug(routeState.category)}/` : '';
        const queryParameters = {
        };
        if (routeState.query) queryParameters.query = encodeURIComponent(routeState.query);
        if (routeState.page !== 1) queryParameters.page = routeState.page;
        if (routeState.mfrs) queryParameters.mfrs = routeState.mfrs.map(encodeURIComponent);
        const queryString = qsModule.stringify(queryParameters, {
            addQueryPrefix: true,
            arrayFormat: 'repeat'
        });
        return `${baseUrl}search/${categoryPath}${queryString}`;
    },
    parseURL ({ qsModule , location  }) {
        const pathnameMatches = location.pathname.match(/search\/(.*?)\/?$/);
        const category = getCategoryName(pathnameMatches && pathnameMatches[1] || '');
        const { query ='' , page , mfrs =[]  } = qsModule.parse(location.search.slice(1));
        // `qs` does not return an array when there's a single value.
        const allmfrs = Array.isArray(mfrs) ? mfrs : [
            mfrs
        ].filter(Boolean);
        return {
            query: decodeURIComponent(query),
            page,
            mfrs: allmfrs.map(decodeURIComponent),
            category
        };
    }
});
const stateMapping = {
    stateToRoute (uiState) {
        const indexUiState = uiState['cbi'] || {
        };
        // refer to uiState docs for details: https://www.algolia.com/doc/api-reference/widgets/ui-state/js/
        return {
            query: indexUiState.query,
            page: indexUiState.page,
            mfrs: indexUiState.refinementList && indexUiState.refinementList.mfr,
            // category: indexUiState.hierarchicalMenu && indexUiState.hierarchicalMenu.categories
            category: indexUiState.hierarchicalMenu && indexUiState.hierarchicalMenu['categories.lvl0'].join('_')
        };
    },
    routeToState (routeState) {
        // refer to uiState docs for details: https://www.algolia.com/doc/api-reference/widgets/ui-state/js/
        return {
            // eslint-disable-next-line camelcase
            cbi: {
                query: routeState.query,
                page: routeState.page,
                hierarchicalMenu: {
                    'categories.lvl0': routeState.category && routeState.category.split('_')
                },
                refinementList: {
                    mfr: routeState.mfrs
                }
            }
        };
    }
};
const searchRouting = {
    router,
    stateMapping
};
exports.default = searchRouting;

},{"@parcel/transformer-js/src/esmodule-helpers.js":"JacNc"}],"JacNc":[function(require,module,exports) {
exports.interopDefault = function(a) {
    return a && a.__esModule ? a : {
        default: a
    };
};
exports.defineInteropFlag = function(a) {
    Object.defineProperty(a, '__esModule', {
        value: true
    });
};
exports.exportAll = function(source, dest) {
    Object.keys(source).forEach(function(key) {
        if (key === 'default' || key === '__esModule') return;
        // Skip duplicate re-exports when they have the same value.
        if (key in dest && dest[key] === source[key]) return;
        Object.defineProperty(dest, key, {
            enumerable: true,
            get: function() {
                return source[key];
            }
        });
    });
    return dest;
};
exports.export = function(dest, destName, get) {
    Object.defineProperty(dest, destName, {
        enumerable: true,
        get: get
    });
};

},{}]},["5MabY","g1M29"], "g1M29", "parcelRequire3d30")

//# sourceMappingURL=app.js.map
