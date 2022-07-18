component  accessors=true extends="model.base.personal" {

	property framework;
	property beanFactory;
    property userService;
	property utils;


	public void function default(struct rc = {}) {
		if (variables.userService.isloggedIn()) {
			variables.framework.redirectCustomURL( "/myprofile" );
		}
		
	}

	// verify email from link in email. must have token and email present
	public void function verifyemail(struct rc = {}) {
		if(!structKeyExists(rc, 'email') && !structKeyExists(rc, 'token') )
			variables.framework.redirectCustomURL( "/register" );
			
		// validate token; result.success is true or false;if true then we get a user packet to pass to setting up a new session
		rc.result  = variables.userService.verifyemail(rc.email, rc.token);	
		// already verified, just redirect them to their profile where it shows them the email is already verified
		if(structKeyExists(rc.result, 'alreadyVerified')) {
			variables.framework.redirectCustomURL( "/myprofile" );
		}
		if (rc.result.success) {
			//var user = rc.result.user;
			     //user authenticated
			 rc.result.user.validated = 2;
			variables.userService.setUserSession(rc.result.user);
		}

	}

	// resend email link
	public void function resendLink(struct rc = {}) {
		if(!structKeyExists(session, 'verifyemail'))
			variables.framework.redirectCustomURL( "/register" );
	
		rc.email = session.verifyemail;	
		variables.userService.resendLink(rc.email);
		// variables.framework.redirectCustomURL( "/verify_email" );
		variables.framework.setview('register.verify_email');
	
	}

	// show instructions page to verify email 
	public void function verify_email(struct rc = {}) {
		if(!structKeyExists(session, 'verifyemail'))
			variables.framework.redirectCustomURL( "/register" );

		rc.email = session.verifyemail;

	}


	public void function register(struct rc = {}) {

		var response = {};
		response["req"] = rc;
		response["payload"] = {};

		if(not utils.validateCaptcha(rc)) {
			response["res"] = false;
			response["errors"] = {};
			response["errors"]["captcha"] = 'Sorry, but we do not think you are human';
		} else {

			// get the bean and populate it from form fields
			var register = variables.beanFactory.getBean( "registerbean" );
			variables.framework.populate( cfc=register, key=rc.fieldnames, trim=true );

			// Validate form input
			if ( !register.isValid() ) {
				//error
				response["res"] = false;
				response["errors"] = register.getErrors();
			} else {
				
				response["res"] = true;
				response["errors"] ={};

				variables.domain = cgi.https eq 'on'? 'https://' : "http://" & cgi.http_host;
				// set the session variable to persist the email while relocating to the verify_email screen
				// set the payload data that we need if successful (or if an error in the case of emailinuse_nv)
				session.verifyemail = rc.email;
				response["payload"]["firstname"] = rc.firstname;
				
				try {
					include "/cbilegacy/legacySiteSettings.cfm"
					include "/cbilegacy/procreg2.cfm"
					response["payload"]["redirect"] = '/verify_email';
				} catch (e) {
					// email not verified. not considering this an error; leave res =true and redirect to verify screen
					if (e.errorcode eq 'emailinuse_nv') {
						//using server side message instead.
						// response["errors"]['emailinuse'] = e.message;
						response["payload"]["redirect"] = '/verify_email/nv/1';
					}	
					//email in use, then don't allow registration to proceed, consider an error and no redirect
					else if (e.errorcode eq 'emailinuse') {
						response["res"] = false;
						response["errors"]['emailinuse'] = e.message;
					}
					else {
						response["res"] = false;
						writeDump(e);
						abort;
					}	
					 
				}
				
			}
			
		}

		variables.framework.renderData().type( 'json' ).data( response ).statusCode( 200 ).statusText( "Successful" );
	}


	
}