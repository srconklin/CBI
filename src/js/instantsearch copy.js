import searchRouting from './search-routing';

/************************ 
algolia instantsearch
**********************/

const algoliaClient = algoliasearch(
  'S16PTK744D',
  'de0e3624732a96eacb0ed095dd52339c'
);

// a custom client search proxy to prevent
// https://www.algolia.com/doc/guides/building-search-ui/going-further/conditional-requests/js/
const searchClient = {
  ...algoliaClient,
  search(requests) {
    
   // console.log('requests', requests);
    // multiple request can come in at once. test every one
    requests.every(({ params }) => {
     
      // a search, refinement or url that goes straight to results
      // show the algolia element 
      if(requests.length > 1 || params.query) {
        
        document.getElementById('home').style.display = 'none'
        document.getElementById('algolia').classList.add('show');
        
      // prevent results (save $$$) and show landing page
      } else {

        document.getElementById('algolia').classList.remove('show');
        document.getElementById('home').style.display = 'block'

        return Promise.resolve({
            results: requests.map(() => ({
              hits: [],
              nbHits: 0,
              nbPages: 0,
              page: 0,
              processingTimeMS: 0,
            })),
          });
      }
    });
     return algoliaClient.search(requests);
  },
};

export const search = instantsearch({
  indexName: 'cbi',
  searchClient,
  routing: searchRouting,
});

// widgets
const refinementListWithPanel =  instantsearch.widgets.panel({
  hidden({state}){
    console.log(state);

    return !(
      state.hierarchicalFacetsRefinements &&
      state.hierarchicalFacetsRefinements['categories.lvl0'] &&
      state.hierarchicalFacetsRefinements['categories.lvl0'][0] &&
      state.hierarchicalFacetsRefinements['categories.lvl0' ][0].indexOf('Sample Preparation') === -1
    );

    //return false;
  },
  collapsed: true,
  templates: {
   header: 'Manufacturer',
  },
})(instantsearch.widgets.refinementList);



// Create the render function
const renderList = ({ items, createURL }) =>  {
  if (!items) return '';
  
  const findChildren = (arr, nest=0) => {
    for (const item of arr) {
      if (item.isRefined ) {
        if (item.data) 
          return findChildren(item.data,1);
      } 
      else if (nest === 1)  {
        return arr;
      } 
  }
}
const childItems = findChildren(items);
if (!childItems) return '';

return `
  <ul class="ais-HierarchicalMenu-list">
    ${childItems
      .map(
        item => `
          <li class="ais-HierarchicalMenu-item">
            <div>
                <a href="${createURL(item.value)}"
                  data-value="${item.value}"
                  class="ais-HierarchicalMenu-link">
                    <span class="ais-HierarchicalMenu-label">${item.label}</span>
                    <span class="ais-HierarchicalMenu-count">${item.count}</span>              
                </a>
            </div>
          </li>
        `
      )
      .join('')}
  </ul>
`;
}



const renderHierarchicalMenu = (renderOptions, isFirstRender) => {
  const {
    items,
    isShowingMore,
    canRefine,
    refine,
    toggleShowMore,
    createURL,
    widgetParams,
  } = renderOptions;

  // const rootElem = document.querySelector(widgetParams.container);

  if (isFirstRender) {
    const panel = `
      <div class="ais-Panel ais-Panel--collapsible">
      <div class="ais-Panel-header">
        <span>Categories</span>
      </div>
      <div id="catpanel" class="ais-Panel-body">
        <div class="ais-HierarchicalMenu"></div>
      </div>
    </div>`;
    document.querySelector(widgetParams.container).innerHTML = panel;
    // const list = document.createElement('div');
    // list.className = "ais-HierarchicalMenu";
    // document.querySelector("#catpanel").appendChild(list);
  }


  const childItems = renderList({ items, createURL });
  
  if (!childItems) 
    document.querySelector(widgetParams.container).style.display = 'none';
    
  else
  {

      const panel = `
      <div class="ais-Panel ais-Panel--collapsible">
      <div class="ais-Panel-header">
        <span>Categories</span>
      </div>
      <div id="catpanel" class="ais-Panel-body">
        <div class="ais-HierarchicalMenu">${childItems}</div>
      </div>
    </div>`;
    document.querySelector(widgetParams.container).innerHTML = panel;
    const hm = document.querySelector("#catpanel > .ais-HierarchicalMenu");
    //hm.innerHTML = childItems;
    [...hm.querySelectorAll('a')].forEach(element => {
      element.addEventListener('click', event => {
        event.preventDefault();
        const anchor = event.target.closest('a');
        refine(anchor.dataset.value);
      });
    });
    document.querySelector(widgetParams.container).style.display = 'block';

  }
};

