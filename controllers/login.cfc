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
    /*********************************
	 login (POST)
	 no view; redirects to home or to 
     destination if one specified
     ajax:no
     migrate
	*********************************/
    // function login( rc ) {

    //     //  no bean used; data validation here inline
    //     // if the form variables do not exist, redirect to the login form
    //     if ( !structKeyExists( rc, "username" ) and !structKeyExists( rc, "password" ) ) {
    //         variables.fw.redirectCustomURL( "/login" );
	// 	}
		
    //     // validate user  
	// 	var user = variables.userService.validateUser( rc.username, rc.password);
		
	// 	// not a struct means invalid credentials or duplicate rows, redisplay the login form
    //     if ( !isStruct(user) ) {
    //         rc.message = ["Invalid Username or Password"];
    //         variables.fw.redirectCustomURL( "/login", "message" );
    //     }

    //     //user authenticated
    //     user.validated = 2;

    //     // set up user session
    //     variables.userService.setUserSession(user)
         
	// 	if(structKeyExists(rc, 'destination'))
	// 		variables.fw.redirectCustomURL( "/#rc.destination#" );
	// 	else
    //     	variables.fw.redirectCustomURL( "/" );
    // }
   
	 
	/******************************
	 Logout (GET)
	******************************/
    function logout( rc ) {
        // tear down user session
        variables.userService.logout();
        variables.fw.redirectCustomURL( "/");
    }

}