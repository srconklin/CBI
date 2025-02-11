component accessors=true extends="controllers.base.common" {
	property generalgateway;
	property usergateway;
	property utils;

	/******************************
	 default controller (GET)
	 home page
	******************************/
	function default(struct rc = {}) {
		// item preview modal is present on home page, need to param it so it does not break
		param rc.content.specstable='';
		param rc.content.payterms='';
		param rc.content.shipterms='';
		
		if (structKeyExists(cookie, "rv") && len(cookie.rv) > 0) {
			// Use regex to remove the square brackets of the string array representation
			var rv = REReplace(cookie.rv, "[\[\]]", "", "all");
			 if (listLen(rv)) {
				rc.recentlyviewed=generalgateway.getSpecialityItems('recentlyviewed', rv);
			 }
		}
		rc.featureds=generalgateway.getSpecialityItems('featureds');
		rc.newones=generalgateway.getSpecialityItems('isnew');
		rc.hotmfrs=generalgateway.getHotMfrs();

	}

	/******************************
	 search controller (GET)
	 algolia instasearch
	******************************/
	function search(struct rc = {}) {
		// item preview modal is present on home page, need to param it so it does not break
		param rc.content.specstable='';
		param rc.content.payterms='';
		param rc.content.shipterms='';
		param url.query='';
		param url.mfrs='';
		param rc.term='';


		writedump(var="#rc#",  abort="true");
		// Extract and decode the term from cgi.PATH_INFO
		var pathInfo = cgi.PATH_INFO;
    
		// Remove "/search/" base path
		if (left(pathInfo, len("/search/")) eq "/search/") {
			pathInfo = removeChars(pathInfo, 1, len("/search/"));
		}
	
		// Decode the path info
		rc.path =  urlDecode(urldecode(pathInfo));

	
		if ( len(url.query) || len(url.mfrs) || arrayContains(application.arValidMenus, rc.path) ) {
			variables.fw.setView('main.search');
		} else
		   renderResult('/');
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
			
			rc.content =deserializeJSON(fileRead(ExpandPath( "./" ) & '/data/#rc.id#.json', 'UTF-8'));
			rc.URI = variables.utils.buildURI(rc.id, rc.content.pagetitle);
			// rc.URI = '#getPageContext().getRequest().getScheme()#//:#cgi.http_host#/items/#rc.id#/#lcase(reReplaceNocase(rc.content.pagetitle, "\s", "+" , "all"))#';
			rc.bc =fileRead(ExpandPath( "./" ) & '/data/bc/#rc.id#.cfm');
		} 
		catch(any e) {
				variables.fw.setView('main.notFound');
		}

		variables.fw.setview('item.default');
	}

	
	/******************************
	 is user logged in
	******************************/
	public void function IsLoggedIn(struct rc = {}) {
		rc["response"]["res"] = true;
		rc['response']['payload'] =  rc.userSession.isloggedIn;
		renderResult();
	}



	/**********************************
	 load all favorites for the logged
	 in user
	 ajax :yes
	************************************/
	public void function getFavorites(struct rc = {}) {
		rc["response"]["res"] = true;
		rc['response']['payload'] =  rc.userSession.favorites;
		renderResult();
	}

	
	/**********************************
	 load all favorites for the logged
	 in user
	 ajax :yes
	************************************/
	// public void function getRecentlyViewed(struct rc = {}) {
	// 	param rc.items='';

	// 	rc["response"]["res"] = true;
	// 	rc['response']['payload'] =  [];
	// 	if (len(rc.items)) {
	// 		rc['response']['payload'] =  generalgateway.getItemsByItemno(rc.items);
	// 	}
		
	// 	renderResult();
	// }

	

	/*******************************
	 make an item a favorite (POST)
	 ajax :yes
	*******************************/
	public void function toggleFavorite(struct rc = {}) {
		param name="rc.itemno" default=0  type="integer";
		param name="rc.isfavorite" default=false  type="boolean";
		
		if(rc.itemno gt 0 and rc.userSession.isloggedIn){

			try {
				
				variables.generalGateway.toggleFavorite(rc.itemno, rc.userSession.pno, rc.isfavorite)
				// update to session
				var favs = variables.userGateway.getUserFavorites(rc.userSession.pno);
				getUserByEmailAndSetSessionWithState(rc.userSession.email, {'favorites': favs});
				rc["response"]["res"] = true;
				rc['response']['payload'] = 'favorite for #rc.itemno# toggled to #rc.isfavorite#';
				
			} 
			catch(any e) {
				rc["response"]["errors"] = e.message;
			}

		}
		
		renderResult();
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
		
		// xtra bot protection
		captchaProtect();	
		
		var ll = variables.beanFactory.getBean( 'locationlookupbean' );
		ll.setPlacesResponse(rc.placesResponse);
		ll.performLookup();

		if(ll.hasErrors()) {
			handleServerError(ll.getErrorContext());
			
		} else {
			rc["response"]["res"] = true;
			rc['response']['geoChain'] = ll.getGeoChain();
		}
	
		renderResult();
	
   }

    /******************************
	 contact (POST)
	 sbumit a new registration 
	 ajax :yes
	******************************/
	public void function submitContact(struct rc = {}) {

		// contact form consists of personal fields + password mgmt widget
			var contact = validateform('contactbean');

			// contact the user
			contact.sendMessage();
			
			//if errors from legacy system
			if(contact.hasErrors()) {
				
				// get an error context to pass to handleServerError
				var err = contact.getErrorContext();
			
				// parse error
				handleServerError(err);

			} else {		
				rc["response"]["res"] = true;
				rc["response"]["payload"]["message"] = 'contact';
			}
			
			renderResult();
		
	}

	
	/******************************
	 site wide error handler
	******************************/
	function error(struct rc = {}) {
		sendErrorEmail();
		if (utils.isAjaxRequest()) {
			rc["response"]["errors"] = request.exception.message;
			 renderResult(abort=true);
		}	 
		
	}

	/******************************
	 site wide page not found
	******************************/
	function notFound(struct rc = {}) {
		 // Set 404 status code (Page Not Found)
		 cfheader(statuscode="404");
	}
	
}