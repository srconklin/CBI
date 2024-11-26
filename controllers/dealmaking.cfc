component accessors=true extends="controllers.base.common"{
    
	/*************************************************
	 makedeal (POST)
	 submit of either an offer,inquiry,message
	 ajax: yes
		
	************************************************/
	public void function makeDeal(struct rc= {}) {
			
            /*
			  validate form by loading into bean.
			  note if ajax in use on form submit and it errors, 
			  then error is rendered and controller aborted	
			*/
		    // xtra bot protection
			captchaProtect();							

			// either offer or inquiry
			var deal = validateform('dealbean');
			
			//var userLoggedInBeforeOffer = userService.getUserSession().isloggedIn;
			
			// make offer or inquiry
			// if error then show and send it
			if(!deal.sendoffer()) 
				handleServerError(deal.getErrorContext());
			
			//success
			else {
				
				// show response was sucessful
				rc["response"]["res"] = true;

				// using the deal thread chat to manage transactions. no auto register/login
				if (deal.isDealaThread()) {
					rc["response"]["payload"] = 'trigger_a_reload_please';		
				}
				/* 
				AUTO REG/LOGIN from legacy system
				offerer was not logged in (unknown before); then legacy system performs a partial log in; 
				update the session vars to also partially log them in here
				*/
				else if (!userService.getUserSession().isloggedIn ) {	

					//get the data for the deal
					var dd = deal.getData();
		
					// sync session with actions of legacy system 
					updateUserSession( {
						email: dd.email, 
						firstName : dd.firstName, 
						lastName: dd.lastName, 
						validated: dd.validated, // set to 1 by proctrans
						regstat: dd.regstat,
						pno: dd.pno,
						verifyVerified: dd.verifyVerified,
						pwdVerified: dd.pwdVerified,
						previouslyVerified: dd.verifyVerified ? true : false,
					});
							

					// first name to personalize message bubbles
					rc["response"]["payload"]["firstName"] =  userService.getUserSession().firstName;
					
					// new person auto registered, show welcome new user toast
					if (deal.isNewPerson()) 
						// set a toast messsage to tell new user that we created an account
						rc["response"]["payload"]["message"] = 'isNewPerson';
					else if (rc.userSession.regstat eq 0)
						// set a toast messsage to welcome and existing user who needs to be verified
					 	rc["response"]["payload"]["message"] = 'existingPersonnv';
					else 
						// set a toast messsage to welcome and existing user back asking them to login
						rc["response"]["payload"]["message"] = 'existingPerson';
					/* 
					 if user has a regstat of 0 (incomplete reg profile)
					 send them to route to request this auto registration/login be completed.
					 1) verify their email and/or 2) set a password
					 if regstat =1 then just refresh the page
					*/
					if (rc.userSession.regstat eq 0) 
						rc["response"]["payload"]["redirect"] = '/completeautoreg';		
					else 
						rc["response"]["payload"]["redirect"] = '/login';	

				// user logged in by themselves or were auto logged in by a previous deal offer
				// refresh the page to close the modal and show the message		
				} else {
					rc["response"]["payload"] = 'trigger_a_reload_please';	
				}
			}	
			
		renderResult();	

    }


}    