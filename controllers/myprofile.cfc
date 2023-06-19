component accessors=true extends="controllers.base.common" {
    
	property usergateway;
	property config;

	/************************************
	 GET METHODS
	*************************************/

	/************************************
	 myProfile Default (GET)
	 update contact,set password,
	 my address forms
	*************************************/
	public void function default(struct rc = {}) {
		// populate the update contact info form
		rc.user = usergateway.getContactInfo(rc.userSession.pno);

	}

 	/******************************
	 forgotpassword (GET)
	 clicked forgot password link
	*******************************/
	public void function forgotpassword(struct rc = {}) {
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
				//suppress detailed reason for error and just set status to generalize reason
				rc.fpstatus = fp.getErrors() eq 'passwordLinkExpired' ? fp.getErrors() : 'passwordNotReset';
				
				renderResult(rc, '/forgotpassword', 'fpstatus' ) ;

			// no errors	
			} else {
				// allow showing of pwd boxes which uses ajax to process form,
				structAppend(rc,config.getContent('setpassword', 'default'));
				rc.svg = config.getValidSVGICon('forgotpassword', 'default');
				rc.fpstatus = 'default';
			}
			//var result  = variables.userService.verifyPwdReset(rc.token);	

		} else {
			renderResult(rc, '/forgotpassword', 'fpstatus' ) ;
		}
		

	}
	
	/*************************************************
	 submitresetpassword (get)
	 final success screen after changing password
	 has a view -> 
	**************************************************/
	public void function passwordReset(struct rc = {}) {
		
		var status = config.getContent('setpassword', 'passwordReset');
		rc.title = status.title; 
		rc.instruction = status.instruction;
		rc.svg = config.getValidSVGICon('resetpassword', 'default')

	}

	/*******************************
	 POST METHODS
	*******************************/

	/******************************
	 submitforgotpassword (POST)
	 sends email if account exists
	 redirects to forgotpassword
	 ajax: no
	******************************/
	public void function submitforgotpassword(struct rc = {}) {
		param name="rc.email" default="";
		rc.fpstatus='fail';

		// captcha
		if(len(rc.response.errors)) { 
			rc.fpstatus = rc.response.errors;	
		} else {
			
			//validate form by loading into bean
			var forgotpassword = validateform(rc, 'forgotpasswordbean');
			
			// bean validation error
			if(len(rc.response.errors)) 
				rc.fpstatus = rc.response.errors;	
		    else 
			// set appropriate message for lookup based on result of creating the fp link
			rc.fpstatus = forgotpassword.generateLink() ? 'linkCreated' : 'linkNotCreated';
		}	
	
		renderResult(rc, '/forgotpassword', 'fpstatus' ) ;
		
	 }	
	

	/*************************************
	 submitresetpassword (POST)
	 submits pwd1 and pwd2 for updating 
	 changing new password
	 ajax : yes
	******************************************/
	public void function submitResetPassword(struct rc = {}) {
		param name="rc.pwd1" default="";
		param name="rc.pwd2" default="";
		param name="rc.token" default="";
		
			//validate form submit portion by loading into bean
			var pm = validateform(rc, 'passwordmgrbean');
		
			// revalidate the token to make sure nothing has changed 
			// this includes decomposing it
			var fp = variables.beanFactory.getBean( 'forgotpasswordbean' );
			fp.setResetToken(rc.token);

			// check that token is valid
			if (!fp.verifyToken()) {
				rc["response"]["errors"] = config.getContent('forgotpassword', fp.getErrors())
				sendErrorEmail(rc);

			// no errors, move on to updating the password	
			} else {

				pm.setEmail(fp.getemail());
				pm.resetPassword();
				// update the security hashes to say we are done.
				fp.markPasswordVerified();
				if (pm.hasErrors()) 
					rc["response"]["errors"] = pm.getErrors();
				else if(fp.hasErrors())
					rc["response"]["errors"] = fp.getErrors();
				// no errors	
				else {
					rc["response"]["res"] = true;
					// we are in an ajax handler; js payload response contains a redirect; JS uses that to relocate
					rc["response"]["payload"]["redirect"] = '/passwordReset';
				}

			}

			renderResult(rc);
	 }	

	 
	/***********************************************
		updateContactInfo (POST)
		my account update contact information
		ajax :yes
	**********************************************/
	public void function updateContactInfo(struct rc = {}) {

		var cb = validateform(rc, 'contactInfobean');
		cb.update();

		if(cb.hasErrors()) {
			var e = cb.getErrors();
			rc["response"]["errors"] = e.message;
			rc["response"]["errorcode"] = e.errorcode;
			request.exception = e;
			sendErrorEmail(rc);
		} else {
			rc["response"]["res"] = true;
		}

		renderResult(rc);
	
   }
	/***********************************************
		changepassword (POST)
		my account change password
		ajax :yes
	**********************************************/
	public void function changepassword(struct rc = {}) {

		var pm = validateform(rc, 'passwordmgrbean');
		pm.changePassword();

		if(pm.hasErrors()) {
			rc["response"]["errors"] = pm.getErrors();
		} else {
			rc["response"]["res"] = true;
		}

		renderResult(rc);
	
   }
		

}

	