// Create the custom widget
const customHierarchicalMenu = instantsearch.connectors.connectHierarchicalMenu(
  renderHierarchicalMenu
);

const HMWithPanel =  instantsearch.widgets.panel({
  collapsed: true,
  templates: {
    header: `Categories`,
  },
})(instantsearch.widgets.hierarchicalMenu);


const searchbox =  instantsearch.widgets.searchBox({
  container: '#searchbox',
  placeholder: 'keyword, category, make, model...',
  searchAsYouType: (document.getElementById('breadcrumb')) ? true : false,
  queryHook(query, search) {
    if(document.getElementById('breadcrumb')) 
      search(query);
     else 
      location.href = `/search/?query=${query}`
  
  },
  
  templates: {
    submit: `
      <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 18 18">
        <g fill="none" fill-rule="evenodd" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.67" transform="translate(1 1)">
          <circle cx="7.11" cy="7.11" r="7.11"/>
          <path d="M16 16l-3.87-3.87"/>
        </g>
      </svg>
          `,
  }
})

search.addWidgets([searchbox]);

// only add other widgets when the placeholders are present on the page
if(document.getElementById('breadcrumb')) {
    search.addWidgets([
      
      instantsearch.widgets.breadcrumb({
        container: '#breadcrumb',
        templates: {
          home: `Home`,
        },
        cssClasses: {
          noRefinementRoot: 'noCrumbs' 
        },  
        attributes: [
          'categories.lvl0',
          'categories.lvl1',
          'categories.lvl2',
          'categories.lvl3',
          'categories.lvl4',
          'categories.lvl5'
        ],
      
      }),

      instantsearch.widgets.clearRefinements({
        container: '#clear-refinements',
        templates: {
          resetLabel: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
          <path fill-rule="evenodd" d="M4 2a1 1 0 011 1v2.101a7.002 7.002 0 0111.601 2.566 1 1 0 11-1.885.666A5.002 5.002 0 005.999 7H9a1 1 0 010 2H4a1 1 0 01-1-1V3a1 1 0 011-1zm.008 9.057a1 1 0 011.276.61A5.002 5.002 0 0014.001 13H11a1 1 0 110-2h5a1 1 0 011 1v5a1 1 0 11-2 0v-2.101a7.002 7.002 0 01-11.601-2.566 1 1 0 01.61-1.276z" clip-rule="evenodd" />
        </svg>clear filters`,
        },
        cssClasses: {
          
          button: [
            'btn-small',
            'btn-gray'
          ],
        }
      }),


      instantsearch.widgets.sortBy({
        container: '#sort-by',
        items: [
          { label: 'Most relevant', value: 'cbi' },
          { label: 'Recently added', value: 'recently_added' },
        ]
      }),

      refinementListWithPanel({
        container: '#mfr',
        attribute: 'mfr',
        showMore: true,
        showMoreLimit: 20,
        searchable: true,
        searchablePlaceholder: 'search a mfr...',
        sortBy: ['name:asc'],

      }),
      
      customHierarchicalMenu({
        container: '#categories',
        attributes: [
          'categories.lvl0',
          'categories.lvl1',
          'categories.lvl2',
          'categories.lvl3',
          'categories.lvl4',
          'categories.lvl5'
        ],
        showParentLevel: false,
        //limit: 15
      }),
      // HMWithPanel({
      //   container: '#categories',
      //   attributes: [ 
      //     'categories.lvl0',
      //     'categories.lvl1',
      //     'categories.lvl2',
      //     'categories.lvl3',
      //     'categories.lvl4',
      //     'categories.lvl5'
      //   ],
      //   showParentLevel: false,
      //   //limit:15,
      //   // sortBy: ['count:desc'],
      // }),


      instantsearch.widgets.stats({
        container: '#stats',
        templates: {
          text: `
            {{#hasNoResults}}No results{{/hasNoResults}}
            {{#hasOneResult}}1 result{{/hasOneResult}}
            {{#hasManyResults}}{{#helpers.formatNumber}}{{nbHits}}{{/helpers.formatNumber}} results{{/hasManyResults}}
          `
        }
      }),

      instantsearch.widgets.stats({
        container: '#statsfilter',
        templates: {
          text: `
            {{#hasNoResults}}No results{{/hasNoResults}}
            {{#hasOneResult}}View 1 result{{/hasOneResult}}
            {{#hasManyResults}}<button class="btn-small btn-gray"  @click.prevent="$dispatch('blur-bg', !showFilter);showFilter = !showFilter"> View {{#helpers.formatNumber}}{{nbHits}}{{/helpers.formatNumber}} results</button>{{/hasManyResults}}
          `
        }
      }),

      instantsearch.widgets.hits({
        container: '#hits',
        templates: {
          item (hit) { 
          const plural = hit.qty > 1 ? 's' : '';
          return `
            <article class="hit" itemscope itemtype="http://schema.org/Product">
              <header>
                <a href="#" @click.prevent="$dispatch('show-modal', { itemno: '${hit.itemno}' })" >
                  <svg xmlns="http://www.w3.org/2000/svg" class="hit-svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14" />
                  </svg>
                     
                  <div class="hit-image">
                        <img itemprop="image"src="${hit.imgbase}${hit.imgMain}" alt="{{headline}}" />
                  </div>
                </a> 
                <link itemprop="url" href="${hit.imgbase}${hit.imgMain}" />
              </header>

              <main>
                <div class="hit-detail">
                  <p itemprop="category" class="category">${instantsearch.highlight({ attribute: 'category', hit })}</p> 
                 <h1 itemprop="name"  class="headline">${instantsearch.highlight({ attribute: 'headline', hit })}</h1> 
                  <p itemprop="description" class="description">${instantsearch.highlight({ attribute: 'description', hit })}</p> 
                </div>
              </main>
            
              <footer>
                <p itemprop="manufacturer" class="hit-mfr">Make: <span>${instantsearch.highlight({ attribute: 'mfr', hit })}</span></p>
                <p itemprop="model" class="hit-model">Model: <span>${instantsearch.highlight({ attribute: 'model', hit })}</span></p>
                <p itemprop="offers" itemscope itemtype="http://schema.org/Offer">
                  <span class="hit-qty">${hit.qty} unit${plural} @</span> <span itemprop="price" content="${hit.price}" class="hit-price">${hit.price}</span>
                </p>
                <div class="hit-footer">
                  <p><span  class="location">${hit.location}</span></p>
                  <p>Item &bull; <a href="/items/${hit.itemno}"><span itemprop="productID" class="itemno">${hit.itemno}</span></a></p>
              </div>
              </footer>
            </article>

          `;
        }
       },
      }),
      instantsearch.widgets.pagination({
        container: '#pagination',
      }),


      instantsearch.widgets.configure({
        hitsPerPage: 16
      })

    ])
  }

  // export default search
 //  search.start();

