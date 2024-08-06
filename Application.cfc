component extends="framework.one" output="false" accessors=true {
	// this.name = ""
	this.applicationTimeout = createTimeSpan(2, 0, 0, 0);
	this.setClientCookies = true;
	this.sessionManagement = true;
	this.sessionTimeout = createTimeSpan(0, 2, 0, 0);
	this.datasource = 'dp_cat';

	
	property userService;
		

	// FW/1 settings
	variables.framework = {
		// action = 'action',
		// defaultSection = 'main',
		// defaultItem = 'default',
		generateSES = true,
		SESOmitIndex = true,
		decodeRequestBody = true,
		maxNumContextsPreserved = 1,
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
			 "$GET/resendlink/$" = "/register/completeprofile/resendlink/", 
			 // verify a token clicked on in an email
			 "$GET/verify/:token/$" = "/register/completeprofile/token/:token/" ,
			 // verify email ownership to set a password
			 "$GET/passwordverify/:token/$" = "/register/completeprofile/ptoken/:token/" ,
			 // redirect from submitResetPassword() to get back to completeprofile
			 "$GET/setpassword/$" = "/register/completeprofile", 
			 // reattempt to register with an existing email but not yet verified.
			 "$GET/completeprofile/notVerified/$" = "/register/completeprofile/notVerified" ,
			 // redirected here after deal offer for unvalidated users or a new reg
			 "$GET/completeprofile/$" = "/register/completeprofile" ,
			 // submit a registration form
			 "$POST/register/$" = "/register/register" 
			} ,

			{
				"$GET/forgotpassword/$" = "/forgotpassword/default", 
				"$GET/passwordReset/$" = "/forgotpassword/passwordReset",
				"$GET/resetpassword/:token/" = "/forgotpassword/resetpassword/token/:token/",
				"$POST/resetpassword/$" = "/forgotpassword/submitresetpassword", 
				"$POST/forgotpassword/$" = "/forgotpassword/submitforgotpassword"
			},

			// my profile actions secured in securelist
			{ 
				"$GET/myprofile/$" = "/myprofile/default" ,
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
			// { "$GET/loadfavorite/" = "/main/loadFavorite" },
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

	
	// public void function setupSession() {
	// 	// set up a default user session
	// 	controller( 'session.create' );
	// }

	function before( struct rc = {} ) {
		request.DSNCat =this.datasource;

		// reset the application 
		if(structKeyExists(rc, 'resetApp')) {
			userService.logout();
		} else if(!structKeyExists(session, 'user'))
			userService.defaultUserSession();

		// user session data
		rc["userSession"] = variables.userService.getUserSession();
				
	}

	//  public void function setupRequest() { 
	// 	request.DSNCat =this.datasource;
	// 	// prior to request, make sure if log in is required and/or user is authenticated
	// 	controller( 'security.authorize' );
		
	//  }

	public void function setupView(rc) {
		rc["userSession"] = variables.userService.getUserSession();
		//   writedump(var="#rc.usersession#",  abort="false");
		//   writedump(var="#session#",  abort="false");
    }

	public void function setupResponse() { }

	public string function onMissingView(struct rc = {}) {
		//return "Error 404 - Page not found.";
		return view( 'main/notFound' );
	}

	public function setupEnvironment(string env) {
		if(arguments.env eq 'prod') 
			this.mappings[ "/websnips" ] = "C:\inetpub\Dynaprice\shared\CodeSnips\Web";
		else	
			this.mappings[ "/websnips" ] = "C:\Users\scott\Projects\dynaprice\shared\CodeSnips\Web" 
	}

	public function getEnvironment() {
		if ( findNoCase( "sandbox", CGI.SERVER_NAME ) ) 
			return "prod";
		else 
			return "dev";
	}


}
