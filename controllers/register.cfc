component accessors=true extends="controllers.base.common" {

	/************************************
	 GET METHODS
	*************************************/

	/******************************
	 register (GET)
	 sign up page
	******************************/
	public void function default(struct rc = {}) {
		// flexible config switch to have login and register forms side by side on same page
		rc.showregister= true;
		// is user is logged in; then redirect to profile page
		if (rc.userSession.isloggedIn) {
			renderResult(rc, '/myprofile');
		}
	}

	/************************************************************
	verify_email (get)
	show instructions page to verify email; 
	1) redirected here from a first time registration.
	2) or redirected here from this.resendlink

	NOTE: session.verifyemail contains the email to be verified
	shares the view from verifyemail - route for when email link 
	is clicked
	*************************************************************/
	public void function verify_email(struct rc = {}) {
	
		param name="rc.resendLink" default="false";
		// redirected here with a status to report
		param name="rc.status" default="default";

		var status = rc.status;
		// rc.result.success = true;
		
		// only allow resend if we have an email in session.
		rc.allowResend=false;
		rc.svg = '<svg xmlns="http://www.w3.org/2000/svg" class="icon-title" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M16 12a4 4 0 10-8 0 4 4 0 008 0zm0 0v1.5a2.5 2.5 0 005 0V12a9 9 0 10-9 9m4.5-1.206a8.959 8.959 0 01-4.5 1.207"</svg>';
		
		// rc.status could be something other than default, if so, then let it flow through to
		// show error content
		if (status eq 'default') {
		
			// someone, somehow clicks a verify email link, but the user is already verified 
			// and logged in-- can ignore with an already verified message.
			if (rc.userSession.isEmailVerified) 
				status = 'emailAlreadyVerified';
				
			// session is still active from a recent registration.	
			else if (structKeyExists(session, 'verifyemail') and len(session.verifyemail)) {
				rc.allowResend= true;
				
				// user clicked on resend link while session still active from a registration
				if (rc.resendLink) {
					// generate a new hash and send it; make sure old one is removed or replaced
					var register = variables.beanFactory.getBean( 'registerbean' );
					register.setEmail(session.verifyemail);
					register.resendlink();
					if (register.hasErrors()) {
						var e = register.getErrors();
						request.exception = e;
						sendErrorEmail(rc);
						status = ' verifylinknotcreated';
					} else {
						status ='successfullySent';
					}

					// // trying to register again with an email that has been put into verify mode, but was never done
					// if (structKeyExists(rc, 'nv')) 
					// 	status ='notVerified';

					// // show that the email was sent
					// else if (rc.result.success) {
					// 	status ='successfullySent';
					// }
				}
				else
					status ='successfullySent';
			}	
		}

		// get content 
		status = config.getContent('register', status);
		rc.title = status.title;
		rc.instruction = replacenocase(status.instruction, '[EMAIL]', encodeforHTML(session.verifyemail));
		rc.instruction = replacenocase(rc.instruction, '[TRIES]', rc.resendLink ? 'resent' : 'sent');

		// special view
		variables.fw.setview('register.verifyemail');

   }

	/************************************************************
	 verifyEmail (get)
	 verify email from link in email. must have token present
	************************************************************/
	public void function verifyEmail(struct rc = {}) {
		
		var status = "defaultverify";
		// assume an error icon
		rc.allowResend=false;
		
		//  someone somehow clicks a verify email link, but the user is already verified and logged in-- can ignore with an already verified message.
		if (rc.userSession.isEmailVerified) 
			status = 'emailAlreadyVerified';
			
		// meet the requirements of at least having a token
		else if(structKeyExists(rc, 'token') ) {
		
			var register = variables.beanFactory.getBean( 'registerbean' );
			register.setVerifyToken(rc.token);

			// check that token is valid
			if (!register.verifyToken()) {
				rc.allowResend=true;
				status = register.getErrors();
				// in the case of expired links give them chance to resend
				if (status eq 'verifyLinkExpired') {
					
					session.verifyemail = register.getEmail();
				}	
			}  else {
				// bean to load up a proper user config
				var user = variables.beanFactory.getBean( 'userbean' );
				// log the user in (creates shorcuts avatar etc)
				user.autoLoginUser(register.getUserData());
				// put into user session
                variables.userService.setUserSession(user.getUserData());
				//variables.userService.setUserSession({validated:2});
				status ='successfullyVerified';
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
		param name="rc.bcast" default="0";

		    /*
			  validate form by loading into bean.
			  note:  if ajax is in use on form submit and it errors
			  then error is rendered and controller aborted	in common.before()
			*/

			// register form consists of personal fields + password mgmt widget
			var pm = validateform(rc, 'passwordmgrbean');
			var register = validateform(rc, 'registerbean');

			//register requires a passwordmgr bean
			register.setPM(pm);
			// register the user
			register.signup();

			//if errors from legacy system
			if(register.hasErrors()) {
				var e = register.getErrors();
				rc["response"]["errors"] = e.message;
				rc["response"]["errorcode"] = e.errorcode;
				request.exception = e;
				sendErrorEmail(rc);
					
			// email exists but not verified from previous send; go to different screen.
			} else if(register.emailNotVerified()) {
					// rc["response"]["res"] = true;
					rc["response"]["payload"]["redirect"] = '/verify_email/nv/1';
			} else {		
				// out of security concerns use a session variable to persist the email while relocating
				// NOTE: this is a JS ajax form submit; so redirect using fw not possible
				session.verifyemail = rc.email;
				rc["response"]["res"] = true;
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