import instantsearch from 'instantsearch.js';
import searchRouting from './search-routing';
import importSearchClient from './dynamicSearchClientImporter';
import validWidgets from './instasearchWidgets';

let search = null;

 /***************************************
  *  Instasearch
  *************************************/
 
 async function init() { 

	await importSearchClient()
		.then((searchClient) => {
			search = instantsearch({
			indexName: process.env.INDEX,
			searchClient,
			routing: searchRouting,
			searchFunction(helper) {

				const homeElement = document.getElementById('home');
    			const algoliaElement = document.getElementById('algolia');
				
				if (helper.state.query || (helper.state.hierarchicalFacetsRefinements.hasOwnProperty('categories.lvl0') && helper.state.hierarchicalFacetsRefinements['categories.lvl0'].length )|| helper.state.disjunctiveFacetsRefinements.hasOwnProperty('mfr')) {
					helper.search();
					if (homeElement) homeElement.style.display = 'none';
					if (algoliaElement) algoliaElement.classList.add('show');
				}
				else {
					if (algoliaElement) algoliaElement.classList.remove('show');
        			if (homeElement) homeElement.style.display = 'block';
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