component accessors=true extends="controllers.base.common" {
    
	property usergateway;
	property config;

	/************************************
	 GET METHODS
	*************************************/

	/************************************
	 myProfile Default (GET)
	 update contact,set password,
	 my address forms
	*************************************/
	public void function default(struct rc = {}) {
		// populate the update contact info form
		rc.user = usergateway.getContactInfo(rc.userSession.pno);
		//populate the myaddress form
		var user = usergateway.getUserPrimaryAddress(rc.userSession.pno);
		
		rc.myaddress = {};
	    if (arrayLen(user)) {
			rc.myaddress = user[1];
		} 
	}

	 
	/***********************************************
		updateContactInfo (POST)
		my account update contact information
		ajax :yes
	**********************************************/
	public void function updateContactInfo(struct rc = {}) {
		rc.pno = rc.userSession.pno;
		var cb = validateform(rc, 'contactInfobean');
		cb.update();

		if(cb.hasErrors()) {
			handleServerError(cb.getErrorContext());
			
		} else {
			rc["response"]["res"] = true;
		}

		renderResult(rc);
	
   }

   	 
	/***********************************************
		updateAddress (POST)
		my account enter update an address
		ajax :yes
	**********************************************/
	public void function updateAddress(struct rc = {}) {
		rc.pno = rc.userSession.pno;
		
		var ua = validateform(rc, 'updateaddressbean');
		ua.update();

		if(ua.hasErrors()) {
			handleServerError(ua.getErrorContext());
			
		} else {
			rc["response"]["res"] = true;
		}

		renderResult(rc);
	
   }
	/***********************************************
		changepassword (POST)
		my account change password
		ajax :yes
	**********************************************/
	public void function changepassword(struct rc = {}) {
		rc.pno = rc.userSession.pno;
		var pm = validateform(rc, 'passwordmgrbean');
		pm.changePassword();

		if(pm.hasErrors()) {
			rc["response"]["errors"] = pm.getErrorContext();
		} else {
			rc["response"]["res"] = true;
		}

		renderResult(rc);
	
   }

  
}

	