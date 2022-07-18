component  accessors=true {

	property framework;
	property beanFactory;
	property userService;
	property utils;

	
	public void function create(struct rc = {}) {

		var response = {};
		response["req"] = rc;
		response["payload"] = '';
	
		if(not utils.validateCaptcha(rc)) {
			response["res"] = false;
			response["errors"] = {};
			response["errors"]["captcha"] = 'Sorry, but we do not think you are human';
		} else {

		// get the bean and populate it from form fields
		var inquiry = variables.beanFactory.getBean( "inquirybean" );
		// normalzing either phone2 into phone rc field
		variables.framework.populate( cfc=inquiry, key=rc.fieldnames, trim=true );

		// Validate form input
		if ( !inquiry.isValid() ) {
			//error
			response["res"] = false;
			response["errors"] = inquiry.getErrors();
		} else {
			
			response["res"] = true;
			response["errors"] ={};
			// interface to dynabuilt system by meeting requirements of template as an include 
			// setting flag to circumvent certain elements; redirects, html, data validation etc.
			variables.modern = true;
			Form.ccSender = true;
			
			// session exchange to local
			variables.validated = session.validated;
			variables.pno = session.pno;
			variables.sessionID = session.sessionID;
			variables.vizPagetop = session.vwrCoRelatNo;
		
		
			try {
				if (structKeyExists(rc, 'phone2')) 
					form.phone1 = rc.phone2;
				include "/cbilegacy/legacySiteSettings.cfm"
				include "/cbilegacy/proctrans.cfm"
			} catch (e) {
				response["res"] = false;
				response["errors"] = e.message;
				//writeDump(e);
				//abort;
			}
			
			/* 
			 
			  These variables are set in the legacy system
			   pno, vwrCorelatno, name, validated =1 (?) 

				user is logged in in legacy system, sync some variables we need to keep the user 
			   session complete in this version.

				user can be newly created or identifed as pre-existing; 
				session.regstat:
				0= auto registered through an offer/inquiry; 
				1=registered through a register page action
				(if validated then regstat = 1) 

				if the user is identified as pre-existing AND the regstat = 1, then why not flip them to validated = 2
				
			
			 */
			
			if(structKeyExists(rc, 'firstname'))	{
					user= {
						email: rc.email, 
						firstName : rc.firstName, 
						lastName: rc.lastName,
						newperson: variables.newperson
					}

					response["payload"] = variables.userService.syncValidatedUser(user);
				}

		 }
			
		}

		variables.framework.renderData().type( 'json' ).data( response ).statusCode( 200 ).statusText( "Successful" );
	}


	
}