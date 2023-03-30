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
		param name="rc.type" default="offer";

            /*
			  validate form by loading into bean.
			  note ajax if in use on form submit and it errors
			  then error is rendered and controller aborted	
			*/
			
			validateform(rc, '#rc.type#bean');
			
			// interface to dynabuilt system by meeting requirements of template as an include
			form.ccSender = true;
            if (structKeyExists(rc, 'phone2')) 
				form.phone1 = rc.phone2;
           
			var vars  = {
				validated = session.validated,
				pno = session.pno,
				sessionID = session.sessionID,
				vizPagetop = session.vwrCoRelatNo
			}
			makeLegacyCall(rc, "proctrans", vars);

			//no errors from legacy system
			if(!len(rc.response.errors)) {
						
				// user is logged in in legacy system, sync some variables we need to keep the user 
				// session complete in this version.
				if(structKeyExists(rc, 'firstname')) 
				{

					var user= {
						email: rc.email, 
						firstName : rc.firstName, 
						lastName: rc.lastName,
						newperson: rc.vars.newperson
					}

					rc["response"]["payload"] = variables.userService.syncValidatedUser(user);
				}
				
			}
			renderResult(rc);	

    }


}    