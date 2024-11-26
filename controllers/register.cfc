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

	/******************************************************************** 
	 completeAutoReg (get)
     redirected here from dealmaking as an autologged in user.
	 checked to see if they need to verify their email 
	 or continue to set a password
	*********************************************************************/
	public void function completeAutoReg(struct rc = {}) {
		var status = 'completeAutoRegError';

		// email put into rc.userSession.email 
		// and partially logged in from the dealmkaing controller
		  if (len(getSessionEmail()) && rc.userSession.validated eq 1 ) {

					  
			if (!rc.userSession.isEmailVerified)  {
				// progressbar	
				rc.pb = variables.fw.view( 'common/fragment/progressbar', {active=1});	

				if (structKeyExists(rc, 'incompleteUserAccess')) 
					status = 'incompleteUserAccessStep1';
				else 
					// create a verify link/email  if ok will send back -> successfullySent
					status = this.resendLink(getSessionEmail());
				} 
			// next check if the user's password has not been set
			else if (!rc.userSession.hasPassword) {
				// progressbar	
				rc.pb = variables.fw.view( 'common/fragment/progressbar', {active=2});	
				if (structKeyExists(rc, 'incompleteUserAccess')) 
					status = 'incompleteUserAccessStep2';
				else 
					status = 'emailAlreadyVerifiedButNeedPassword';
				
				rc.showPasswordMgr = true;
			}
			else 
				status = 'emailAlreadyVerified';

			
		}
	
		// complile content and display the view 
		this.compileCompleteProfileContent(rc, status, getSessionEmail());
			
		
	}
	
	/******************************************************************** 
	completeRegistration (get)
	displays screen for intsructuions on confirming thier email
    redirected here from registration (POST)
	*********************************************************************/
	public void function completeRegistration(struct rc = {}) {
			var status = '';
			
			// email already verified
			if (rc.userSession.isEmailVerified )  {
				status ='emailAlreadyVerified';	
			
			// must have a registration email in session to move forward
			} else if (len(getSessionEmail())) {
								
					// re-registration attempt; email exists either verified or not
					if (structKeyExists(rc, 'emailinuse')) 
						status = rc.emailinuse;
					else 		
						status ='successfullySent';	
				
			// error or errant call to route	
			} else 
				status = 'completeRegistrationError';
			
		// complile content and display the view 
		this.compileCompleteProfileContent(rc, status, getSessionEmail());
	
	}

	  
	/**
	 * completeSetPassword (get)
	 * redirected from setPassword Post when sumbitting password set in 
	 * while completing a profile (ajax)
	 * 
	 */
	public void function completeSetPassword(rc={}) {
   		 var status = ''; 
	 	
		 // this route protected by a verified email and verified password in session
		 // and the user is not currently fully logged in 
		if (rc.userSession.validated eq 2) {
			status = 'passwordAlreadyVerified';	

		} else if (rc.userSession.isEmailVerified && rc.userSession.hasPassword) {

			 var register = variables.beanFactory.getBean( 'registerbean' );
			 register.setEmail(getSessionEmail());
	 
			 // set the regstat to 1; user is fully validated and can now login and 
			 // see their profile
			 if (!register.markUserFullyValidated()) 
				status = handleServerError(register.getErrorContext());
			 else {

				rc.pb = variables.fw.view( 'common/fragment/progressbar', {active =3});
				status ='profileComplete';	
				// logout and kill utility session variables
			    // variables.userService.logout();
				
			 	}
		} else 
			status = 'passwordResetError';	
				
		// complile content and display the view 
		this.compileCompleteProfileContent(rc, status, getSessionEmail());
		

	}		

/**
 * handleResendLink (get)
 * button clicked to send a new email that contains a verify link (token) which is handled
 * by handleEmailVerification handler
 * 
 */
function handleResendLink(rc={}) {
    var status = '';
	// already verified 
	if (rc.userSession.isEmailVerified) 
		status = 'emailAlreadyVerified';
	// create and send a new link
	else 	
		status = this.resendLink(getSessionEmail());

	// complile content and display the view 
	this.compileCompleteProfileContent(rc, status, getSessionEmail(), true);	
		
}

 /**
 * handleEmailVerification (get)
 * 
 * verifies an email address by recieving an token from a link in an email
 * 
 * @param rc              the request context which should contain a token
 */
