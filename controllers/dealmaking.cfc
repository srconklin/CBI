component accessors=true extends="controllers.base.common"{
    
	/******************************
	 makedeal (POST)
	 submit of either an offer or inquiry from modal
	 ajax: yes
		
	************************************************/
	public void function makeDeal(struct rc= {}) {
			
            /*
			  validate form by loading into bean.
			  note if ajax in use on form submit and it errors, 
			  then error is rendered and controller aborted	
			*/
		    // xtra bot protection
			captchaProtect(rc);							

			// either offer or inquiry
			var deal = validateform(rc, 'dealbean');
			
			//var userLoggedInBeforeOffer = userService.getUserSession().isloggedIn;
			
			// make offer or inquiry
			// if error then show and send it
			if(!deal.sendoffer()) 
				handleServerError(rc, deal.getErrorContext());
			
			//success
			else {
				
				rc["response"]["res"] = true;

				// offerer was not logged in (unknown before); then legacy system performs a partial log in; 
				// update the session vars to also partially log them in here
				if (!userService.getUserSession().isloggedIn ) {	

					var dd = deal.getData();
		
					// partial login using session
					variables.userService.setUserSession( {
								email: dd.email, 
								firstName : dd.firstName, 
								lastName: dd.lastName, 
								validated: dd.validated, // set to 1 by proctrans
								regstat: dd.regstat,
								pno: dd.pno,
								hasPassword: dd.hasPassword,
								verifyVerified: dd.verifyVerified,
								previouslyVerified: dd.verifyVerified ? true : false,
							});

					rc["response"]["payload"]["firstName"] =  userService.getUserSession().firstName;
					
					// new person auto registered, show welcome new user toast
					if (deal.isNewPerson()) 
						// set a toast messsage to tell new user that we created an account
						rc["response"]["payload"]["message"] = 'isNewPerson';
					else 
						// set a toast messsage to weclome and existing user back
					 	rc["response"]["payload"]["message"] = 'existingPerson';
					
					// send the user to completeprofile where it will determined if they should verify their email and set a password
					// note this test works for not logged in users 
					if (userService.getUserSession().regstat eq 0) {
						session.verifyemail = userService.getUserSession().email;
						rc["response"]["payload"]["redirect"] = '/completeprofile';		
					}
						
				}
			}	
			
		renderResult(rc);	

    }


}    