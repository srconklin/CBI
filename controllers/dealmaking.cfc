component accessors=true extends="controllers.base.common"{
    
	/******************************
	 makedeal (POST)
	 submit of either an offer or inquiry from modal
	 ajax: yes
	 
	 notes:
	

		These variables are set in the legacy system:
		pno, vwrCorelatno, name, newperson, validated =1 (?) 

		user can be newly created or identifed as pre-existing; 
		session.regstat:
		0= auto registered through an offer/inquiry (never completed a registration); 
		1=registered through a register page action
		(if validated then regstat = 1) 

		if the user is identified as pre-existing AND the regstat = 1,
		then why not flip them to validated = 2

	************************************************/
	public void function makeDeal(struct rc= {}) {
			
            /*
			  validate form by loading into bean.
			  note if ajax in use on form submit and it errors, 
			  then error is rendered and controller aborted	
			*/
			
			// either offer or inquiry
			var deal = validateform(rc, 'dealbean');
			
			var userLoggedInBeforeOffer = userService.getUserSession().isloggedIn;
			
			// make offer or inquiry
			// if error then show and send it
			if(!deal.sendoffer()) {
				handleServerError(deal.getErrorContext());
			
			//success
			} else {
				
				// offerer was not logged in (unknown before); then legacy system will have partially logged them in; 
				// update the session vars that the we have that the legacy does not
				if (!userLoggedInBeforeOffer ) {	
					var dd = deal.getData();
					// partial login
					variables.userService.setUserSession( {email: dd.email, firstName : dd.firstName, lastName: dd.lastName, isNewPerson :  deal.isNewPerson()});
				}
				
				rc["response"]["res"] = true;
				// payload for setting messaging into browser sesssionstate
				rc["response"]["payload"]["message"] = deal.isNewPerson() ? 'isNewPerson' : 'existingPerson';
				rc["response"]["payload"]["firstName"] =  userService.getUserSession().firstName;


			}
			
			renderResult(rc);	

    }


}    