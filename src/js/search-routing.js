/*************************************
 * 
 * 
 * InstantSearch manages a state called uiState. It contains information like query, facets, or the current page, including the hierarchy of the added widgets.

To persist this state in the URL, InstantSearch first converts the uiState into an object called routeState. This routeState then becomes a URL. Conversely, when InstantSearch reads the URL and applies it to the search, it converts routeState into uiState. This logic lives in two functions:

stateToRoute: converts uiState to routeState.
routeToState: converts routeState to uiState.
 *
 * refer to uiState docs for details: https://www.algolia.com/doc/api-reference/widgets/ui-state/js/
 */

import {
	history as historyRouter
  } from 'instantsearch.js/es/lib/routers';
 
  // Returns a slug from the category name.
  // Spaces are replaced by "+" to make
  // the URL easier to read and other
  // characters are encoded.
  function getCategorySlug(name) {
	//const encodedName = decodedCategories[name] || name;
	return name
	  .split(/\s/g)
	  .map(encodeURIComponent)
	  .join('+');
  }
  
  // Returns a name from the category slug.
  // The "+" are replaced by spaces and other
  // characters are decoded.
  function getCategoryName(slug) {
	//const decodedSlug = encodedCategories[slug] || slug;
  
	return slug
	  .split('+')
	  .map(decodeURIComponent)
	  .join(' ');
  }
    
   const router = historyRouter({

	/********************************************************
		windowTitle: a method to map the routeState object 
		returned from stateToRoute to the window title.
	*******************************************************/
	windowTitle(routeState) {

	  const { category, query } = routeState;
	  const queryTitle = query ? `CBI Results for "${query}"` : 'CBI Search';
  
	  if (category) {
		return `${category} – ${queryTitle}`;
	  }
  
	  return queryTitle;
	},
  
	/************************************************************************
		createURL: a method called every time you need to create a URL. When:
		You want to synchronize the routeState to the browser URL
		You want to render a tags in the menu widget
		You call createURL in one of your connectors’ rendering methods.
	 *************************************************************************/
	createURL({ qsModule, routeState, location }) {
	  const urlParts = location.href.match(/^(.*?)\/search/);
	  const baseUrl = `${urlParts ? urlParts[1] : ''}/`;
	  
	  const categoryPath = routeState.category ? `${getCategorySlug(routeState.category)}/` : '';

	  const queryParameters = {};
  
	  if (routeState.query) {
		queryParameters.query = encodeURIComponent(routeState.query);
	  }
	  if (routeState.page !== 1) {
		queryParameters.page = routeState.page;
	  }
	  if (routeState.mfrs) {
		queryParameters.mfrs = routeState.mfrs.map(encodeURIComponent);
	  }
  
	  const queryString = qsModule.stringify(queryParameters, {
		addQueryPrefix: true,
		arrayFormat: 'repeat',
	  });
  
	  
	  return `${baseUrl}search/${categoryPath}${queryString}`;
	},
  
    /************************************************************************
		parseURL: a method called every time the user loads or reloads the page,
		or clicks on the back or next buttons of the browser.
	*************************************************************************/
	parseURL({ qsModule, location }) {
	  const pathnameMatches = location.pathname.match(/search\/(.*?)\/?$/);
	  const category = getCategoryName(
		(pathnameMatches && pathnameMatches[1]) || ''
	  );
	  const { query = '', page, mfrs = [] } = qsModule.parse(
		location.search.slice(1)
	  );
	  // `qs` does not return an array when there's a single value.
	  const allmfrs = Array.isArray(mfrs) ? mfrs : [mfrs].filter(Boolean);
	  return {
		query: decodeURIComponent(query),
		page,
		mfrs: allmfrs.map(decodeURIComponent),
		category
	  };
	},
  });
  
//   
  const stateMapping = {

	// stateToRoute: converts uiState to routeState.
	// implement stateToRoute to flattem the uiState object into a URL
	stateToRoute(uiState) {
		
	  const indexUiState = uiState['cbi'] || {};
	  let widgets = {
			query: indexUiState.query
		}

		if(document.getElementById('breadcrumb')) {
			widgets= {...widgets, 
				page: indexUiState.page,
				mfrs: indexUiState.refinementList && indexUiState.refinementList.mfr,
				category: indexUiState.hierarchicalMenu && indexUiState.hierarchicalMenu['categories.lvl0'].join('_'),}
		}

		return widgets;
	},
  
	// routeToState: converts routeState to uiState.
	// restore the URL into a UI state to sync refinements
	routeToState(routeState) {
	    
	  let widgets = { 
		query: routeState.query
	  }
	
	  if(document.getElementById('breadcrumb')) {
		widgets = {
			...widgets, 
			page: routeState.page,

			hierarchicalMenu: {
				'categories.lvl0': routeState.category && routeState.category.split('_')
			},
			refinementList: {
				mfr: routeState.mfrs,
			}
		}
	  }
	  return {
		cbi: widgets
	  };
	},
  };
  
  const searchRouting = {
	router,
	stateMapping
  };
  
  export default searchRouting;
  