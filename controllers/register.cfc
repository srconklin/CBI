component accessors=true extends="controllers.base.common" {

	// property framework;
    // property userService;
	// property config;

	/************************************
	 GET METHODS
	*************************************/


	/******************************
	 register (GET)
	 sign up page
	******************************/
	public void function default(struct rc = {}) {
		rc.showregister= true;
		if (rc.userService.isloggedIn) {
			// flexible config switch to have login and register forms side by side on same page
			
			renderResult(rc, '/myprofile');
		}

	}

	/************************************************************
	verify_email (get)
	show instructions page to verify email; redirected here from 
	a first time registration.
	NOTE: session.verifyemail contains the email to be verified
	shares the view from verifyemail - route for when email link 
	is clicked
	*************************************************************/
	public void function verify_email(struct rc = {}) {
	
		param name="rc.resendLink" default="false";
		param name="rc.status" default="default";
		var status = 'default';
		rc.result.success = true;
		// only allow resend if we have an email in session.
		rc.allowResend=false;
		rc.svg = '<svg xmlns="http://www.w3.org/2000/svg" class="icon-title" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M16 12a4 4 0 10-8 0 4 4 0 008 0zm0 0v1.5a2.5 2.5 0 005 0V12a9 9 0 10-9 9m4.5-1.206a8.959 8.959 0 01-4.5 1.207"</svg>';
		
		// rc.status could be something other than default, if so, then let it flow through to
		// show error content
		if (rc.status eq 'default') {
		
			// someone, somehow clicks a verify email link, but the user is already verified 
			// and logged in-- can ignore with an already verified message.
			if (rc.userSession.isEmailVerified) 
				status = 'emailAlreadyVerified';
				
			// session is still active from a recent registration.	
			else if (structKeyExists(session, 'verifyemail')) {
				rc.allowResend= true;
				
				// user clicked on resend link while session still active from a registration
				if (rc.resendLink)
					// generate a new hash and send it; make sure old one is removed or replaced
					rc.result =variables.userService.resendLink(session.verifyemail);
				
				// trying to register again with an email that has been put into verify mode, but was never done
				if (structKeyExists(rc, 'nv')) 
					status ='notVerified';

				// show that the email was sent
				else if (rc.result.success) {
					status ='successfullySent';
				}
			}
		}

		// get content 
		status = config.getContent('register', status);
		rc.title = status.title;
		rc.instruction = replacenocase(status.instruction, '[EMAIL]', encodeforHTML(session.verifyemail));

		// special view
		variables.fw.setview('register.verifyemail');

   }

	/************************************************************
	 verifyemail (get)
	 verify email from link in email. must have token present
	************************************************************/
	public void function verifyemail(struct rc = {}) {
		
		var status = "defaultverify";
		// assume an error icon
		// only allow resend if we have an email in session.
		rc.allowResend=false;

		//  someone somehow clicks a verify email link, but the user is already verified and logged in-- can ignore with an already verified message.
		if (rc.userSession.isEmailVerified) 
			status = 'emailAlreadyVerified';
			
		// meet the requirements of at least having a token
		else if(structKeyExists(rc, 'token') ) {
			
			// we have recieved a token; so attempt to authenticate it
			rc.result  = variables.userService.verifyemail(rc.token);	
			
			// Success! email validated
			if (rc.result.success) {
				rc.result.user.validated = 2;
				variables.userService.setUserSession(rc.result.user);
				status ='successfullyVerified';
			}		
			// link expired
			else if (structKeyExists(rc.result, "expired")) {
				status ='expired';
				// in the case of expired links do we allow a do-over
				rc.allowResend=true;
				session.verifyemail = rc.result.email;
				
			}	
			// already verified
			else if (structKeyExists(rc.result, "alreadyVerified")) {
				status ='emailAlreadyVerified';
			} 	

		} 

		// get content 
		rc.svg =config.getValidSVGICon('forgotpassword', status)
		status = config.getContent('register', status);
		rc.title = status.title;
		rc.instruction = status.instruction;

	}
	/******************************
	 register (POST)
	 sbumit a new registration 
	 ajax :yes
	******************************/
	public void function register(struct rc = {}) {
		param name="rc.agreetandc" default="0";

		   /*
			  validate form by loading into bean.
			  note:  if ajax is in use on form submit and it errors
			  then error is rendered and controller aborted	in common.before()
			*/
			// register form consists of personal fields + password mgmt widget
			validateform(rc, 'registerbean');
			validateform(rc, 'passwordmgrbean');
			makeLegacyCall(rc, "procreg2",  variables.baseVars);

			//if errors from legacy system
			if(len(rc.response.errors)) {
			
					// email exists but not verified from previous send.
					// not considering this an error; leave res=true and redirect to verify screen with message
					if (rc.response.errorcode eq 'emailinuse_nv') {
						rc["response"]["res"] = true;
						rc["response"]["payload"]["redirect"] = '/verify_email/nv/1';
					}	
					
			
			} else {

				// out of security concerns use a session variable to perists the email while relocating
				// back to the verify_email screen.  
				// NOTE: this is a JS ajax form submit; so redirect using fw not possible
				
				session.verifyemail = rc.email;
				rc["response"]["payload"]["redirect"] = '/verify_email';
				rc["response"]["payload"]["firstname"] = rc.firstname;

			}

			renderResult(rc);
		
	}

	
	/************************************************************
	resendLink (post)
	resend email link
	ajax:no
	************************************************************/
	public void function resendLink(struct rc = {}) {
		rc.resendLink = true;

		// captcha
		if(len(rc.response.errors)) 
			rc.status = rc.response.errors;	
			
		this.verify_email(rc);
	
	}
	
}