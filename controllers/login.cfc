component accessors=true {

	property framework;
    property userService;

    // function init( fw ) {
    //     variables.framework = fw;
    //     return this;
    // }

	
	public void function default(struct rc = {}) {
        // default login in view is full screen login page with no layout
		//request.layout =false;
        // set to the register page version with register modal suppressed
        rc.loginonly= true;
        
        variables.framework.setview('register.default');
        
	}


    function before( rc ) {
            if (variables.userService.isloggedIn() &&  variables.framework.getItem() != "logout" ) {
                variables.framework.redirectCustomURL( "/main" );
        }
    }

    function login( rc ) {

        // if the form variables do not exist, redirect to the login form
        if ( !structKeyExists( rc, "username" ) || !structKeyExists( rc, "password" ) ) {
            variables.framework.redirectCustomURL( "/login" );
		}
		
        // validate user  
		var user = variables.userService.validateUser( rc.username, rc.password);
		
		// on invalid credentials, redisplay the login form
        if ( !isStruct(user) ) {
            rc.message = ["Invalid Username or Password"];
            variables.framework.redirectCustomURL( "/login", "message" );
        }

        //user authenticated
        user.validated = 2;

        // set up user session
        variables.userService.setUserSession(user)
                
        // // set session variables from valid user
        // session.auth.isLoggedIn = true;
        // session.auth.fullname = user.firstname & " " & user.lastname;
        // session.auth.user = user;
        // // user logged in; show validated as 2
        // session.validated = 2;
        // // interface to legacy system for use in dynabuilt include files
        // session.pno = user.pno;
        // session.vwrCorelatno = Max(Session.vwrCoRelatNo,max(user.pvcorelatno, user.corelatno));


		if(structKeyExists(rc, 'destination'))
			variables.framework.redirectCustomURL( "/#rc.destination#" );
		else
        	variables.framework.redirectCustomURL( "/" );
    }

   
    function logout( rc ) {
        // tear down user session
        variables.userService.logout();
       // variables.userService.defaultUserSession();

        // reset session variables
        // session.auth.isLoggedIn = false;
        // session.auth.fullname = "";
        // // structdelete( session.auth, "user" );
        variables.framework.redirectCustomURL( "/");
    }

}