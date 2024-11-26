
import algoliasearch from 'algoliasearch/lite';

//import Alpine from 'alpinejs';
//let favfilter =false;

const algoliaClient = algoliasearch(
	process.env.ALGOLIA_APP_ID,
	process.env.ALGOLIA_SEARCH_ONLY_API_KEY
  );
  

  // a custom client search proxy to prevent
  // https://www.algolia.com/doc/guides/building-search-ui/going-further/conditional-requests/js/
  const searchClient = {
	...algoliaClient
  };
  

  export default searchClient;


/*

//async 
	search(requests) {

	//	favfilter = false;
	// await Alpine.store('favorites').load();
		
	  // multiple request can come in at once. test every one
	  requests.every(({ params }) => {
		// a search, refinement or url that goes straight to results
		// show the algolia element 
		if(requests.length > 1 || params.query) {
		  document.getElementById('home').style.display = 'none'
		  document.getElementById('algolia').classList.add('show');

		//   if(params.query == 'favorites' && Alpine.store('favorites').favorites.length) {
		// 	params.query = '';
		// 	favfilter = true;
		//   }
		  
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
*/