function handleEmailVerification(rc = {}) {
    var status = '';
    var processtoken = false;

    // Check if a token is provided
    if (structKeyExists(rc, 'token')) {

        // user not logged in; then use token
        if (rc.userSession.pno eq 0)
            processtoken = true;

        // user is logged in; check if email is already validated and/or password has been set in session scope
        else {

            if (rc.userSession.isEmailVerified && !rc.userSession.hasPassword) 
                status = 'emailAlreadyVerifiedButNeedPassword';
            
            // neither true; then use token
            if (!len(status)) 
                processtoken = true;
        }

        // we need to use token to check user status
        if (processtoken) {

            // Process the token and verify the email
            var register = variables.beanFactory.getBean('registerbean');
            register.setVerifyToken(rc.token);

            // If the token verification fails, handle errors
            if (!register.verifyToken()) {
                // Handle server errors, such as expired links or other verification failures
                // status can : verifyLinkExpired,emailAlreadyVerified,emailAlreadyVerifiedButNeedPassword,
                // emaildidnotverify
                status = handleServerError(register.getErrorContext());

                // If the verification link is expired, save the email for a potential second attempt
                if (status == 'verifyLinkExpired') {
                    updateUserSession({email: register.getEmail()});
                } 
                else if (status == 'emailAlreadyVerified' || status == 'emailAlreadyVerifiedButNeedPassword') 
                    getUserByEmailAndSetSessionWithState(register.getEmail(), {'verifyVerified': 1});
                

            // If token verification is successful, mark the email as verified
            } else {
            
                getUserByEmailAndSetSessionWithState(register.getEmail(), {'verifyVerified': 1});

                // state changed so now check if the user's password has not been set
                if (!rc.userSession.hasPassword) {
                    status = 'successfullyVerifiedButNeedPassword';

                // both email and password validated, the mark the user's profile as completed
                } else {

                    // something went wrong with validating the db.
                    if (!register.markUserFullyValidated()) 
                        status = handleServerError(register.getErrorContext());
                    else 
                        status = 'successfullyVerified';
                }    
            }
        }    

    } else {
        // No token provided, set a general verification error
        status = 'emailverifyError';
    }

    // If password setup is required, set the progress bar and flag to show password manager
    if (status == 'successfullyVerifiedButNeedPassword' 
        || status == 'emailAlreadyVerifiedButNeedPassword') {

        rc.pb = variables.fw.view('common/fragment/progressbar', {active = 2});
        rc.showPasswordMgr = true;
    }

    // Load the appropriate display icon based on status
    //rc.svg = config.getValidSVGIcon('verifyemail', status);
    
    // Compile content and display the view with updated status 
    this.compileCompleteProfileContent(rc, status, getSessionEmail());
}

 /**
 * compileCompleteProfileContent (get)
 * Compiles content for completing the profile registration output for the common view
 * register.completeprofile
 * 
 * @param rc              the requst context
 * @param status          The status slug to look up the message
 * @param sessionEmail    The email address of user the registering (string).
 * @param resendLink      Flag to shape language as a 'send' vs 'resend'
 */
