component accessors=true extends="controllers.base.common" {
    
	property usergateway;
	property config;

	/***********************************
	 GET METHODS
	************************************/

 	/******************************
	 forgotpassword (GET)
	 clicked forgot password link
	 shows a form w/ email box
	*******************************/
	public void function default(struct rc = {}) {
		param name="rc.fpstatus" default="forgotpassword";
		//var validIconStatuses = 'default,linkCreated';
	
		// on successfully sending the email, don't show the send form; an extra step to prevent misuse.
		rc.allowSend = rc.fpstatus eq 'success' ? false: true;
		
		// fetch the approproiate icon 
	    rc.svg = config.getStatusIcon(rc.fpstatus);

		// set the title and instruction as a function of the current status
		structAppend(rc,config.getContent('forgotpassword', rc.fpstatus));
	
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
				rc.fpstatus  = handleServerError(fp.getErrorContext());
				//redirect
				renderResult('/forgotpassword', 'fpstatus' ) ;

			// no errors	
			} else {
				// allow showing of pwd boxes which uses ajax to process form,
				structAppend(rc, config.getContent('forgotpassword', 'resetPassword'));
    			// fetch the approproiate icon 
				rc.svg = config.getStatusIcon('resetPassword');
				variables.fw.setview('forgotpassword.resetpassword')
			}

		} else {
			//redirect
			renderResult('/forgotpassword', 'fpstatus' ) ;
		}

	}
	
	/*************************************************
	 passwordResetComplete (get)
	 final success screen after changing password
	 has a view -> passwordResetComplete
	**************************************************/
	public void function passwordResetComplete(struct rc = {}) {
		if (structkeyExists(rc.userSession, 'pwdSuccessfullySet')) {
			structAppend(rc, config.getContent('forgotPassword', 'passwordSuccessfulyReset'));
			// fetch the approproiate icon 
			rc.svg = config.getStatusIcon('passwordSuccessfulyReset');
			variables.userService.logout();
			
		} else {
			structAppend(rc, config.getContent('forgotPassword', 'passwordResetError'));
			// fetch the approproiate icon 
			rc.svg = config.getStatusIcon('passwordResetError');
		}
		

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
		rc.fpstatus='passwordlinkCreated';

		// captcha
		if(len(rc.response.errors)) { 
			rc.fpstatus = rc.response.errors;	
		} else {
			
			//validate form by loading into bean
			// non ajax bean validation
			var forgotpassword = validateform('forgotpasswordbean');
			
			// bean validation error
			if(len(rc.response.errors)) 
				rc.fpstatus = rc.response.errors;	
			
			else {

				// try to generate a link to send via email	
				forgotpassword.generateLink();

				if (forgotpassword.hasErrors()) {
					handleServerError(forgotpassword.getErrorContext());
					rc.fpstatus='passwordlinknotcreated'
				}
			} 

		}	
		// go back to forgotpassword page
		renderResult('/forgotpassword', 'fpstatus' ) ;
		
	 }	
	

	/*************************************
	 submitresetpassword (POST)
	 submits form pwd1 and pwd2 widget to 
	 reset password
	 ajax : yes
	******************************************/
	public void function submitResetPassword(struct rc = {}) {
		param name="rc.pwd1" default="";
		param name="rc.pwd2" default="";
		// hidden form field
		param name="rc.token" default="";
		// flag to control program flow
		var hasErrors = false;

		// xtra bot protection;
		captchaProtect();	
		
		//validate form submit portion by loading into bean
		var pm = validateform('passwordmgrbean');
		// use forgotpasswordbean for logic
		var fp = variables.beanFactory.getBean( 'forgotpasswordbean' );

		// revalidate the token to make sure nothing has changed 
		fp.setResetToken(rc.token);

 		// note fp.verify token returns a slug over a message
		 if (!fp.verifyToken()) {
			handleServerError(fp.getErrorContext());
			hasErrors = true;

		//token ok move onto password manager	
        } else 
			pm.setEmail(fp.getemail());
				
			
		// no errors, move on to: step 1 Reseting the password	
		if (!hasErrors) {
			//try to reset/update the password
			pm.resetPassword();
			if (pm.hasErrors()) {
				// can be a cf exception on the update statement or emailnotfound
				handleServerError(pm.getErrorContext());
				hasErrors = true;
		   } 

		}

		// no errors, move on to step 2 updating hashes
		if (!hasErrors) {
			// update the security hashes to say we are done.
			fp.markPasswordVerified();

			if(fp.hasErrors()) {
				handleServerError(fp.getErrorContext());
				hasErrors = true;
			}
		} 
				

		// no errors, then move to step 3 reporting back and redirects
		if (!hasErrors) {
			variables.userService.setUserSession({'pwdSuccessfullySet': true});
			rc["response"]["res"] = true;
			rc["response"]["payload"]["redirect"] = '/passwordresetcomplete';

			// // we are in an ajax handler; js payload response contains a redirect; JS uses that to relocate
			// // CPS =  Executing a Complete Profile Process, then send back to completeprofile via setpassword route
			// // with the hasPassword flag set to true
			// if (structKeyExists(rc, 'eacpp'))  {
			// 	//variables.userService.setUserSession({'pwdVerified': 1});
			// 	updateUserSession({'pwdVerified': 1});
			// 	rc["response"]["payload"]["redirect"] = '/setpassword';
			// }
			// else 

		}

		renderResult();
			
	 }	
  
}

	