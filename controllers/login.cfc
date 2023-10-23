component accessors=true extends="controllers.base.common" {

	property fw;
    property userService;

    function before( rc ) {
        if (rc.userSession.isloggedIn &&  variables.fw.getItem() != "logout" ) {
            renderResult(rc, '/main') ;
        }
        super.before(rc);
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
			rc.fpstatus = rc.response.errors;	
		} else {
			
            //validate form by loading into bean
            var user = validateform(rc, 'userbean');
            
            // bean validation errors
            if(len(rc.response.errors)) 
                rc.message = rc.response.errors;
            
            // instead of using a service layer, add business logic to domain object to make the rich (non-anemic)
            // check if user is real - > makes an odbc call authenticate user
            else if(!user.isUserValid()) 
                rc.message = [user.getErrors()];

            else {
                // set up user session
                variables.userService.setUserSession(user.getUserData());
                route = '/#rc.destination#';
            }
        }
        renderResult(rc, route, 'message' ) ;
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