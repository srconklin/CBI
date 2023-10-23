component accessors=true extends="controllers.base.common" {

	/******************************
	 default controller (GET)
	 home page
	******************************/
	function default(struct rc = {}) {
		// item quickview modal is present on home page, need to param it so it does not break
		param rc.content.specstable='';
	}
	
	/******************************
	 show item detail page (GET)
	 migrate
	******************************/
	public void function showItem(struct rc = {}) {
		param name="rc.id" default=0  type="integer";
		
		try {
			// var result = itemService.getItem(rc.id);
			// structappend(rc, result,true);
			
			rc.content =deserializeJSON(fileRead(ExpandPath( "./" ) & '/data/#rc.id#.json'));
			rc.bc =fileRead(ExpandPath( "./" ) & '/data/bc/#rc.id#.cfm');
		} 
		catch(any e) {
				variables.fw.setView('main.notFound');
		}
	}

	 /***********************************************
		locationlookup (POST)
		given a google places object from an autocomplete
		box return the geochain from server 
		ajax :yes
	**********************************************/
	public void function locationlookup(struct rc = {}) {
		param rc.placesResponse='';
		rc['response']['geoChain'] = [];
		
		var ll = variables.beanFactory.getBean( 'locationlookupbean' );
		ll.setPlacesResponse(rc.placesResponse);
		ll.performLookup();

		if(ll.hasErrors()) {
			handleServerError(ll.getErrorContext());
			
		} else {
			rc["response"]["res"] = true;
			rc['response']['geoChain'] = ll.getGeoChain();
		}
	
		renderResult(rc);
	
   }

	
	/******************************
	 site wide error handler
	******************************/
	function error(struct rc = {}) {
		sendErrorEmail(rc)
		
	}
	
}