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
			renderResult('/myprofile');
		}
	}
	

	/************************************************************
	completeprofile (get/post)
	a proxy to orchestrate verifying email/setting a password
	for users getting auto registered by making an offer in dealmaking
	or registering using the register form

	1) redirected here from a first time registration with directions to check mail

	2) or from a link with a token from having clicked the email 

	3) or from a re-registration attempt where the email exists but 
	was	never verified)

	4) OR from a first time user placing an offer/inquiry who 
	is partially registered/auto logged in.  We are trying to 
	get them to verify their email and set a password.

	5) or user has clicked the resend email link

	ajax:no
	************************************************************/
	public void function completeprofile(struct rc = {}) {
		//default is to error
		var status = 'defaultCP'; 
		var resendLink = false;
		var view = 'register.completeprofile';
		rc.sessionEmail ='';
		rc.allowResend = true;
		rc.svg = '<svg xmlns="http://www.w3.org/2000/svg" class="icon-title" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M16 12a4 4 0 10-8 0 4 4 0 008 0zm0 0v1.5a2.5 2.5 0 005 0V12a9 9 0 10-9 9m4.5-1.206a8.959 8.959 0 01-4.5 1.207"</svg>';
		
		//all of these operations require that the session contains an email of the registrant
		if (structKeyExists(session, 'verifyemail') and len(session.verifyemail)) 
	    	rc.sessionEmail = session.verifyemail;

		/***********************************************************
		no email in session (usersession or verifyemail)
		and exclude fully logged in users from using this.
		************************************************************/
		if (!len(rc.sessionEmail)) {
			status = 'defaultCP'
		
		/***********************************************************
		 if we have a token, then user is clicking the
		 link in the email that was sent to them 
		************************************************************/
	    } else if (structKeyExists(rc, 'token') ) {

			//already verfified then bail
			if (rc.userSession.isEmailVerified) 
				status = 'emailAlreadyVerified';
			else 
				status = this.verifyEmail(rc);
				
			// no password / validate=1 then show progressbar, show next password
			if(!rc.userSession.hasPassword) {
				rc.pb = variables.fw.view( 'common/fragment/progressbar', {active =1})
				
				// next step is to set a password if verification of email is done
				if (status eq 'successfullyVerified' or status eq 'emailAlreadyVerified') {
					rc.gotoSetPassword = true;

					//swap messaging for successfullyVerified to the ones that reference password requests
					if (status eq 'successfullyVerified')
						status = 'successfullyVerifiedButNeedPassword';
					else if (status eq 'emailAlreadyVerified')
						status = 'emailAlreadyVerifiedButNeedPassword';	
				}
			} 
			// if password already verified then we are done with the process 
			else 
				structDelete(session, 'verifyemail');
					
			//different icon based on status
			rc.svg =config.getValidSVGICon('verifyemail', status)
		
		/****************************************** 
		re-registration attempt
		email exists but not yet verified
		******************************************/
		} else if (structKeyExists(rc, 'notVerified') ) {
			status = 'notVerified'

		/****************************************** 
		resendlink
		user is clicking link to resend the email
		******************************************/
		} else if (structKeyExists(rc, 'resendlink') ) {
			// actual resendlink
			resendLink= true;
			if (rc.userSession.isEmailVerified) 
				status = 'emailAlreadyVerified';
			else 	
				status = this.resendLink(rc);
			
		/***************************************************************** 
		1) user created from a registration submission
		(validated = 0 , hasaPassword)
		OR 
		2) created/found from a deal offer (validated = 1 partially logged in)
	    either verify their email or set a password or both
		****************************************************************/
		} else if (!rc.userSession.isEmailVerified ) {
		
			 // auto logged in user from dealmaking (tip: they have no password )
			 // verify email followed by set password in a 2 step process
			 if(rc.userSession.validated eq 1) {
				 rc.pb = variables.fw.view( 'common/fragment/progressbar', {active =1});
				 // create a verify link/email  if ok will send back successfullySent
				 status = this.resendLink(rc);
					
			 // new registration 
			 } else 
				status ='successfullySent';	
			 
		
		/***********************************************************
		 if we have a ptoken , then user is clicking the
		 link in the email that was sent to them to reverify email 
		 ownership. if ok then show the password manager
		************************************************************/
		} else if (structKeyExists(rc, 'ptoken') ) {
			rc.eacpp = true;
			status = 'showSetPassword';
			
			rc.pb = variables.fw.view( 'common/fragment/progressbar', {active =2})

			// trying to verify a password before the email is verifed (can't really happen?)
			if (!rc.userSession.isEmailVerified)
				status = 'passwordVerificationOutofOrder';
			//already verfified then bail
			else if (rc.userSession.hasPassword) 
				status = 'passwordAlreadyVerified';
			else 
				status = this.verifyEmailForPwd(rc);
		
			// email authenticated show the password manager
			if (status eq 'passwordsuccessfullyVerified' or status eq 'passwordAlreadyVerified') 
				rc.showPasswordMgr = true;
					
			//different icon based on status
			rc.svg =config.getValidSVGICon('verifyemail', status)


		/***************************************************************** 
		 set password with password manager
		 (may ask to revalidate email if too much time has passed)
		****************************************************************/
		} else if (!rc.userSession.hasPassword ) {
			// default is to show set password screen
			status = 'showSetPassword';
			rc.pb = variables.fw.view( 'common/fragment/progressbar', {active =2});

			// if user was identified as having previously verified email from a different session
			// then we must ask them to revalidate their ownership of the email. send link
			if(structKeyExists(rc.userSession, 'previouslyVerified') and rc.userSession.previouslyVerified) 
				//send verification link to validate they own the mail address
				// create a verify link/email  if ok will send back successfullySent
				status = this.sendPasswordlink(rc);
			// same session validation of email; show the password manager
			// no token in this case; we allow the password set to go through unabated 
			else {
				rc.eacpp = true;
				rc.showPasswordMgr = true;	
			}
			
		/*************************************************************** 
		  complete profile is now done. show login link
		****************************************************************/
		} else if (rc.userSession.hasPassword)  {
			// set the regstat to 1; user is fully validated and can now login and 
			// see their profile
			 // mark email as verified
			 var register = variables.beanFactory.getBean( 'registerbean' );
			 register.setEmail(rc.sessionEmail);
	 
			 //  if token is invalid; handle error
			 if (!register.markUserFullyValidated()) 
				status = handleServerError(register.getErrorContext());
			 else {
				// bean to load up a proper user config
				var user = variables.beanFactory.getBean( 'userbean' );
				// log the user in (creates shortcuts avatar etc)
				//user.autoLoginUser(register.getUserData());
				// put into user session
				//variables.userService.setUserSession(user.getUserData());

				rc.pb = variables.fw.view( 'common/fragment/progressbar', {active =3});
				status ='completeProfileDone';	
				// logout and kill utility session variables
				variables.userService.logout();
				
			 }
		
		} 
	
		/****************************************** 
		compile the content to display in view
		******************************************/
		if(listFindNoCase('defaultCP,successfullyVerified,emailAlreadyVerified,successfullyVerifiedButNeedPassword,emailAlreadyVerifiedButNeedPassword,completeProfileDone', status))
			rc.allowResend = false;

		var content = config.getContent('register', status);
		rc.title = content.title;
		
		// allowresened = email in session = customize to user name and email
		if (rc.allowResend) {
			rc.instruction = replacenocase(content.instruction, '[EMAIL]', encodeforHTML(rc.sessionEmail));
			rc.instruction = replacenocase(rc.instruction, '[TRIES]', resendLink ? 'resent' : 'sent');
		} else {
			rc.instruction = content.instruction;
		}
	
		// configure output to show status
		//this.compileContent(rc);
		variables.fw.setview('register.completeprofile');

			
	}

	/******************************
	 register (POST)
	 submit a new registration 
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

			// xtra bot protection
			captchaProtect();	

			// register form consists of personal fields + password mgmt widget
			var pm = validateform('passwordmgrbean');
			var register = validateform('registerbean');

			//register requires a passwordmgr bean
			register.setPM(pm);
			register.setRoute('verify');
			
			// register the user
			register.signup();
			
			//if errors from legacy system
			if(register.hasErrors()) {
			
				// get an error context to pass to handleServerError
				var err = register.getErrorContext();
			
				
				// email exists but not verified from previous send; go to different screen.
				if(err.originalStatus eq 'emailinuse_nv') {
					session.verifyemail = rc.email;
					rc["response"]["payload"]["firstname"] = rc.firstname;
					rc["response"]["payload"]["redirect"] = '/completeprofile/notVerified';
				} else 
					// parse error
					handleServerError(err);

			} else {	
				//update that the the pwd has been verified
				variables.userService.updateUserStateFromDb(email=register.getEmail(), state={'pwdVerified' : true})

				// out of security concerns use a session variable to persist the email while relocating
				// NOTE: this is a JS ajax form submit; so redirect using fw not possible
				session.verifyemail = rc.email;
				rc["response"]["res"] = true;
				rc["response"]["payload"]["firstname"] = rc.firstname;
				rc["response"]["payload"]["redirect"] = '/completeprofile';
			}
			
			renderResult();
		
	}


	/******************************
	 * Private
	******************************/

	/************************************************************
	resendLink 
	resend email link to verify an email.
	email is needed. expect rc.sessionEmail to be set
	************************************************************/
	private string function resendLink(struct rc = {}) {
		var status ='';
			    if (!len(rc.sessionEmail)) 
					return 'default';
				// generate a new hash and send it; make sure old one is removed or replaced
				var register = variables.beanFactory.getBean( 'registerbean' );
				register.setEmail(rc.sessionEmail);
				register.setRoute('verify');
				register.resendlink();
				
				if (register.hasErrors()) 
					status = handleServerError(register.getErrorContext());
			 	else 
			 		status ='successfullySent';
		
		return status;
	
	}

	/************************************************************
	sendPasswordlink 
	send email to verify email ownership so password can be set
	email is needed so we expect rc.sessionEmail to be set
	************************************************************/
	private string function sendPasswordlink(struct rc = {}) {
		var status ='';
			    if (!len(rc.sessionEmail)) 
					return 'default';
				// generate a new hash and send it; make sure old one is removed or replaced
				var forgotpassword = variables.beanFactory.getBean( 'forgotpasswordbean' );
				forgotpassword.setEmail(rc.sessionEmail);
				forgotpassword.setRoute('passwordverify');
				forgotpassword.generateLink();
				
				if (forgotpassword.hasErrors()) 
					status = handleServerError(forgotpassword.getErrorContext());
					status='verifylinknotcreated'
			 	else 
			 		status ='passwordEmailsuccessfullySent';
		
		return status;
	
	}


	/************************************************************
	 verifyEmail 
	 user receives an email with an encoded link
	 to confirm their email address
	 TOKEN REQUIRED - rc.token

	************************************************************/
	private string function verifyEmail(struct rc = {}) {
	
		var status = "defaultverify";
					
		var register = variables.beanFactory.getBean( 'registerbean' );
		register.setVerifyToken(rc.token);

		//  if token is invalid; handle error
		if (!register.verifyToken()) {

			// handle server error
			status = handleServerError(register.getErrorContext());

			// in the case of expired links give them chance to resend
			if (status eq 'verifyLinkExpired') {
				session.verifyemail = register.getEmail();
			}
			
		// yeah! token is valid so we are authenticated
		}  else {
			variables.userService.updateUserStateFromDb(email=register.getEmail(), state={'verifyVerified' : 1})
			status ='successfullyVerified';
		}
			
		return status
	}

	/************************************************************
	 verifyEmailForPwd 
	 user receives an email with an encoded link
	 to confirm their email address when attempt to set their 
	 password
	 TOKEN REQUIRED - rc.token

	************************************************************/
	private string function verifyEmailForPwd(struct rc = {}) {
	
		var status = "defaultverify";

		var fp = variables.beanFactory.getBean( 'forgotpasswordbean' );
		fp.setResetToken(rc.ptoken);

		// check that token is valid
		if (!fp.verifyToken()) {
			//error
			status  = handleServerError(fp.getErrorContext());
		
		// no errors; pwd token is valid	
		} else {
			status ='PasswordSuccessfullyVerified';
		}

			
		return status;
	}

	
	
}