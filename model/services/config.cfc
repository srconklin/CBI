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
        securelist : "myprofile.default",
        captchaProtect : "offer.create,inquiry.create,myprofile.submitforgotpassword,register.register",
        env : CGI.SERVER_NAME eq '127.0.0.1' ? 'dev'  : 'prod',
        threshold : 120
        
    }
    
    variables.Icons = {
       forgotpassword = {
            'successStatus' : 'default,linkCreated',
            'theIcon' : '<svg xmlns="http://www.w3.org/2000/svg" class="icon-title" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6"><path stroke-linecap="round" stroke-linejoin="round" d="M16.5 10.5V6.75a4.5 4.5 0 10-9 0v3.75m-.75 11.25h10.5a2.25 2.25 0 002.25-2.25v-6.75a2.25 2.25 0 00-2.25-2.25H6.75a2.25 2.25 0 00-2.25 2.25v6.75a2.25 2.25 0 002.25 2.25z" /></svg>'
        },
        verifyemail = {
            'successStatus' : 'defaultverify,successfullyVerified',
            'theIcon' : '<svg xmlns="http://www.w3.org/2000/svg" class="icon-title" style="width:6rem;height:6rem;" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M16 12a4 4 0 10-8 0 4 4 0 008 0zm0 0v1.5a2.5 2.5 0 005 0V12a9 9 0 10-9 9m4.5-1.206a8.959 8.959 0 01-4.5 1.207";</svg> '
        }
    }

    /*********************************************************************
    content lookup
    key 'title' present for screens with title and instruction layout
    *********************************************************************/
    variables.content = {
      
        catchall : {
            'default' :  {
                'title' :  'Oops, an Error has occurred',
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
                'instruction' :  'If the email was associated with a user account in our system, you should recieve a reset link shortly. The link is valid for 2 hours. Check your spam folder, if you still did not recieve the email, then trying re-sending the email again below.'
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
                'instruction' : "Looks like there was a problem, likely too much time has passed since the link to verfiy your email was created. You can visit <a href='/myprofile'>My Account</a> to re-verify your email address."
            },
            'defaultverify' :{
                'title' : "Hmm, something went wrong with verifying your email address.",
                'instruction' : "looks like there is a problem with the link, try logging into <a href='/myprofile'>My Account</a> to send another one."
            },
             'emailAlreadyVerified' : {
                'title' : 'Email Already Verified',
                'instruction' : "This email has already been verified. You can manage your account by visiting <a href='/myprofile'>My Account</a>."
             },
             'notVerified' : {
                'title': 'Email Not Yet Verified',
                'instruction' : "That email address exists but has not been verified. An email was already sent to <strong>[EMAIL]</strong> with a link to verify your account. Please click the link in that email.<br>If you did't receive the email, please check your spam folder or request a new link below."
             },
             'successfullySent' : {
                'title': 'Verify Email',
                'instruction' : "An email has been [TRIES] to <strong>[EMAIL]</strong> with a link to verify your account.<br>If you don't receive the email, please check your spam folder or request a new link below."
             },
             'successfullyVerified' : {
                'title': 'Yah! Email Verified',
                'instruction' : "You are now logged in! Please feel free to browse our inventory."
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
                'instruction' :  'We are having trouble generating the verify link. Try sending entering your email so send the link again.'
            },
            'registerationFailed' :  {
                'title' :  'Hmm, something went wrong with your registeration',
                'instruction' :  'There was an issue completing your registeration. We are looking inot this now. Please try again later.'
            }
            
        }

	}
    
    variables.statusMessages = {

        // catchall 
        'catchall' : 'Something has gone wrong with your request. Our technicians are looking into the issue now. Please try again later.',

        //captcha
        'captchaProtect' : 'Sorry, but we do not thing you are human. Try refreshing the page and sumbitting again.',

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