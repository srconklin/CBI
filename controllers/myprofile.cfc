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
		rc.myaddress = {
			locGid : ''
		};

		if (!rc.userSession.isEmailVerified or !rc.userSession.hasPassword) 
			renderResult(rc, '/completeprofile');
	     
		// populate the update contact info form
		rc.user = usergateway.getContactInfo(rc.userSession.pno);
		//populate the myaddress form
		var user = usergateway.getUserPrimaryAddress(rc.userSession.pno);
		
		if (arrayLen(user)) {
			rc.myaddress = user[1];
		} 
				
	}
	 
	/***********************************************
		updateContactInfo (POST)
		My Profile update contact information
		ajax :yes
	**********************************************/
	public void function updateContactInfo(struct rc = {}) {
		rc.pno = rc.userSession.pno;
		
		// xtra bot protection
		captchaProtect(rc);	

		var cb = validateform(rc, 'contactInfobean');
		cb.update();

		if(cb.hasErrors()) {
			handleServerError(rc, cb.getErrorContext());
			
		} else {
			rc["response"]["res"] = true;
		}

		renderResult(rc);
	
   }

   	 
	/***********************************************
		updateAddress (POST)
		My Profile enter update an address
		ajax :yes
	**********************************************/
	public void function updateAddress(struct rc = {}) {
		rc.pno = rc.userSession.pno;
		
		// xtra bot protection
		captchaProtect(rc);	

		var ua = validateform(rc, 'updateaddressbean');
		ua.update();

		if(ua.hasErrors()) {
			handleServerError(rc, ua.getErrorContext());
			
		} else {
			rc["response"]["res"] = true;
		}

		renderResult(rc);
	
   }
	/***********************************************
		changepassword (POST)
		My Profile change password
		ajax :yes
	**********************************************/
	public void function changepassword(struct rc = {}) {
		rc.pno = rc.userSession.pno;
		
		// xtra bot protection
		captchaProtect(rc);	

		var pm = validateform(rc, 'passwordmgrbean');
		pm.changePassword();

		if(pm.hasErrors()) {
			//rc["response"]["errors"] = pm.getErrorContext();
			handleServerError(rc, pm.getErrorContext());
		} else {
			rc["response"]["res"] = true;
		}

		renderResult(rc);
	
   }
	/***********************************************
		updateCommPref (POST)
		My Profile update communication preferences
		ajax :yes
	**********************************************/
	public void function updateCommPref(struct rc = {}) {
		param name="rc.bcast" default="0";

		// xtra bot protection
		captchaProtect(rc);	

		var cp = validateform(rc, 'updatecommpref');
		cp.setPno(rc.userSession.pno);
		cp.updateCommPref();

		if(cp.hasErrors()) {
			handleServerError(rc, cp.getErrorContext());
		} else {
			rc["response"]["res"] = true;
		}
		//writedump(var="end of updateCommpref",  abort="true");
		renderResult(rc);
	
   }

  
}

	