component extends="framework.one" output="false" accessors=true {
	setting showDebugOutput="false";
	// this.name = ""
	this.applicationTimeout = createTimeSpan(2, 0, 0, 0);
	this.setClientCookies = true;
	this.sessionManagement = true;
    this.sessionTimeout = createTimeSpan(0, 2, 0, 0);
	this.datasource = 'dp_cat';
	
	property userService;
	property utils;
	property botSessionManager;
	

	// FW/1 settings
	variables.framework = {
		// action = 'action',
		// defaultSection = 'main',
		// defaultItem = 'default',
		generateSES = true,
		SESOmitIndex = true,
		decodeRequestBody = true,
		maxNumContextsPreserved = 1,
		trace = false,
		// diEngine = "di1",
		// diComponent = "framework.ioc",
		// diLocations = "model, controllers",
		 diConfig = {
			loadListener : function( di1 ) { di1.load(); },
		  	exclude: ['/model/base/', ',model/beans/common.cfc']
		},
		// reloadApplicationOnEveryRequest = false,
        routes = [

			{ "$GET/login/" = "/login/default" },
			{ "$POST/login/" = "/login/login" },
			{ "$GET/logout/" = "/login/logout" },

			// register
			{ 
			// show the register form	
			"$GET/register/$" = "/register/default" ,
						 
			 // resend a verify email
			 "$GET/resendlink/$" = "/register/handleResendLink", 
			 // verify a token clicked on in an email
			 "$GET/verify/:token/$" = "/register/handleEmailVerification/token/:token/" ,
			 // verify email ownership to set a password
			 "$GET/passwordverify/:token/$" = "/register/completeprofile/ptoken/:token/" ,
			 // redirect from setPassword post action to  finish of set up password
			 "$GET/setpassword/$" = "/register/completeSetPassword", 
			 // submitting a set password action to complete setting up user profile.
			 "$POST/setpassword/$" = "/register/setPassword", 
			 
			 "$GET/completeautoreg/$" = "/register/completeAutoReg" ,
			 // reattempt to register with an existing email but not yet verified.
			 "$GET/completeregistration/emailinuse/:emailinuse/$" = "/register/completeRegistration/emailinuse/:emailinuse" ,
			 // redirected from register (POST) to show directions for verifying email
			// "$GET/completeprofile/$" = "/register/completeprofile" ,
			 "$GET/completeregistration/$" = "/register/completeRegistration" ,
			 // submit a registration form
			 "$POST/register/$" = "/register/register" 
			} ,

			// forgot password routes 
			{
				// complete screen
				"$GET/passwordresetcomplete/$" = "/forgotpassword/passwordresetcomplete",
				//show screen to enter email to send link to
				"$GET/forgotpassword/$" = "/forgotpassword/default", 
			
				// email clicked with token to show password manager
				"$GET/resetpassword/:token/" = "/forgotpassword/resetpassword/token/:token/",
				// submits password manager
				"$POST/resetpassword/$" = "/forgotpassword/submitresetpassword", 
				//sends email if account exists
				"$POST/forgotpassword/$" = "/forgotpassword/submitforgotpassword"
			},

			// my profile actions secured in securelist
			{ 
				"$GET/myprofile/$" = "/myprofile/default" ,
				"$GET/dealdetails/$" = "/myprofile/dealdetails" ,
				"$GET/reply/$" = "/myprofile/sendmessage" ,
				"$GET/myoffers/$" = "/myprofile/myoffers" ,
				"$GET/myfavorites/$" = "/myprofile/myfavorites" ,
				
				"$POST/changepassword/$" = "/myprofile/changepassword",
				"$POST/updatecontactinfo/$" = "/myprofile/updatecontactinfo",
				"$POST/updateaddress/$" = "/myprofile/updateaddress",
				"$POST/updateCommPref/$" = "/myprofile/updateCommPref"
			},

			{ "$GET/search/" = "/main/default" },
			{ "$GET/contact/$" = "/main/contact" },
			{ "$POST/contact/$" = "/main/submitContact" },
			{ "$GET/faq/$" = "/main/faq" },
			{ "$GET/about/$" = "/main/about" },
			{ "$GET/terms/$" = "/main/terms" },
			{ "$GET/privacy/$" = "/main/privacy" },
			{ "$POST/locationlookup/$" = "/main/locationlookup" },

			{ "$GET/items/{id:[0-9]+}/" = "/main/showitem/id/:id" },

			{ "$POST/offer/$" = "/dealmaking/makedeal" },
			{ "$POST/inquiry/$" = "/dealmaking/makedeal" },

			{ "$POST/togglefavorite/" = "/main/togglefavorite" },
			{ "$GET/getfavorites/" = "/main/getFavorites" },
			

			{ "$GET/IsLoggedIn/" = "/main/IsLoggedIn" }
		 ]
	};

	variables.framework.environments = {
		dev = { 
				reloadApplicationOnEveryRequest = true
			},
		prod = {
			 password = "Pri234Sc"
		}
	};


	public function before( struct rc = {} ) {
		request.DSNCat =this.datasource;
		// reset the application 
		if(structKeyExists(rc, 'resetApp')) {
			userService.logout();
		} else if(!structKeyExists(session, 'user'))
			userService.defaultUserSession();

		// user session data
		rc["userSession"] = variables.userService.getUserSession();

		 // Enable only in development mode to avoid exposing data in production
		 if (getEnvironment() eq "dev") {

			if (!utils.isAjaxRequest()) {
				// Enable debugging for non-AJAX requests
				setting showDebugOutput="true";
				// Trace the user session at the beginning of the request
				// cftrace(var="rc", text="rc scope at begining of the request", type="information", category="requestDebug");
				cftrace(var="rc.usersession", text="rc.usersession at begining of the request", type="information", category="SessionDebug");
            
			} 
			       
        }
				
	}
	

	public function after(string controller, struct rc) {
		// Enable only in development mode to avoid exposing data in production
        if (getEnvironment() === "dev") {
			if (!utils.isAjaxRequest()) {
				// Enable debugging for non-AJAX requests
				setting showDebugOutput="true";
				// Trace the session scope at the end of the request
				// cftrace(var="rc", text="rc scope at end of the request", type="information", category="requestDebug");
				cftrace(var="rc.usersession", text="rc.usersession at request end", type="information", category="SessionDebug");
			}
        }
    }

	public function setupResponse(struct rc) {
		var isDev = getEnvironment() === "dev" ? true : false;
		botSessionManager.detectAndManageBotSessions();
	}

	public string function onMissingView(struct rc = {}) {
		//return "Error 404 - Page not found.";
		return view( 'main/notFound' );
	}

	private function setupEnvironment(string env) {
		if(arguments.env eq 'prod') 
			this.mappings[ "/websnips" ] = "C:\inetpub\Dynaprice\shared\CodeSnips\Web";
		else	
			this.mappings[ "/websnips" ] = "C:\Users\scott\Projects\dynaprice\shared\CodeSnips\Web" 
	}

	private function getEnvironment() {
		if ( findNoCase( "sandbox", CGI.SERVER_NAME ) ) 
			return "prod";
		else 
			return "dev";
	}


}
