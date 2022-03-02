
export const searchbox =  instantsearch.widgets.searchBox({
	container: '#searchbox',
	placeholder: 'keyword, category, make, model...',
	searchAsYouType: (document.getElementById('algolia')) ? true : false,
	queryHook(query, search) {
	  if(document.getElementById('algolia')) 
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

