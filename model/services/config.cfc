component accessors=true {
    variables.settings = {
      
        name : 'CBI',
        VTID : '63160',
        TRANSVTID : '1546',
        IVTID : '108',
        COTID : '107',
        //dsn :  "dp_cat",
        domain :  "https://www.capovani.com",
        imgBase :  "https://www.capovani.com/clientresources/",
        aeskey : "XyekJNxLAIv2LlmULBkxNw==",
        captchasecret : "6LevHMkfAAAAAM2ohc3wTWLu8gYj0acuUXaG1_da",
        mail :  {
            errorTo : 'sconklin@dynaprice.net',
            errorFrom : 'sysadmin@dynaprice.com'
        },
        // captchaProtect : "offer.create,inquiry.create,myprofile.submitforgotpassword,register.register",
       //  env : CGI.SERVER_NAME eq '127.0.0.1' ? 'dev'  : 'prod',
        threshold : 120,
        securelist = {
            'myprofile' :  'default,changepassword,updatecontactinfo,updateAddress,updateCommPref,myprofile,myoffers,dealdetails,myfavorites'
        }
        
    }
   
    
    /****************
     SVG icons
    *****************/ 
    variables.svgIcons = {
        "circleExclamation" : '<svg xmlns="http://www.w3.org/2000/svg" class="icon-title" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>',
        "triangleExclamation": '<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="icon-title"><path stroke-linecap="round" stroke-linejoin="round" d="M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 0L2.697 16.126ZM12 15.75h.007v.008H12v-.008Z" /></svg>',
        "envelope": '<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="icon-title"><path stroke-linecap="round" stroke-linejoin="round" d="M21.75 6.75v10.5a2.25 2.25 0 0 1-2.25 2.25h-15a2.25 2.25 0 0 1-2.25-2.25V6.75m19.5 0A2.25 2.25 0 0 0 19.5 4.5h-15a2.25 2.25 0 0 0-2.25 2.25m19.5 0v.243a2.25 2.25 0 0 1-1.07 1.916l-7.5 4.615a2.25 2.25 0 0 1-2.36 0L3.32 8.91a2.25 2.25 0 0 1-1.07-1.916V6.75" /></svg>',
        "lock": '<svg xmlns="http://www.w3.org/2000/svg" class="icon-title" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M16.5 10.5V6.75a4.5 4.5 0 10-9 0v3.75m-.75 11.25h10.5a2.25 2.25 0 002.25-2.25v-6.75a2.25 2.25 0 00-2.25-2.25H6.75a2.25 2.25 0 00-2.25 2.25v6.75a2.25 2.25 0 002.25 2.25z" /></svg>',
        "shieldcheck": '<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="icon-title"><path stroke-linecap="round" stroke-linejoin="round" d="M9 12.75 11.25 15 15 9.75m-3-7.036A11.959 11.959 0 0 1 3.598 6 11.99 11.99 0 0 0 3 9.749c0 5.592 3.824 10.29 9 11.623 5.176-1.332 9-6.03 9-11.622 0-1.31-.21-2.571-.598-3.751h-.152c-3.196 0-6.1-1.248-8.25-3.285Z" /></svg>'
    };
    // Status-to-SVG mapping
    variables.statusToSvg = {
        "triangleExclamation": [
            "completeRegistrationError",
            "completeAutoRegError",
            "incompleteUserAccessStep1",
            "incompleteUserAccessStep2",
            "emailinuse",
            "emailinusenv",
            "passwordResetError",
            "verifyLinkExpired",
            "emaildidnotverify",
            "emailverifyError",
            "ResendLinkError",
            "verifylinknotcreated",
            // passsword
            'passwordlinknotcreated',
            'passwordNotReset',
            "passwordResetError"

        ],
        "envelope": [
            "successfullySent",
            "emailAlreadyVerified"
        ],
        "lock": [
            "emailAlreadyVerifiedButNeedPassword",
            "passwordAlreadyVerified",
            "successfullyVerifiedButNeedPassword",
            "forgotpassword",
            "passwordlinkCreated",
            "resetPassword"

        ],
        "shieldcheck" : [
            "profileComplete",
            "passwordSuccessfulyReset"

        ]
    };
    
    
      
    // lock icon
    variables.Icons = {
       forgotpassword = {
            'successStatus' : 'default,linkCreated',
            'theIcon' : '<svg xmlns="http://www.w3.org/2000/svg" class="icon-title" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M16.5 10.5V6.75a4.5 4.5 0 10-9 0v3.75m-.75 11.25h10.5a2.25 2.25 0 002.25-2.25v-6.75a2.25 2.25 0 00-2.25-2.25H6.75a2.25 2.25 0 00-2.25 2.25v6.75a2.25 2.25 0 002.25 2.25z" /></svg>'
        },
        // this is sheild with checkmark
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
            'forgotpassword' :  {
                'title' :  'Forgot your Password',
                'instruction' :  'Enter the email address associated with your account and will send a link to reset your password.'
            },

            'resetPassword' :  {
                'title' :  'Password Reset',
                'instruction' :  'Enter your new password below. Once you submit, you''ll be able to log in using your updated password.'
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

           'PasswordlinkCreated' :  {
                'title' :  'Password Reset Link Sent',
                'instruction' :  'If the email is associated with a user account in our system, you should receive a reset link shortly. The link is valid for 2 hours. If you still did not receive the email, Check your spam folder and/or try re-sending the email again below.'
            },
            
            'passwordlinknotcreated' :  {
                'title' :  'Hmm, something went wrong',
                'instruction' :  'We are having trouble generating the password reset link. Let''s try entering your email address again.'
            },

            'passwordLinkExpired' :  {
                'title' :  'Password reset Link Expired',
                'instruction' :  'Sorry, that link is not valid anymore. Please try entering your email address again.'
            },
            'passwordResetError' : {
                'title' : "Hmm, something went wrong with resetting your password.",
                'instruction' : "Looks like there was a problem resetting your password. Maybe trying requesting a new Try entering your email address again by following the <a href='/forgotpassword' class='login-fp'>Forgot Password</a> link."
            },
            'passwordNotReset' :  {
                'title' :  'Hmm, something went wrong with resetting your password.',
                'instruction' :  "Looks like there is a problem with the reset link. Please try entering your email address again."
            }

        },
        register = {
            'completeAutoRegError' : {
                'title' : "Hmm, something went wrong",
                'instruction' : "It seems we were trying to create a user account for you or automatically log you in with your email, but something went wrong. We are looking into this."
            },
            'completeRegistrationError' : {
                'title' : "Hmm, something went wrong with completing your registration.",
                'instruction' : "It seems we tried sending you a confirmation email, but it couldn't be delivered because the email address is missing. If you've already received an email from us, please click the link in it to continue. If not, please try <a href='/register'>registering</a> again."
            },
            'incompleteUserAccessStep1' : {
                'title' : "Account Setup Incomplete",
                'instruction' : "To access your Account settings, you must verify your email and set up a password. Once these steps are complete, you'll be able to log in and manage your profile, favorites, offers, and inquiries.<br><br>  We already sent an email to <strong>[EMAIL]</strong> with a link to verify your account. Please click the link in that email. If you did't receive the email, please check your spam folder or request a new link below."
            },
            'incompleteUserAccessStep2' : {
                'title' : "Account Setup Incomplete",
                'instruction' : "To access your Account settings, you must verify your email and set up a password. Once these steps are complete, you'll be able to log in fully and manage your profile, favorites, offers, and inquiries.<br><br> Looks like your email has been successfully verified. The next step is to <b>set up your password!</b>"
            },
            'ResendLinkError' : {
                'title' : "Hmm, something went wrong sending a new verify link.",
                'instruction' : "Looks like there was a problem. <p class='mb-2 mt-2'>If you have already <b>registered</b> visit <a href='/myprofile'>My Profile</a> and follow the instructions to re-verify your email address.</p><p class='mb-2 mt-2'>If you <b>submitted an offer or inquiry</b>, you can claim your auto-created account by <a href='/register'>registering</a> fully.</p>"
            },
            'emailverifyError' :{
                'title' : "Hmm, something went wrong with verifying your email address.",
                'instruction' : "looks like there is a problem with the link, try logging into <a href='/myprofile'>My Profile</a> to send another one."
            },
             'emailAlreadyVerified' : {
                'title' : 'Email Already Verified',
                'instruction' : "This email has already been verified. You can manage your account by visiting <a href='/myprofile'>My Profile</a>."
             },
             'emailAlreadyVerifiedButNeedPassword' : {
                'title' : 'Email Already Verified',
                'instruction' : "<strong>[EMAIL]</strong> has already been verified. Next step is to <b>set a password!</b>"
             },
             'emailInUseNV' : {
                'title': 'Email Not Yet Verified',
                'instruction' : "The email address you entered already exists in our system but has not yet been verified. We already sent an email to <strong>[EMAIL]</strong> with a link to verify your account. Please click the link in that email.<br>If you did't receive the email, please check your spam folder or request a new link below."
             },
             'emailInUse' : {
                'title': 'Email Exists And Verified',
                'instruction' : "That email address exists and has already been verified. Please <a href='/login' class='login-fp'>login</a> instead.<br><br>If you have forgotten your password follow the <a href='/forgotpassword' class='login-fp'>Forgot Password</a> link to reset it."
             },
             'successfullySent' : {
                'title': 'Verify Email',
                'instruction' : "An email was [TRIES] to <strong>[EMAIL]</strong> with a link to verify your account.<br>If you don't receive the email, please check your spam folder or request a new link below."
             },
             'successfullyVerified' : {
                'title': 'All Set! Email Verified',
                'instruction' : "Thanks! You may now <a href='/login'><u>log in</u></a> and browse our inventory."
             },
             'successfullyVerifiedButNeedPassword' : {
                'title': 'Great! Your Email is Verified.',
                'instruction' : "Next step is to <b>set a password!</b> by using the form below."
             },
             'verifyLinkExpired' : {
                'title' : 'Verify Link Expired',
                'instruction' : 'Sorry, that link is not valid anymore. Please click the button below to send a new one.'
             },
            'emaildidnotverify' :  {
                'title' :  'Hmm, something went wrong with verifying your email.',
                'instruction' :  "The link you clicked may be experiencing a technical issue, has expired, or has been replaced by a newer one. If you can't find a more recent email with a valid link, please request a new one below."
            },
            'verifylinknotcreated' :  {
                'title' :  'Hmm, something went wrong',
                'instruction' :  'We are having trouble generating the verify link. Try entering your email to send the link again.'
            },
           
            'profileComplete' :  {
                'title' :  'Password successfully Created',
                'instruction' :  "Thank you! Your profile has been successfully set up. You can now <a href='/login'><u>log in</u></a> to get started!"
            },
            'passwordAlreadyVerified' : {
                'title' : 'Password Already Set Up',
                'instruction' : "You have already set up a password. If you have forgotten your password follow the <a href='/forgotpassword' class='login-fp'>Forgot Password</a> link to reset it."
             },
            
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

    /**
     * Determines if resend button for email verfication is allowed to show 
     * based on the status in the heirarchy of completing profile redirects
     * @param status (string) - The status to check.
     * @return (boolean) - True if resending is allowed, false otherwise.
     */
    function isResendAllowed(status) {
        var nonResendStatuses = {
            "completeAutoRegError": true,
            "completeRegistrationError": true,
            "successfullyVerified": true,
            "emailAlreadyVerified": true,
            "successfullyVerifiedButNeedPassword": true,
            "emailAlreadyVerifiedButNeedPassword": true,
            "profileComplete": true,
            "passwordResetError" : true,
            "ResendLinkError" : true,
            "emailinuse" : true
        };

        // Return true if the status is NOT in the nonResendStatuses list
        return !StructKeyExists(nonResendStatuses, LCase(status));
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
	 getStatusIcon
     Get the svg icon to show based on current status
	*********************************************************/
	 public string function getStatusIcon(required string status) {
        // Find the SVG type based on the status
        var svgType = "triangleExclamation"; // Default SVG type
       // Loop through the statusToSvg struct to check if the status exists in any array
        for (var key in variables.statusToSvg) {
            if (arrayContains(variables.statusToSvg[key], status)) {
                svgType = key;
                break;
            }
        }
        // Return the corresponding SVG
        return variables.svgIcons[svgType];

    }  
    
}