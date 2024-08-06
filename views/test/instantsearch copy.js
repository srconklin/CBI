import algoliasearch from 'algoliasearch/lite';
import instantsearch from 'instantsearch.js';
import {hierarchicalMenu, refinementList, searchBox, pagination, configure, hits, panel, breadcrumb, clearRefinements, sortBy, stats} from 'instantsearch.js/es/widgets';
import searchRouting from './search-routing';
let favs =[];
let favfilter =false;
const algoliaClient = algoliasearch(
	'S16PTK744D',
	'de0e3624732a96eacb0ed095dd52339c'
  );
  
  const getfavorites = async () => {
     return await window.getUserFavs();
}
  // a custom client search proxy to prevent
  // https://www.algolia.com/doc/guides/building-search-ui/going-further/conditional-requests/js/
  const searchClient = {
	...algoliaClient,
	async search(requests) {
		favfilter = false;
		favs = await getfavorites();
		
	  // multiple request can come in at once. test every one
	  requests.every(({ params }) => {
		console.log(params);
		// a search, refinement or url that goes straight to results
		// show the algolia element 
		console.log(requests);
		if(requests.length > 1 || params.query) {

		  document.getElementById('home').style.display = 'none'
		  document.getElementById('algolia').classList.add('show');

		  if(params.query == 'favorites' && favs.length) {
			params.query = '';
			favfilter = true;
		  }
		  
		// prevent results (save $$$) and show landing page
		} else {
  
		if(document.getElementById('algolia')) {
		  document.getElementById('algolia').classList.remove('show');
		  document.getElementById('home').style.display = 'block'
		}			
		  return Promise.resolve({
			  results: requests.map(() => ({
				hits: [],
				nbHits: 0,
				nbPages: 0,
				page: 0,
				processingTimeMS: 0,
				hitsPerPage: 0,
				exhaustiveNbHits: false,
				query: '',
				params: ''
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

  
  const searchbox =  searchBox({
	container: '#searchbox',
	placeholder: 'search equipment ...',
	searchAsYouType: (document.getElementById('breadcrumb')) ? true : false,
	queryHook(query, search) {
	  if(document.getElementById('breadcrumb')) 
		search(query);
	   else 
		location.href = `/search/?query=${query}`
	
	},
	
	templates: {
		submit({ cssClasses }, { html }) {
			return html`<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 18 18">
			<g fill="none" fill-rule="evenodd" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.67" transform="translate(1 1)">
			  <circle cx="7.11" cy="7.11" r="7.11"/>
			  <path d="M16 16l-3.87-3.87"/>
			</g>
		  </svg>`;
		  }
	}
  })

  
  search.addWidgets([searchbox]);

  
  // only add other widgets when the placeholders are present on the page
  if(document.getElementById('breadcrumb')) {

		
	const refinementListWithPanel =  panel({
		collapsed:  ()=> false,
		hidden(options) {
			return options.results.nbHits === 0;
		},
		templates: {
			header(options, { html }) {
				return html`Manufacturer`
			}
		},
	})(refinementList);
	
	const HMWithPanel =  panel({
		collapsed: ()=> false,
		hidden(options) {
			return options.results.nbHits === 0;
		},
		templates: {
			header(options, { html }) {
				return html `Categories`
			}
		},
	})(hierarchicalMenu);
	

	search.addWidgets([
		
		breadcrumb({
		  container: '#breadcrumb',
		  templates: {
			home(data, { html }) {
				return html`All Categories`;
			}
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
			'categories.lvl5',
		  ],
		
		}),
  
		clearRefinements({
		  container: '#clear-refinements',

		  templates: {
			resetLabel({ hasRefinements }, { html }) {
				return html`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
				<path fill-rule="evenodd" d="M4 2a1 1 0 011 1v2.101a7.002 7.002 0 0111.601 2.566 1 1 0 11-1.885.666A5.002 5.002 0 005.999 7H9a1 1 0 010 2H4a1 1 0 01-1-1V3a1 1 0 011-1zm.008 9.057a1 1 0 011.276.61A5.002 5.002 0 0014.001 13H11a1 1 0 110-2h5a1 1 0 011 1v5a1 1 0 11-2 0v-2.101a7.002 7.002 0 01-11.601-2.566 1 1 0 01.61-1.276z" clip-rule="evenodd" />
			  </svg>clear filters`
			}
		  },
		  cssClasses: {
			
			button: [
			  'btn-small',
			  'btn-gray'
			],
		  }
		}),
  
  
		sortBy({
		  container: '#sort-by',
		  items: [
			{ label: 'Most relevant', value: 'cbi' },
			{ label: 'Recently added', value: 'recently_added' },
		  ]
		}),
  
		HMWithPanel({
		  container: '#categories',
		  attributes: [
			'categories.lvl0',
			'categories.lvl1',
			'categories.lvl2',
			'categories.lvl3',
			'categories.lvl4',
			'categories.lvl5',
		  ],
		  limit:15,
		  // sortBy: ['count:desc'],
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
  
		stats({
		  container: '#stats',
		  templates: {
			text(data, { html }) {
				let count = '';

					if (data.hasManyResults) {
						count = `${data.nbHits} results`;
					} else if (data.hasOneResult) {
						count = `1 result`;
					} else {
						count = `no result`;
					}
				
					return html`<span>${count}</span>`;

			}
			
		  }
		}),
  
		stats({
		  container: '#statsfilter',
		  templates: {
			text(data, { html }) {
				let count = '';

					if (data.hasManyResults) {
						count = html`<button class="btn-small btn-gray"  x-on:click.prevent="$dispatch('blur-bg', !showFilter);showFilter = !showFilter"> View ${data.nbHits} results</button>`;
					} else if (data.hasOneResult) {
						count = `1 result`;
					} else {
						count = `no result`;
					}
				
					return html`<span>${count}</span>`;

			}
		  }
		}),
  
		hits({
		  container: '#hits',

		  transformItems(items, { results }) {
			console.log(results);
			if(favfilter) {
				document.getElementById('refinements').style.display = 'none'
				const filteredItems = results.hits.filter((hit) => favs.includes(hit.itemno));
				results.nbHits = filteredItems.length;
				results.nbPages = 1;
				return filteredItems
			} else 
			document.getElementById('refinements').style.display = 'block';
				
			
			return items;
		  },
		  templates: {
			
			empty(results, { html }) {
			 	document.getElementById('pagination').style.display = 'none';
			 	document.getElementById('stats').style.display = 'none';
			 	document.getElementById('sort-by').style.display = 'none';
				document.getElementById('refinements').style.display = 'none'
				return html`<h2>No matching results</h2><p>Try your search again or make sure to adjust any filters that could be limiting the search</p>`
			 }, 

			 item(hit, { html, components }) {
				document.getElementById('pagination').style.display = 'block';
				document.getElementById('sort-by').style.display = 'block'
				document.getElementById('stats').style.display = 'block';
				//document.getElementById('refinements').style.display = 'block';
					
				const plural = hit.qty > 1 ? 's' : '';
				//console.log(favs);
				//class="${favs.includes(hit.itemno)?'favorite' : ''}" fill="${favs.includes(hit.itemno)?'#fa0114' : 'none'}"
				return html`
				<article class="hit" itemscope itemtype="http://schema.org/Product" x-data="favorites(${hit.itemno},${favs.includes(hit.itemno)? true :false})">
					<header>
					<a href="#" x-on:click.prevent="$dispatch('show-modal', { itemno: '${hit.itemno}' })">
						<svg xmlns="http://www.w3.org/2000/svg" class="hit-svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
								<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14" />
						</svg>
						<div class="hit-image">
							<img itemprop="image" src="${hit.imgbase}${hit.imgMain}" alt="${hit.headline}" />
						</div>
					</a> 
					<link itemprop="url" href="${hit.imgbase}${hit.imgMain}" />
					</header>
	
					<main>
					<div class="hit-detail">
						<p itemprop="category" class="category">${components.Highlight({ attribute: 'category', hit })}</p> 
						<h1 itemprop="name"  class="headline">${components.Highlight({ attribute: 'headline', hit })}</h1> 
						<p itemprop="description" class="description">${components.Highlight({ attribute: 'description', hit })}</p> 
					</div>
					</main>
				
					<footer>
					<p itemprop="manufacturer" class="hit-mfr">Make: <span>${components.Highlight({ attribute: 'mfr', hit })}</span></p>
					<p itemprop="model" class="hit-model">Model: <span>${components.Highlight({ attribute: 'model', hit })}</span></p>
					<p itemprop="offers" itemscope itemtype="http://schema.org/Offer">
						<span class="hit-qty">${hit.qty} unit${plural} @</span> <span itemprop="price" content="${hit.price}" class="hit-price">${hit.price}</span>
					</p>
					<div class="hit-footer">
						<p><span class="location">${hit.location}</span></p>
						<p><span class="bullet">Item</span> <a href="/items/${hit.itemno}/${hit.pagetitle.toLowerCase().replace(/\s/g, '+')}"><span itemprop="productID" class="itemno">${hit.itemno}</span></a></p>
					</div>
					<div class="item">	
						<div class="userprefs">
							<div>
								<a href="#" x-bind="toggle">
								<svg xmlns="http://www.w3.org/2000/svg" :fill="isFavorite ? '#fa0114' : 'none'" :class="{ 'favorite': isFavorite }"  viewBox="0 0 24 24" stroke="currentColor">
									<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z" />
								</svg>Favorite</a>
							</div>
							<div>
								<a href="##"><svg  fill=none xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" stroke="currentColor">
								<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8.684 13.342C8.886 12.938 9 12.482 9 12c0-.482-.114-.938-.316-1.342m0 2.684a3 3 0 110-2.684m0 2.684l6.632 3.316m-6.632-6l6.632-3.316m0 0a3 3 0 105.367-2.684 3 3 0 00-5.367 2.684zm0 9.316a3 3 0 105.368 2.684 3 3 0 00-5.368-2.684z" />
								</svg>Share</a>
							</div>
						</div>
						</div>
					</footer>
				</article>`;
			}
		 },
		}),
		pagination({
		  container: '#pagination',
		}),
  
  
		configure({
		  hitsPerPage: 16
		})
  
	  ])
  }