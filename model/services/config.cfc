component accessors=true {
    variables.settings = {
      
        name : 'CBI',
        VTID : '63160',
        COTID : '107',
        dsn :  "dp_cat",
        aeskey : "XyekJNxLAIv2LlmULBkxNw==",
        captchasecret : "6LevHMkfAAAAAM2ohc3wTWLu8gYj0acuUXaG1_da",
        mail :  {
            errorTo : 'sconklin@dynaprice.net',
            errorFrom : 'sysadmin@dynaprice.com'
        },
       // captchaProtect : "offer.create,inquiry.create,myprofile.submitforgotpassword,register.register",
        env : CGI.SERVER_NAME eq '127.0.0.1' ? 'dev'  : 'prod',
        threshold : 120,
        securelist = {
            'myprofile' :  'default,changepassword,updatecontactinfo,updateAddress,updateCommPref'
        }
        
    }
    
    variables.Icons = {
       forgotpassword = {
            'successStatus' : 'default,linkCreated',
            'theIcon' : '<svg xmlns="http://www.w3.org/2000/svg" class="icon-title" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M16.5 10.5V6.75a4.5 4.5 0 10-9 0v3.75m-.75 11.25h10.5a2.25 2.25 0 002.25-2.25v-6.75a2.25 2.25 0 00-2.25-2.25H6.75a2.25 2.25 0 00-2.25 2.25v6.75a2.25 2.25 0 002.25 2.25z" /></svg>'
        },
        verifyemail = {
            'successStatus' : 'defaultverify,successfullyVerified,successfullyVerifiedButNeedPassword',
            'theIcon' : '<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="icon-title"><path stroke-linecap="round" stroke-linejoin="round" d="M9 12.75 11.25 15 15 9.75m-3-7.036A11.959 11.959 0 0 1 3.598 6 11.99 11.99 0 0 0 3 9.749c0 5.592 3.824 10.29 9 11.623 5.176-1.332 9-6.03 9-11.622 0-1.31-.21-2.571-.598-3.751h-.152c-3.196 0-6.1-1.248-8.25-3.285Z" /></svg>'
        }
    }

    /*********************************************************************
    content lookup
    key 'title' present for screens with title and instruction layout
    *********************************************************************/
    variables.content = {
      
        catchall : {
            'default' :  {
                'title' :  'Oops, an error has occurred',
                'instruction' :  'Something has gone wrong with your request. Our technicians are looking into the issue now. Please try again later.'
            },
        },  
        forgotpassword = {
            'default' :  {
                'title' :  'Forgot your Password',
                'instruction' :  'Enter the email address associated with your account and will send a link to reset your password.'
            },

            'resetPassword' :  {
                'title' :  'Password Reset',
                'instruction' :  'Please enter a new password. Once submitted, you can login using the newly created password.'
            },
            'captchaProtect' :  {
                'title' :  'Sorry but we do not think  you are human!',
                'instruction' :  'please try entering your email again'
            },

            'passwordSuccessfulyReset' :  {
                'title' :  'Password successfully reset',
                'instruction' :  "You may now <a href='/login'><u>login</u></a>!"
            },

            'missingEmail' :  {
                'title' :  'Hmm, Email seems to be missing',
                'instruction' :  'Looks like there was a problem. Enter a valid email and try it again.'
            },

            'invalidEmail' :  {
                'title' :  'Hmm, that does not look to be a valid email',
                'instruction' :  'Looks like there was a problem. Enter a valid email and try it again.'
            },

           'linkCreated' :  {
                'title' :  'Password Reset Successful',
                'instruction' :  'If the email was associated with a user account in our system, you should receive a reset link shortly. The link is valid for 2 hours. Check your spam folder, if you still did not receive the email, then trying re-sending the email again below.'
            },
            
            'linkNotCreated' :  {
                'title' :  'Hmm, something went wrong',
                'instruction' :  'We are having trouble generating the reset link. Let''s try entering your email address again.'
            },

            'passwordLinkExpired' :  {
                'title' :  'Password reset Link Expired',
                'instruction' :  'Sorry, that link is not valid anymore. Please try entering your email address again.'
            },
            
            'passwordNotReset' :  {
                'title' :  'Hmm, something went wrong with resetting your password.',
                'instruction' :  'Looks like there is a problem with the reset link. Please try entering your email address again.'
            }

        },
        register = {
            'default' : {
                'title' : "Hmm, something not quite right with your verify link.",
                'instruction' : "Looks like there was a problem. Likely, too much time has passed since the link to verify your email was created. <p class='mb-2 mt-2'>If you have already <b>registered</b> then you can login and visit <a href='/myprofile'>My Profile</a> to re-verify your email address.</p><p class='mb-2 mt-2'>If you <b>submitted an offer or inquiry</b>, then you can claim your auto-created account by <a href='/register'>registering</a> now.</p>"
            },
           
            'defaultCP' : {
                'title' : "Hmm, Looks like something is not quite right with your request",
                'instruction' : "Looks like you are trying to verify your email or set a new password, but some key information is missing.  Perhaps, you just completed setting up your profile, in which case you may <a href='/login'><u>log in</u></a> now. If not, maybe try your request again."
            },
           
            'defaultverify' :{
                'title' : "Hmm, something went wrong with verifying your email address.",
                'instruction' : "looks like there is a problem with the link, try logging into <a href='/myprofile'>My Profile</a> to send another one."
            },
             'emailAlreadyVerified' : {
                'title' : 'Email Already Verified',
                'instruction' : "This email has already been verified. You can manage your account by visiting <a href='/myprofile'>My Profile</a>."
             },
             'emailAlreadyVerifiedButNeedPassword' : {
                'title' : 'Email Already Verified',
                'instruction' : "This email has already been verified. Next step is to <b>set a password!</b> Click below to get started."
             },
             'notVerified' : {
                'title': 'Email Not Yet Verified',
                'instruction' : "The email address you entered already exists in our system but has not yet been verified. We already sent an email to <strong>[EMAIL]</strong> with a link to verify your account. Please click the link in that email.<br>If you did't receive the email, please check your spam folder or request a new link below."
             },
             'successfullySent' : {
                'title': 'Verify Email',
                'instruction' : "An email was [TRIES] to <strong>[EMAIL]</strong> with a link to verify your account.<br>If you don't receive the email, please check your spam folder or request a new link below."
             },
             'successfullyVerified' : {
                'title': 'Yah! Email Verified',
                'instruction' : "Thanks! You may now <a href='/login'><u>log in</u></a> and browse our inventory."
             },
             'successfullyVerifiedButNeedPassword' : {
                'title': 'Yah! Email Verified',
                'instruction' : "Next step is to <b>set a password!</b> Click below to get started."
             },
             'verifyLinkExpired' : {
                'title' : 'Verify Link Expired',
                'instruction' : 'Sorry, that link is not valid anymore. Please click the button below to send a new one.'
             },
            'emaildidnotverify' :  {
                'title' :  'Hmm, something went wrong with verifying your email.',
                'instruction' :  'There may be a technincal problem with the link you clicked to verify your email. If you cannot find a more recent email with a valid link, then try sending a new one below.'
            },
            'verifylinknotcreated' :  {
                'title' :  'Hmm, something went wrong',
                'instruction' :  'We are having trouble generating the verify link. Try entering your email to send the link again.'
            },
            // 'registerationFailed' :  {
            //     'title' :  'Hmm, something went wrong with your registeration',
            //     'instruction' :  'There was an issue completing your registeration. We are looking into this now. Please try again later.'
            // },
            'showSetPassword' :  {
                'title' :  'Set a Password',
                'instruction' :  'Create a password on your account so you can enjoy all the benefits of a member.'
            },
            'passwordEmailSuccessfullySent' : {
                'title': 'Let''s make sure its you!',
                'instruction' : "Before setting a password, we need to verify it's you. An email was [TRIES] to <strong>[EMAIL]</strong> with a link to set your password .<br>If you don't receive the email, please check your spam folder or request a new link below."
            },
            'passwordSuccessfullyVerified' : {
                'title': 'Great! Thanks for verifying! ',
                'instruction' : "You may now set a new password using the form below:"
             },
            'passwordLinkExpired' :  {
                'title' :  'Password Verificaton Link Expired',
                'instruction' :  'Sorry, that link is not valid anymore. Please request a new link below.'
            },
            'passwordNotReset' :  {
                'title' :  'Hmm, something went wrong with resetting your password.',
                'instruction' :  'Looks like there is a problem with the reset link. Please request a new link below.'
            },
            'completeProfileDone' :  {
                'title' :  'Password successfully Created',
                'instruction' :  "Thanks! Your profile is all set up. You may now <a href='/login'><u>log in</u></a>!"
            }
            
        }

	}
    
    variables.statusMessages = {

        // catchall 
        'catchall' : 'Something has gone wrong with your request. Our technicians are looking into the issue now. Please try again later.',

        //captcha
        'captchaProtect' : 'Sorry, but we do not thing you are human. Try refreshing the page and submitting again.',

        // user (login)
        'missing_login_fields' : 'You must enter a username and password',
        'user_not_found' :  'Username and/or password is invalid',
        'duplicate_user' : 'Something went wrong authenticating your account. Please email customer support',

        // basic dealmaking
        'missingMessage' :  'You must enter a message',
        'noHTML' : 'HTML not allowed',   
        'tooLong' : 'Too long . Please limit your input',
        'baditemno' : 'incorrect or badly formatted Item nr',
        'qtyMissing' : 'A quantity is required',
        'priceMissing' : 'A price is required',
        'passwordMissing' : 'Password is required',
        'invalidNumber' : 'not a valid number',
        'maxQty' : 'Maximum quantiy allowed reached', 
        'maxPrice' : 'Maximum price allowed reached',
        'invalidPrice' : 'Invalid price',  
        'missingFirstName' : 'First name is required',
        'missingLastName' : 'Last name is required', 
        'missingEmail' : 'Email is required',    
        'missingPhone' : 'Phone is required',
        'firstNameTooLong' : 'First name is too long.',
        'lastNameTooLong' : 'Last name is too long.',
        'emailTooLong' : 'Email is too long.',
        'companyTooLong' : 'Company name is too long.',
        'phoneTooLong' : 'Phone is too long.',
        'invalidEmail' : 'Not a valid email',
        'invalidPhone' : 'Not a valid phone number',
        'agreeTandC' : 'You must agree to the terms',
        'badTypeno' : 'The type of message you are sending could not be determined. Please refresh and try it again.',

        //contactinfo, pwdmgr
        'pnoNotFound' : 'We could not find your user account. Please try logging out and back in again.',   
        'missingaddress' : 'Address is required',
        'addressTooLong' : 'Address is too long',
        'missingPostalcode' : 'Postal code is required',
        'PostalcodeTooLong' : 'Postal code is too long',
        'invalidGID' : 'Geographical Identity not found',
        'missingLocGID' : 'City selection is required',
        'missingCyGID' : 'Country selection is required',
    
        //pwdmgr
        'missingPassword' :  "You must enter a valid password",
        'missingConfirmationPassword' :  "You must confirm your password",
        'passwordsDoNotMatch' :  "Passwords must match",
        'emailNotFound' : "We could not update the password with the email address provided.",
        'passwordnotcorrrect' : "Password is incorrect. Please try again.",
        'nolowercase' : "The Password must contain at least one lowercase character",
        'nouppercase' : "The Password must contain at least one uppercase character",
        'nodigit' : "The Password must contain at least one number",
        'tooshort' : "The Password must be at least 8 characters",
        'toolong' : "The Password can't be more than 20 characters",

        // contact us:

        'contactMSgAlreadySent' : "The Message was already Sent. Trying refreshing the page to send another message"

        // location lookup

        // 'emptygeochain' :   'The entry chosen does not contain a valid city and/or country. Please make another selection',
        // 'no_address_component' :   'Address component is missing.  Please make another selection.',

        //password reset
        // 'problemWithResetLink' : 'There is a problem with the reset link.',
        // 'resetLinkExpired' : 'Sorry, that link is not valid anymore'
     
    }

	function getContent(required string type, string status= 'default') {
       
        if(len(arguments.type)) {

            if (structKeyExists(content[type], arguments.status)) 
                return content[arguments.type][arguments.status];
            else 
                return content['catchall']['default'];
        // searching across all pages for a slug to have some content in the the errors key
        } else {
            var theKey = structFindKey( content, arguments.status, 'one' );
            if(arraylen(theKey)) {
                return theKey[1].value.instruction;
            } else {
                return 'notfound'
            }

        }
    
	}

	function lookUpStatus(string status= 'default') {
		return structKeyexists(statusMessages, arguments.status) ? statusMessages[arguments.status] : 'notfound';
	}

	function getIcons(required string type, string status= 'default') {
		return Icons[type];
	}

    function getSetting(required string setting) {
		return settings[arguments.setting];
	}
	
    function getSettings() {
		return settings;
	}

    /**********************************************************
	 getValidSVGICon
     Get the svg icon to show based on current status
	*********************************************************/
	function getValidSVGIcon(string routine = '', string status ='default') {
        var svg = '';
        var icons = getIcons(arguments.routine);

        // check the list of statuses for the routine we are on and show the success one
        if (listfindnocase(icons.successStatus, arguments.status)) 
			 svg = icons.theIcon;
        // otherwise show the stock error one     
		else 
			svg =  '<svg xmlns="http://www.w3.org/2000/svg" class="icon-title" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" /></svg> ';
        
        return svg;

    }
    
}