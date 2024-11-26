component accessors=true extends="controllers.base.common" {

	property fw;
    property userService;
    property config;

    function before( rc ) {
        super.before(rc);

        // if fully logged in then do not show or perform login methods; reroute to main
        // allow partial 
        if (rc.userSession.validated gt 1 && variables.fw.getItem() != "logout" ) {
            renderResult('/main') ;
        }
    }

	/******************************
	 login (GET)
	******************************/
    public void function default(struct rc = {}) {
        // default login in view is full screen login page with no layout
		// request.layout =false;

        // using the register page version:
        // set to the register page version with register modal suppressed
        rc.showlogin= true;
        // register page contains login form
        variables.fw.setview('register.default');
        
	}

    /*********************************
	 login (POST)
	 no view; redirects to home or to 
     destination if one specified
     ajax:no
	*********************************/
    function login( rc ) {
        param name="rc.message" default="" ;
        param name="rc.destination" default="" ;

        var route = '/login';
        
        // captcha
		if(len(rc.response.errors)) { 
			rc.message = config.lookupStatus('captchaProtect');	
		} else {
			
            //validate form by loading into bean
            var user = validateform('userbean');
            
            // bean validation errors
            if(user.hasErrors()) 
                rc.message = user.getErrors();
           // if(len(rc.response.errors)) 
              //  rc.message = rc.response.errors;
            
            // check if user credentails are valid and attempt to login them
            else if(!user.attemptLogin()) 
                rc.message = user.getErrors();
            // log user in
            else {
                // set up user session
                updateUserSession(user.getUserData())
                route = '/#rc.destination#';
            }
        }
        renderResult(route, 'message' ) ;
    }
    	 
	/******************************
	 Logout (GET)
	******************************/
    function logout( rc ) {
        // tear down user session
        variables.userService.logout();
        variables.fw.redirectCustomURL( "/");
    }

}