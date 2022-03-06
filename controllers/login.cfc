component accessors=true {

	property framework;
    property userService;

    // function init( fw ) {
    //     variables.framework = fw;
    //     return this;
    // }

	
	public void function default(struct rc = {}) {
		request.layout =false;
	}


    function before( rc ) {
        if ( structKeyExists( session, "auth" ) && session.auth.isLoggedIn &&  variables.framework.getItem() != "logout" ) {
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
        // set session variables from valid user
        session.auth.isLoggedIn = true;
        session.auth.fullname = user.firstname & " " & user.lastname;
        session.auth.user = user;

		if(structKeyExists(rc, 'destination'))
			variables.framework.redirectCustomURL( "/#rc.destination#" );
		else
        	variables.framework.redirectCustomURL( "/" );
    }

    function logout( rc ) {
        // reset session variables
        session.auth.isLoggedIn = false;
        session.auth.fullname = "";
        structdelete( session.auth, "user" );
        variables.framework.redirectCustomURL( "/");
    }

}