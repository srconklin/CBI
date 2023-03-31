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
         env : CGI.SERVER_NAME eq '127.0.0.1' ? 'dev'  : 'prod'
        
    }

    
    variables.Icons = {
        resetpassword = {
            'successStatus' : 'default',
            'theIcon' : '<svg xmlns="http://www.w3.org/2000/svg" class="icon-title" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6"><path stroke-linecap="round" stroke-linejoin="round" d="M16.5 10.5V6.75a4.5 4.5 0 10-9 0v3.75m-.75 11.25h10.5a2.25 2.25 0 002.25-2.25v-6.75a2.25 2.25 0 00-2.25-2.25H6.75a2.25 2.25 0 00-2.25 2.25v6.75a2.25 2.25 0 002.25 2.25z" /></svg>'
        },
        forgotpassword = {
            'successStatus' : 'default,linkCreated',
            'theIcon' : '<svg xmlns="http://www.w3.org/2000/svg" class="icon-title" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6"><path stroke-linecap="round" stroke-linejoin="round" d="M16.5 10.5V6.75a4.5 4.5 0 10-9 0v3.75m-.75 11.25h10.5a2.25 2.25 0 002.25-2.25v-6.75a2.25 2.25 0 00-2.25-2.25H6.75a2.25 2.25 0 00-2.25 2.25v6.75a2.25 2.25 0 002.25 2.25z" /></svg>'
        },
        verifyemail = {
            'successStatus' : 'defaultverify,successfullyVerified',
            'theIcon' : '<svg xmlns="http://www.w3.org/2000/svg" class="icon-title" style="width:6rem;height:6rem;" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M16 12a4 4 0 10-8 0 4 4 0 008 0zm0 0v1.5a2.5 2.5 0 005 0V12a9 9 0 10-9 9m4.5-1.206a8.959 8.959 0 01-4.5 1.207";</svg> '
        }
    }

    variables.content = {

        setpassword = {
            'default' :  {
                'title' :  'Password Reset',
                'instruction' :  'Please enter a new password. Once submitted, you can login using the newly created password.'
            },
            'invalidCaptcha' :  {
                'title' :  'Hmm, something went wrong',
                'instruction' :  'We are having trouble verifying that you are real. Please try entering and confirming your email address again.'
            },
            'passwordReset' :  {
                'title' :  'Password successfully reset',
                'instruction' :  "You may now <a href='/login'><u>login</u></a>!"
            },
            'passwordNotReset' :  {
                'title' :  'Hmm, something went wrong',
                'instruction' :  "We are having trouble verifying resetting your password. Let''s try it again."
            },
            'missingPassword' :  {
                'title' :  'Hmm, password missing',
                'instruction' :  "You must enter a valid password"
            },
            'missingConfirmationPassword' :  {
                'title' :  'Hmm, confirmation password missing',
                'instruction' :  "You must confirm your password"
            },
            'passwordsDoNotMatch' :  {
                'title' :  'Hmm, something not quite right',
                'instruction' :  "Passwords must match"
            },
            'EmailNotFound' : {
                'title' :  'Hmm, something not quite right',
                'instruction' :  "We could not update the password from the email address provided."
            }
            
        },                
        forgotpassword = {
            'default' :  {
                'title' :  'Forgot your Password',
                'instruction' :  'Enter the email address associated with your account and will send a link to reset your password.'
            },
            'missingEmail' :  {
                'title' :  'Hmm, Email seems to be missing',
                'instruction' :  'Looks like there was a problem. Enter a valid email and try it again.'
            },
            'invalidEmail' :  {
                'title' :  'Hmm, that does not look to be a valid email',
                'instruction' :  'Looks like there was a problem. Enter a valid email and try it again.'
            },
            'invalidCaptcha' :  {
                'title' :  'Hmm, something went wrong',
                'instruction' :  'We are having trouble verifying that you are real. Please try entering your email address again.'
            },
            'linkCreated' :  {
                'title' :  'Password Reset Link Created',
                'instruction' :  'If your email was associated with a user account in our system, then you should recieve a reset link shortly. That link is valid for 2 hours.<br>Check your spam folder, if you still did not recieve the email, the trying sending it again below.'
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
                'instruction' : "An email has been sent to <strong>[EMAIL]</strong> with a link to verify your account.<br>If you don't receive the email, please check your spam folder or request a new link below."
             },
             'successfullyVerified' : {
                'title': 'Yah! Email Verified',
                'instruction' : "You are now logged in! Please feel free to browse our inventory."
             },
             'expired' : {
                'title' : 'Verify Link Expired',
                'instruction' : 'Sorry, that link is not valid anymore. Please click the button below to send a new one.'
             },
             'invalidCaptcha' :  {
                'title' :  'Hmm, something went wrong',
                'instruction' :  'We are having trouble verifying that you are real. Please try entering your email address again.'
            }
            
        },
        basicforms : {
            'missingMessage' : {
                'instruction': 'You must enter a message'
            },
            'noHTML' : {
                'instruction': 'HTML not allowed'
            },   
            'tooLong' : {
                'instruction': 'Too long . Please limit your input'
            },    
            'qtyMissing' : {
                'instruction': 'A quantity is required'
            },
            'priceMissing' : {
                'instruction': 'A price is required'
            },
            'passwordMissing' : {
                'instruction': 'Password is required'
            },
            'invalidNumber' : {
               'instruction': 'not a valid number'
            },
            'maxQty' : {
                'instruction': 'Maximum quantiy allowed reached'
            },
            'maxPrice' : {
                'instruction': 'Maximum price allowed reached'
            },   
            'invalidPrice' : {
                'instruction': 'Invalid price'
            },
            'missingFirstName' : {
                'instruction': 'First name is required'
            },    
            'missingLastName' : {
                'instruction': 'Last name is required'
            },    
            'missingEmail' : {
                'instruction': 'Email is required'
            },    
            'firstNameTooLong' : {
                'instruction': 'First name is too long.'
            },    
            'lastNameTooLong' : {
                'instruction': 'Last name is too long.'
            },    
            'emailTooLong' : {
                'instruction': 'Email is too long.'
            },    
            'companyTooLong' : {
                'instruction': 'Company name is too long.'
            },    
            'phoneTooLong' : {
                'instruction': 'Phone is too long.'
            },    
            'invalidEmail' : {
                'instruction': 'Not a valid email'
            },    
            'invalidPhone' : {
                'instruction': 'Not a valid phone number'
            }    

        },
        captchaProtect : {
            'invalid' : 'Sorry, but we do not thing you are human. Try refreshing the page and sumbitting again.'

        }


	}
    
	function getContent(required string type, string status= 'default') {
		return content[type][status];
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
    
}