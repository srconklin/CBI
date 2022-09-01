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

				// interface requirements to legacy system
				variables.domain = cgi.https eq 'on'? 'https://' : "http://" & cgi.http_host;
				variables.aeskey = application.AESKey;

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


	// show instructions page to verify email; redirected here from a first time registration, NOTE: session.verifyemail contains the email to be verified
	public void function verify_email(struct rc = {}) {
		
		param name="rc.resendLink" default="false";
		rc.result.success = true;

		// defaults - will remain set to this if session has expired or bot/indexer
		rc.title = "Hmm, something went wrong with verifying your email address.";
		rc.instruction = "Looks like there was a problem, likely too much time has passed since the link to verfiy your email was created. You can visit <a href='/myprofile'>My Account</a> to re-verify your email address."
		
		// only allow resend if we have an email in session.
		rc.allowResend=false;
		rc.svg = '<svg xmlns="http://www.w3.org/2000/svg" class="icon-title" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M16 12a4 4 0 10-8 0 4 4 0 008 0zm0 0v1.5a2.5 2.5 0 005 0V12a9 9 0 10-9 9m4.5-1.206a8.959 8.959 0 01-4.5 1.207"</svg>';
	
		//  someone somehow clicks a verify email link, but the user is already verified and logged in-- can ignore with an already verified message.
		if (rc.userSession.isEmailVerified) {
			rc.title = "Email Already Verified";         
			rc.instruction = 'This email has already been verified. You can manage your account by visiting <a href="/myprofile">My Account</a>.';         
		}	
		// session is still active from a recent registration.	
		else if (structKeyExists(session, 'verifyemail')) {
			rc.allowResend= true;
			
			// user clicked on resend link while session still active from a registration
			if (rc.resendLink) {
				// generate a new hash and send it; make sure old one is removed or replaced
				rc.result =variables.userService.resendLink(session.verifyemail);
				
			}
			
			// trying to register again with an email that has been put into verify mode, but was never done
			if (structKeyExists(rc, 'nv')) {
					rc.title = "Email Not Yet Verified" ;
					rc.instruction = "That email address exists but has not been verified. An email was already sent to <strong>#encodeforHTML(session.verifyemail)#</strong> with a link to verify your account. Please click the link in that email.<br>If you did't receive the email, please check your spam folder or request a new link below.";
			}
			// show that the email was sent
			else if (rc.result.success) {
				rc.title = "Verify Email" ;
				rc.instruction = "An email has been sent to <strong>#encodeforHTML(session.verifyemail)#</strong> with a link to verify your account.<br>If you don't receive the email, please check your spam folder or request a new link below.";
			}
		}
	   		variables.framework.setview('register.verifyemail');

   }

	// verify email from link in email. must have token present
	public void function verifyemail(struct rc = {}) {

		// default message
		rc.title = "Hmm, something went wrong with verifying your email address.";         
		rc.instruction = "looks like there is a problem with the link, try logging into <a href='/myprofile'>My Account</a> to send another one.";         
		// assume an error icon
		rc.svg =  '<svg xmlns="http://www.w3.org/2000/svg" class="icon-title" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" /></svg> ';
		// only allow resend if we have an email in session.
		rc.allowResend=false;

		//  someone somehow clicks a verify email link, but the user is already verified and logged in-- can ignore with an already verified message.
		if (rc.userSession.isEmailVerified) {
			rc.title = "Email Already Verified";         
			rc.instruction = 'This email has already been verified. You can manage your account by visiting <a href="/myprofile">My Account</a>.';         
		}
		// meet the requirements of at least having a token
		else if(structKeyExists(rc, 'token') ) {
			
			// we have recieved a token; so attempt authenticate it
			rc.result  = variables.userService.verifyemail(rc.token);	

			if (rc.result.success) {
				// email validated
				rc.result.user.validated = 2;
				variables.userService.setUserSession(rc.result.user);
				rc.title = "Yah! Email Verified";         
				rc.instruction = "You are now logged in! Please feel free to browse our inventory.";  
				rc.svg =  ' <svg xmlns="http://www.w3.org/2000/svg" class="icon-title" style="width:6rem;height:6rem;" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M16 12a4 4 0 10-8 0 4 4 0 008 0zm0 0v1.5a2.5 2.5 0 005 0V12a9 9 0 10-9 9m4.5-1.206a8.959 8.959 0 01-4.5 1.207";</svg> ';
			}		
			else if (structKeyExists(rc.result, "expired")) {
				rc.title = "Verify Link Expired";         
				rc.instruction = "Sorry, that link is not valid anymore. Please click the button below to send a new one.";         
				rc.allowResend=true;
				session.verifyemail = rc.result.email;
				
			}	
			else if (structKeyExists(rc.result, "alreadyVerified")) {
				rc.title = "Email Already Verified";         
				rc.instruction = 'This email has already been verified. You can manage your account by visiting <a href="/myprofile">My Account</a>.';         
			} 	

		} 
		
		// if (!len(rc.title)) {
		// 	rc.title = "Hmm, something went wrong with verifying your email address.";         
		// 	rc.instruction = "looks like there is a problem with the link, try logging into <a href='/myprofile'>My Account</a> to send another one.";         
		// }        

		// if(!structKeyExists(rc, 'token') )
		// 	variables.framework.redirectCustomURL( "/register" );
			
		// validate token; result.success is true or false;if true then we get a user packet to pass to setting up a new session
		// rc.result  = variables.userService.verifyemail(rc.token);	
		// already verified, just redirect them to their profile where it shows them the email is already verified
		// if(structKeyExists(rc.result, 'alreadyVerified')) {
		// 	variables.framework.redirectCustomURL( "/myprofile" );
		// }
		// if(structKeyExists(rc.result, 'expired')) {
		// 	variables.framework.redirectCustomURL( "/myprofile" );
		// }
		// if (rc.result.success) {
			
		// 	rc.result.user.validated = 2;
		// 	variables.userService.setUserSession(rc.result.user);
		// }
		

	}

	// resend email link
	public void function resendLink(struct rc = {}) {
		rc.resendLink = true;
		this.verify_email(rc);
	
	}



	
}