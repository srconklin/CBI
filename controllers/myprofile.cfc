component accessors=true extends="controllers.base.common" {
    
	property usergateway;
	property config;

	function before( rc ) {
        super.before(rc);

		if (!rc.userSession.isEmailVerified or !rc.userSession.hasPassword) {
			rc.incompleteUserAccess = true;
			renderResult('/completeautoreg', 'incompleteUserAccess');
		}
     
    }
		
	/************************************
	 GET METHODS
	*************************************/

	/************************************
	 myProfile Default (GET)
	 update contact,set password,
	 my address forms
	*************************************/
	public void function default(struct rc = {}) {
		rc.myaddress = {
			locGid : ''
		};

		// if (!rc.userSession.isEmailVerified or !rc.userSession.hasPassword) 
		// 	renderResult('/completeAutoReg');
	     
		// populate the update contact info form
		rc.user = usergateway.getContactInfo(rc.userSession.pno);
		//populate the myaddress form
		var user = usergateway.getUserPrimaryAddress(rc.userSession.pno);
		
		if (arrayLen(user)) {
			rc.myaddress = user[1];
		} 
				
	}
	/**********************************
	 offer and inquiries screen
	 ajax :no
	************************************/
	public void function myoffers(struct rc = {}) {
	 	rc.offers = variables.userGateway.getOffers(rc.userSession.pno);
	}

	/**********************************
	 my favorites screen
	 ajax :no
	************************************/
	public void function myfavorites(struct rc = {}) {
		// item preview modal is present on home page, need to param it so it does not break
		param rc.content.specstable='';
		param rc.content.payterms='';
		param rc.content.shipterms='';
		
		rc.favorites = []; 
		var content = {}; 

		for (i = 1; i <= arrayLen(rc.userSession.favorites); i++) {
			content = deserializeJSON(fileRead(ExpandPath( "./" ) & '/data/#rc.userSession.favorites[i]#.json', 'UTF-8'))
			content['encItemURI'] = '#getPageContext().getRequest().getScheme()#//:#cgi.http_host#/items/#rc.userSession.favorites[i]#/#lcase(reReplaceNocase(content.pagetitle, "\s", "+" , "all"))#';
			rc.favorites.append(content);
		}

   }


	/**********************************
	 load the details for a particluar 
	 offer or inquiry thread
	 (shown in a modal)
	 ajax :yes
	************************************/
	 public void function dealdetails(struct rc = {}) {
		param name="rc.refnr" default="0";

		rc['response']['payload'] = variables.userGateway.getOfferDetails(rc.refnr);
		rc["response"]["res"] = true;
	 	renderResult();
	 }

	
	 	
	/************************************
	 POST METHODS
	*************************************/

	/***********************************************
		updateContactInfo (POST)
		My Profile update contact information
		ajax :yes
	**********************************************/
	public void function updateContactInfo(struct rc = {}) {
		rc.pno = rc.userSession.pno;
		
		// xtra bot protection
		captchaProtect();	

		var cb = validateform('contactInfobean');
		cb.update();

		if(cb.hasErrors()) {
			handleServerError(cb.getErrorContext());
			
		} else {
			rc["response"]["res"] = true;
		}

		renderResult();
	
   }

   	 
	/***********************************************
		updateAddress (POST)
		My Profile enter update an address
		ajax :yes
	**********************************************/
	public void function updateAddress(struct rc = {}) {
		rc.pno = rc.userSession.pno;
		
		// xtra bot protection
		captchaProtect();	

		var ua = validateform('updateaddressbean');
		ua.update();

		if(ua.hasErrors()) {
			handleServerError(ua.getErrorContext());
			
		} else {
			rc["response"]["res"] = true;
		}

		renderResult();
	
   }
	/***********************************************
		changepassword (POST)
		My Profile change password
		ajax :yes
	**********************************************/
	public void function changepassword(struct rc = {}) {
		rc.pno = rc.userSession.pno;
		
		// xtra bot protection
		captchaProtect();	

		var pm = validateform('passwordmgrbean');
		pm.changePassword();

		if(pm.hasErrors()) {
			//rc["response"]["errors"] = pm.getErrorContext();
			handleServerError(pm.getErrorContext());
		} else {
			rc["response"]["res"] = true;
		}

		renderResult();
	
   }
	/***********************************************
		updateCommPref (POST)
		My Profile update communication preferences
		ajax :yes
	**********************************************/
	public void function updateCommPref(struct rc = {}) {
		param name="rc.bcast" default="0";

		// xtra bot protection
		captchaProtect();	

		var cp = validateform('updatecommpref');
		cp.setPno(rc.userSession.pno);
		cp.updateCommPref();

		if(cp.hasErrors()) {
			handleServerError(cp.getErrorContext());
		} else {
			rc["response"]["res"] = true;
		}
		renderResult();
	
   }

  
}

	