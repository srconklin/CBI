component accessors=true extends="controllers.base.common" {
    
	property usergateway;
	property config;

	/***********************************
	 GET METHODS
	************************************/

 	/******************************
	 forgotpassword (GET)
	 clicked forgot password link
	 where one can enter their email address
	*******************************/
	public void function default(struct rc = {}) {
		param name="rc.fpstatus" default="default";
		//var validIconStatuses = 'default,linkCreated';
	
		// on successfully sending the email, don't show the send form; an extra step to prevent misuse.
		rc.allowSend = rc.fpstatus eq 'success' ? false: true;
		
		// set the title and instruction as a function of the current status
		structAppend(rc,config.getContent('forgotpassword', rc.fpstatus));
	
		rc.svg = config.getValidSVGIcon('forgotpassword', rc.fpstatus)
		
	 }	

	 /***************************************
	 resetPassword (GET)
	 shown after user clinks reset link	 
	 must have token present
	 has a view -> password manager widget
	 ajax : no
	****************************************/
	public void function resetpassword(struct rc = {}) {
		param name="rc.fpstatus" default="passwordNotReset";
		param name="rc.token" default="";

		//validate the token
		if(len(rc.token)) {
		
			var fp = variables.beanFactory.getBean( 'forgotpasswordbean' );
			fp.setResetToken(rc.token);

			// check that token is valid
			if (!fp.verifyToken()) {
				//error
				rc.fpstatus  = handleServerError(rc, fp.getErrorContext());
				//redirect
				renderResult(rc, '/forgotpassword', 'fpstatus' ) ;

			// no errors	
			} else {
				// allow showing of pwd boxes which uses ajax to process form,
				structAppend(rc, config.getContent('forgotpassword', 'resetPassword'));
				rc.svg = config.getValidSVGICon('forgotpassword', 'default');
				rc.fpstatus = 'default';
				// view invoked here where password widget is displayed
			}

		} else {
			//redirect
			renderResult(rc, '/forgotpassword', 'fpstatus' ) ;
		}
		

	}
	
	/*************************************************
	 submitresetpassword (get)
	 final success screen after changing password
	 has a view -> passwordReset
	**************************************************/
	public void function passwordReset(struct rc = {}) {
		
		structAppend(rc, config.getContent('forgotPassword', 'passwordSuccessfulyReset'));
		rc.svg = config.getValidSVGICon('forgotPassword', 'default')

	}

	/*******************************
	 POST METHODS
	*******************************/

	/******************************
	 submitforgotpassword (POST)
	 sends email if account exists
	 redirects to default handler
	 ajax: no
	******************************/
	public void function submitforgotpassword(struct rc = {}) {
		param name="rc.email" default="";
		rc.fpstatus='linkCreated';

		// captcha
		if(len(rc.response.errors)) { 
			rc.fpstatus = rc.response.errors;	
		} else {
			
			//validate form by loading into bean
			// non ajax bean validation
			var forgotpassword = validateform(rc, 'forgotpasswordbean');
			
			// bean validation error
			if(len(rc.response.errors)) 
				rc.fpstatus = rc.response.errors;	
			
			else {

				// try to generate a link to send via email	
				forgotpassword.generateLink();

				if (forgotpassword.hasErrors()) {
					handleServerError(rc, forgotpassword.getErrorContext());
					rc.fpstatus='linknotcreated'
				}
			} 

		}	
		//writedump(var="#rc.fpstatus#",  abort="true");
		// go back to forgotpassword page
		renderResult(rc, '/forgotpassword', 'fpstatus' ) ;
		
	 }	
	

	/*************************************
	 submitresetpassword (POST)
	 submits from pwd1 and pwd2 widget to 
	 changing new password
	 ajax : yes
	******************************************/
	public void function submitResetPassword(struct rc = {}) {
		param name="rc.pwd1" default="";
		param name="rc.pwd2" default="";
		// hidden form field
		param name="rc.token" default="";
		var noErrors = true;

		// xtra bot protection
		captchaProtect(rc);	
		
		//validate form submit portion by loading into bean
		var pm = validateform(rc, 'passwordmgrbean');
		// use forgotpasswordbean for logic
		var fp = variables.beanFactory.getBean( 'forgotpasswordbean' );

		// conditions by which token validation is skipped:  when Executing a Complete Profile Process
		// and the user already validated their email in step 1 of the process.
		var performVerifyToken = true;
		if(structKeyExists(rc.userSession, 'previouslyVerified')  and !rc.userSession.previouslyVerified and !len(rc.token)) 
			performVerifyToken = false;

		//  if we are NOT skipping token validation	
		if (performVerifyToken) {
			// revalidate the token to make sure nothing has changed 
			// this includes decomposing it
			fp.setResetToken(rc.token);

			// check that token is valid
			// note fp.verify token returns a slug over a message
			 if (!fp.verifyToken()) {
				// sets rc["response"]["errors"] to something
				handleServerError(rc, fp.getErrorContext());
				noErrors = false;

			 } else 
				//email retrieved from token
				pm.setEmail(fp.getemail());
				
		} else {
			pm.setEmail(rc.userSession.email);
			fp.setEmail(rc.userSession.email);
		}
		
			
		// no errors, move on to: step 1 Reseting the password	
		if (noErrors) {
			//try to reset/update the password
			pm.resetPassword();
			if (pm.hasErrors()) {
				// can be a cf exception on the update statement or emailnotfound
				handleServerError(rc, pm.getErrorContext());
				noErrors = false;
		   } 

		}

		// no errors, move on to step 2 updating hashes
		if (noErrors) {
			// update the security hashes to say we are done.
			fp.markPasswordVerified();

			if(fp.hasErrors()) {
				handleServerError(rc, fp.getErrorContext());
				noErrors = false;
			}
		} 
				

		// no errors, then move to step 2 reporting back and redirects
		if (noErrors) {
			rc["response"]["res"] = true;
			// we are in an ajax handler; js payload response contains a redirect; JS uses that to relocate
			// CPS =  Executing a Complete Profile Process, then send back to completeprofile via setpassword route
			// with the hasPassword flag set to true
			if (structKeyExists(rc, 'eacpp'))  {
				variables.userService.setUserSession({'pwdVerified': 1});
				rc["response"]["payload"]["redirect"] = '/setpassword';
			}
			else 
			   rc["response"]["payload"]["redirect"] = '/passwordReset';

		}

		renderResult(rc);
			
	 }	
  
}

	