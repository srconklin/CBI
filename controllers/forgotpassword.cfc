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
				rc.fpstatus  = handleServerError(fp.getErrorContext());
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
					handleServerError(forgotpassword.getErrorContext());
					rc.fpstatus='linknotcreated'
				}
			} 

		}	
		// go back to forgotpassword page
		renderResult(rc, '/forgotpassword', 'fpstatus' ) ;
		
	 }	
	

	/*************************************
	 submitresetpassword (POST)
	 submits from pwd1 and pwd2 wdiget to 
	 changing new password
	 ajax : yes
	******************************************/
	public void function submitResetPassword(struct rc = {}) {
		param name="rc.pwd1" default="";
		param name="rc.pwd2" default="";
		// hidden form field
		param name="rc.token" default="";
		
			//validate form submit portion by loading into bean
			var pm = validateform(rc, 'passwordmgrbean');
		
			// revalidate the token to make sure nothing has changed 
			// this includes decomposing it
			var fp = variables.beanFactory.getBean( 'forgotpasswordbean' );
			fp.setResetToken(rc.token);

			// check that token is valid
			// note fp.verify token returns a slug over a message
			if (!fp.verifyToken()) {
				// sets rc["response"]["errors"] to something
				handleServerError(fp.getErrorContext());
				
			// no errors, move on to updating the password	
			} else {

				pm.setEmail(fp.getemail());

				//try to reset/update the password
				pm.resetPassword();
				
				if (pm.hasErrors()) 
					// can be a cf exception on the update statement or emailnotfound
					handleServerError(pm.getErrorContext());
				
				else {

					// update the security hashes to say we are done.
					fp.markPasswordVerified();

					if(fp.hasErrors()) {
						handleServerError(fp.getErrorContext());
					}
					// no errors	
					else {
						rc["response"]["res"] = true;
						// we are in an ajax handler; js payload response contains a redirect; JS uses that to relocate
						rc["response"]["payload"]["redirect"] = '/passwordReset';
					}
	
				}
				

			}

			renderResult(rc);
	 }	

	
  
}

	