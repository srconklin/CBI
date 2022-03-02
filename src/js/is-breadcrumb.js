
 export const breadcrumb =   instantsearch.widgets.breadcrumb({
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