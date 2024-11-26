import {hierarchicalMenu, refinementList, searchBox, pagination, configure, hits, panel, breadcrumb, clearRefinements, sortBy, stats} from 'instantsearch.js/es/widgets';

const validWidgets = [];

// Function to check if an element exists on the page
function elementExists(selector) {
    return document.querySelector(selector) !== null;
}


const config = configure({
    hitsPerPage: 16
});

validWidgets.push(config);

if (elementExists('#searchbox')) {
        
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

    validWidgets.push(searchbox);

}

if (elementExists('#breadcrumb')) {
    
   const bc=  breadcrumb({
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
        
        })
   
    validWidgets.push(bc);

}

if (elementExists('#clear-refinements')) {
    const clear =   clearRefinements({
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
        })

        validWidgets.push(clear);
} 



if (elementExists('#categories')) {

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

   const categories  =  HMWithPanel({
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
        })

        validWidgets.push(categories);
}


if (elementExists('#categories')) {

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

    const mfr = refinementListWithPanel({
        container: '#mfr',
        attribute: 'mfr',
        showMore: true,
        showMoreLimit: 20,
        searchable: true,
        searchablePlaceholder: 'search a mfr...',
        sortBy: ['name:asc'],

        })

    validWidgets.push(mfr);
}

if (elementExists('#stats')) {

    const s = stats({
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
        })
    
        validWidgets.push(s);
}


if (elementExists('#statsfilter')) {

   const statsfilter =  stats({
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
        })
    
        validWidgets.push(statsfilter);
}

if (elementExists('#hits')) {

const h = hits({
    container: '#hits',

    //   transformItems(items, { results }) {
    
    // 	if(favfilter) {
    // 		document.getElementById('refinements').style.display = 'none'
    // 		const filteredItems = results.hits.filter((hit) =>  Alpine.store('favorites').isFavorite(hit.itemno));
    // 		results.nbHits = filteredItems.length;
    // 		results.nbPages = 1;
    // 		return filteredItems
    // 	} else 
    // 	document.getElementById('refinements').style.display = 'block';
            
        
    // 	return items;
    //   },
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
            document.getElementById('refinements').style.display = 'block';
                
            const plural = hit.qty > 1 ? 's' : '';
            const encItemURI =  window.buildItemURI(hit.itemno, hit.pagetitle) 
            return html`
            <article class="hit" itemscope itemtype="http://schema.org/Product" >
                <header>
                <a href="#" x-on:click.prevent="$dispatch('show-item', { itemno: ${hit.itemno} })">
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
                    <p><span class="bullet">Item</span> <a href="${encItemURI}"><span itemprop="productID" class="itemno">${hit.itemno}</span></a></p>
                </div>
                <div class="item">	
                    <div class="userprefs">
                        <div>
                            <a href="#" x-on:click.prevent="$store.favorites.IsloggedIn ? $store.favorites.toggle(${hit.itemno}) : $dispatch('show-login', { title: 'You must login to continue' })">
                                <svg xmlns="http://www.w3.org/2000/svg"  
                                :class="{ 'favorite': $store.favorites.isFavorite(${hit.itemno}) }" 
                                :fill="$store.favorites.isFavorite(${hit.itemno}) ? '#fa0114' : 'none'"
                                viewBox="0 0 24 24" stroke="currentColor"
                                ><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z" />
                                </svg>Favorite
                            </a>
                        </div>
                        <div>
                            <a href="#" x-on:click.prevent="$clipboard('${encItemURI}');$tooltip('Copied to clipboard!')"><svg fill=none xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8.684 13.342C8.886 12.938 9 12.482 9 12c0-.482-.114-.938-.316-1.342m0 2.684a3 3 0 110-2.684m0 2.684l6.632 3.316m-6.632-6l6.632-3.316m0 0a3 3 0 105.367-2.684 3 3 0 00-5.367 2.684zm0 9.316a3 3 0 105.368 2.684 3 3 0 00-5.368-2.684z" />
                            </svg>Share</a>
                        </div>
                    </div>
                    </div>
                </footer>
            </article>`;
        }
    },
    })
    validWidgets.push(h);
}


if (elementExists('#pagination')) {

    const paging = pagination({
        container: '#pagination',
        })

    validWidgets.push(paging);
}


if (elementExists('#sort-by')) {

    let sb = '';
    if (process.env.SE === 'typesenseSearch') {
            sb = sortBy({
                container: '#sort-by',
                items: [
                    { label: 'Most relevant', value: process.env.INDEX },
                    { label: 'Recently added', value: `${process.env.INDEX}/sort/unixTimeStamp:desc` },
                    { label: 'Featured', value: `${process.env.INDEX}/sort/isFeatured:desc` },
                ]
            })
    }
    else {
            sb = sortBy({
                container: '#sort-by',
            items: [
                { label: 'Most relevant', value: process.env.INDEX },
                { label: 'Recently added', value: 'recently_added' }
            ]
            })
    }

    validWidgets.push(sb);
}


export default validWidgets;