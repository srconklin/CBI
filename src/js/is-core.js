import searchRouting from './search-routing';

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
	searchClient : algoliaClient,
	routing: searchRouting,
  });
  