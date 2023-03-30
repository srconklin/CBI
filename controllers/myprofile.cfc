component accessors=true extends="controllers.base.common" {
    
	property userService;
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
		 rc.user = userService.getContactInfo(rc.userSession.pno);

	}

 	/******************************
	 forgotpassword (GET)
	 clicked forgot password link
	*****************************/
	public void function forgotpassword(struct rc = {}) {
		 param name="rc.fpstatus" default="default";
		 //var validIconStatuses = 'default,linkCreated';
		 
		 // on successfully sending the email, don't show the send form; an extra step to prevent misuse.
		 rc.allowSend = rc.fpstatus eq 'success' ? false: true;

		var status = config.getContent('forgotpassword', rc.fpstatus);
		// set the title and instruction as a function of the current status
		rc.title= status.title;
		rc.instruction= status.instruction;

		rc.svg = getValidSVGICon('forgotpassword', rc.fpstatus)
		
	 }	


	 /***************************************
	 resetPassword (GET)
	 shown after user clinks reset link	 
	 must have token present
	 has a password and a confirm email box
	****************************************/
	public void function resetpassword(struct rc = {}) {
		param name="rc.fpstatus" default="default";
		param name="rc.token" default="";

		// meet the requirements of at least having a token
		if(!len(rc.token)) {
			rc.fpstatus='passwordNotReset';
			renderResult(rc, '/forgotpassword', 'fpstatus' ) ;
		} 

		//validate the token
		var result  = variables.userService.verifyPwdReset(rc.token);	
		// any errors report and go back to primary view
		if(len(result.errors)) {
			rc.fpstatus = result.errors;	
			renderResult(rc, '/forgotpassword', 'fpstatus' ) ;
		}
		
		// made it this far, allow screen to proceed to show pwd boxes
		var status = config.getContent('setpassword', 'default');
		rc.title = status.title; 
		rc.instruction = status.instruction;
	
		rc.svg = getValidSVGICon('forgotpassword', 'default')

	}
	
	/******************************
	 submitresetpassword (get)
	 final success screen after 
	 changing password
	******************************/
	public void function passwordReset(struct rc = {}) {
		
		var status = config.getContent('setpassword', 'passwordReset');
		rc.title = status.title; 
		rc.instruction = status.instruction;
		rc.svg = getValidSVGICon('resetpassword', 'default')

	}


	/**********************************
	 POST METHODS
	***********************************/

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
			validateform(rc, 'forgotpasswordbean');
			
			//if error on validating then, set return status for redirect
			if(len(rc.response.errors)) {
				rc.fpstatus = rc.response.errors;	
			} else {
				
				// expected variables
				form.email = rc.email;
				// make legacy call to reset forgotten password

				makeLegacyCall(rc, "resetForgottenPwd", variables.baseVars);
				
				// set appropriate message for user to see on screen
				rc.fpstatus = !len(rc.response.errors) ? 'linkCreated' : 'linkNotCreated';
			}	
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
		
			//validate form by loading into bean
			validateform(rc, 'passwordmgrbean');
		
			// extract email from token 
			var email = variables.userService.decomposeToken(rc.token).email;
			var result=variables.userService.updatePassword(email, rc.pwd1);
			if 	(result.success) {
				rc["response"]["res"] = true;
				rc["response"]["payload"]["redirect"] = '/passwordReset';
			} else {
				rc["response"]["errors"] = result.errors;
				sendErrorEmail(rc);
			}
		
		 renderResult(rc);

	 }	

	 
	/***********************************************
		updateContactInfo (POST)
		my account update contact information
		ajax :yes
	**********************************************/
	public void function updateContactInfo(struct rc = {}) {

		validateform(rc, 'contactInfobean');
		makeLegacyCall(rc, "procreg2", variables.baseVars);
		renderResult(rc);
	
   }

		

}

	