import instantsearch from 'instantsearch.js';
import searchRouting from './search-routing';
import importSearchClient from './dynamicSearchClientImporter';
import validWidgets from './instasearchWidgets';

//let search = null;

/***************************************
 *  Instasearch
 *************************************/
// Helper function to update the URL to remove the query
function updateURLQuery() {
	const url = new URL(window.location);
	url.searchParams.set('query', '');
	window.history.pushState({}, '', url); // Update the URL
  }

  function transitionElement(ele) {
	ele.classList.add('transitioning');
	setTimeout(() => {
		ele.classList.add('is-visible');
		ele.classList.remove('transitioning'); // Clean up the transitioning class after the animation
	}, 50); // Small delay to ensure visibility change is rendered
  }
  
async function init() { 
  await importSearchClient()
    .then((searchClient) => {
      window.search = instantsearch({
        indexName: process.env.INDEX,
        searchClient,
        routing: searchRouting,
        searchFunction(helper) {
          const algoliaElement = document.getElementById('algolia');
          
          if (helper.state.query 
            || (helper.state.hierarchicalFacetsRefinements.hasOwnProperty('categories.lvl0') && helper.state.hierarchicalFacetsRefinements['categories.lvl0'].length)
            || helper.state.disjunctiveFacetsRefinements.hasOwnProperty('mfr')) {

            // Check if query is a period; hack to set a link to show entire inventory
            if (helper.state.query === '.') { 
              helper.setQuery(''); // Reset query to an empty string
			        updateURLQuery();
            }
            helper.search();
		      	transitionElement(algoliaElement);

          } else {
		      	// we are on the algolia page, and if we clear refinements or delete search term, then we show the entire inventory
            if (algoliaElement) {
			          	helper.search();
				          transitionElement(algoliaElement);
		      	// not on the algolia page, prevent search from firing	 
            } 
          }
        }
      });
      
      search.addWidgets(validWidgets);
      
    }).catch(error => {
      console.error('Error importing search client:', error);
    });
}   

export const asyncSearch = (async () => {
    await init();
    return search;
})();