function compileCompleteProfileContent(rc={}, status='', sessionEmail='', resendLink=false) {
    // param rc.svg='<svg xmlns="http://www.w3.org/2000/svg" class="icon-title" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
  	// 				<path stroke-linecap="round" stroke-linejoin="round" d="M16 12a4 4 0 10-8 0 4 4 0 008 0zm0 0v1.5a2.5 2.5 0 005 0V12a9 9 0 10-9 9m4.5-1.206a8.959 8.959 0 01-4.5 1.207z"/>
	// 			 </svg>';
		
	// Check if the status allows/bans use of a resend button
	rc.allowResend = variables.config.isResendAllowed(status);

	// fetch the approproiate icon 
	rc.svg = config.getStatusIcon(status);

    // Fetch content based on the status
    var content = config.getContent('register', status);
    rc.title = content.title;

    rc.instruction = replacenocase(content.instruction, '[EMAIL]', encodeforHTML(sessionEmail));
    rc.instruction = replacenocase(rc.instruction, '[TRIES]', resendLink ? 'resent' : 'sent');

    // Set the view
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
				if(listfindnocase('emailinusenv,emailinuse', err.originalStatus)) {
					//session.verifyemail = rc.email;
					updateUserSession({email : rc.email});

					rc["response"]["payload"]["firstname"] = rc.firstname;
					rc["response"]["payload"]["redirect"] = '/completeregistration/emailinuse/#err.originalStatus#';
				} else 
					// parse error
					handleServerError(err);
					
			// no errors - profile created in db and verify email sent out in legacy system; 
			// redirect to ccompleteregistration to tell them to check email
			} else {	
				//retrieve user data by Email; refresh the user session with that data while
				// updating that password has been verifed 
				getUserByEmailAndSetSessionWithState(rc.email, {'pwdVerified': 1});
				
				// out of security concerns use a session variable to persist the email while relocating
				// NOTE: this is a JS ajax form submit; so redirect using fw not possible
				//session.verifyemail = rc.email;
				rc["response"]["res"] = true;
				rc["response"]["payload"]["firstname"] = rc.firstname;
				rc["response"]["payload"]["redirect"] = '/completeregistration';

			}
			
			renderResult();
		
	}

	/*************************************
	 setPassword (POST)
	 submits form pwd1 and pwd2 widget to 
	 set a password in the complete profile process
	 ajax : yes
	******************************************/
	public void function setPassword(struct rc = {}) {
		param name="rc.pwd1" default="";
		param name="rc.pwd2" default="";
		param name="rc.token" default="";

		// xtra bot protection
		captchaProtect();	
		
		// this route protected by a validated email set into session
		// and of course not blank password fields
		if (rc.userSession.isEmailVerified 
				&& len(rc.userSession.email)
				&& len(rc.pwd1)
				&& len(rc.pwd2)) {

			//validate form submit portion by loading into bean
			var pm = validateform('passwordmgrbean');
			pm.setEmail(rc.userSession.email);

			// use forgotpasswordbean for logic to also set a password
			var fp = variables.beanFactory.getBean( 'forgotpasswordbean' );
			fp.setEmail(rc.userSession.email);
			
			//try to set (reset) the password
			pm.resetPassword();

			if (pm.hasErrors()) {
				// can be a cf exception on the update statement or emailnotfound
				handleServerError(pm.getErrorContext());
			}  else {
					// update the security hashes table to say we are done.
					fp.markPasswordVerified();

					if(fp.hasErrors()) {
						handleServerError(fp.getErrorContext());
						
					} else {

						// update session to show password 
						updateUserSession({'pwdVerified': 1});
						rc["response"]["res"] = true;
						rc["response"]["payload"]["redirect"] = '/setpassword';
						
					}

			}

		} else {
			var content = config.getContent('register', 'passwordResetError');
			rc["response"]["errors"] = content.instruction;
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
	private string function resendLink(string sessionEmail='') {
		var status ='';
		if (!len(sessionEmail)) 
			return 'ResendLinkError';

		// generate a new hash and send it; make sure old one is removed or replaced
		var register = variables.beanFactory.getBean( 'registerbean' );
		register.setEmail(sessionEmail);
		register.setRoute('verify');
		register.resendlink();
		
		if (register.hasErrors()) 
			status = handleServerError(register.getErrorContext());
		else 
			status ='successfullySent';
	
		return status;
	
	}

	// /************************************************************
	// sendPasswordlink 
	// send email to verify email ownership so password can be set
	// email is needed so we expect rc.sessionEmail to be set
	// ************************************************************/
	// private string function sendPasswordlink(struct rc = {}) {
	// 	var status ='';
	// 		    if (!len(rc.sessionEmail)) 
	// 				return 'default';
	// 			// generate a new hash and send it; make sure old one is removed or replaced
	// 			var forgotpassword = variables.beanFactory.getBean( 'forgotpasswordbean' );
	// 			forgotpassword.setEmail(rc.sessionEmail);
	// 			forgotpassword.setRoute('passwordverify');
	// 			forgotpassword.generateLink();
				
	// 			if (forgotpassword.hasErrors()) 
	// 				status = handleServerError(forgotpassword.getErrorContext());
	// 				status='verifylinknotcreated'
	// 		 	else 
	// 		 		status ='passwordEmailsuccessfullySent';
		
	// 	return status;
	
	// }


	/************************************************************
	 verifyEmail 
	 user receives an email with an encoded link
	 to confirm their email address
	 TOKEN REQUIRED - rc.token

	************************************************************/
	// private string function verifyEmail(struct rc = {}) {
	
	// 	var status = "defaultverify";
					
	// 	var register = variables.beanFactory.getBean( 'registerbean' );
	// 	register.setVerifyToken(rc.token);

	// 	//  if token is invalid; handle error
	// 	if (!register.verifyToken()) {

	// 		// handle server error
	// 		status = handleServerError(register.getErrorContext());

	// 		// in the case of expired links give them chance to resend
	// 		if (status eq 'verifyLinkExpired') {
	// 			session.verifyemail = register.getEmail();
	// 		}
			
	// 	// yeah! token is valid so we are authenticated
	// 	}  else {
	// 		variables.userService.updateUserStateFromDb(email=register.getEmail(), state={'verifyVerified' : 1})
	// 		status ='successfullyVerified';
	// 	}
			
	// 	return status
	// }

	// /************************************************************
	//  verifyEmailForPwd 
	//  user receives an email with an encoded link
	//  to confirm their email address when attempt to set their 
	//  password
	//  TOKEN REQUIRED - rc.token

	// ************************************************************/
	// private string function verifyEmailForPwd(struct rc = {}) {
	
	// 	var status = "defaultverify";

	// 	var fp = variables.beanFactory.getBean( 'forgotpasswordbean' );
	// 	fp.setResetToken(rc.ptoken);

	// 	// check that token is valid
	// 	if (!fp.verifyToken()) {
	// 		//error
	// 		status  = handleServerError(fp.getErrorContext());
		
	// 	// no errors; pwd token is valid	
	// 	} else {
	// 		status ='PasswordSuccessfullyVerified';
	// 	}

			
	// 	return status;
	// }

	
	
}