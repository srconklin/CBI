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

			
			{ "$GET/register/$" = "/register/default" ,
			 "$GET/verify_email/" = "/register/verify_email" ,
			 "$GET/verify/:token/" = "/register/verifyemail/token/:token/" ,
			 "$POST/resendlink/" = "/register/resendlink" ,
			 "$POST/register/" = "/register/register" 
			} 

			{

				"$GET/forgotpassword/$" = "/forgotpassword/default", 
				"$GET/passwordReset/$" = "/forgotpassword/passwordReset",
				"$GET/resetpassword/:token/" = "/forgotpassword/resetpassword/token/:token/",
				"$POST/resetpassword/$" = "/forgotpassword/submitresetpassword", 
				"$POST/forgotpassword/$" = "/forgotpassword/submitforgotpassword"

			}
			
			{ 
				"$GET/myprofile/$" = "/myprofile/default" ,
				"$POST/changepassword/$" = "/myprofile/changepassword",
				"$POST/updatecontactinfo/$" = "/myprofile/updatecontactinfo",
				"$POST/myaddress/$" = "/myprofile/updateAddress"
			},

			{ "$GET/search/" = "/main/default" },
			{ "$GET/contact/$" = "/main/contact" },
			{ "$GET/faq/$" = "/main/faq" },
			{ "$GET/about/$" = "/main/about" },
			{ "$GET/terms/$" = "/main/terms" },
			{ "$POST/locationlookup/$" = "/main/locationlookup" },

			{ "$GET/items/{id:[0-9]+}/" = "/main/showitem/id/:id" },

			{ "$POST/offer/$" = "/dealmaking/makedeal/" },
			{ "$POST/inquiry/$" = "/dealmaking/makedeal" },

			{ "$GET/test/" = "/test/default" }
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

	
	public void function setupSession() {
		// set up a default session
		controller( 'security.session' );
		//variables.userService.defaultUserSession();

	}

	function before( struct rc = {} ) {
		
		// reset the application 
		if(structKeyExists(rc, 'resetApp')) {
			userService.logout();
		}
		// user session data
		rc["userSession"] = variables.userService.getUserSession();
				
	}

	 public void function setupRequest() { 
		request.DSNCat =this.datasource;
		// prior to request, make sure if log in is required and/or user is authenticated
		controller( 'security.authorize' );
	 }

	public void function setupView(rc) {
		rc["userSession"] = variables.userService.getUserSession();
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
