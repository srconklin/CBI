component accessors=true {
	property framework;
    property userService;

	variables.secrurelist = 'main.about';
    function session( rc ) {
        // set up the user's session
        // session.auth = {};
        // session.auth.isLoggedIn = false;
        // session.auth.fullname = '';
        // the default user session
        variables.userService.defaultUserSession();
    }

    function authorize( rc ) {
		
		// if resource is not secured then just bail out of auth check
		if(!listfindnocase( variables.secrurelist, variables.framework.getFullyQualifiedAction() ))
			return;

		// check to make sure the user is logged on and skip exempt pages
        // if ( not ( structKeyExists( session, "auth" ) && session.auth.isLoggedIn ) && 
        if (!variables.userService.isloggedIn() &&
        // if ( not ( structKeyExists( session, "auth" ) && session.auth.isLoggedIn ) && 
             !listfindnocase( 'login', variables.framework.getSection() ) && 
             !listfindnocase( 'main.error', variables.framework.getFullyQualifiedAction() ) ) {
			rc.destination = variables.framework.getItem();	 
            variables.framework.redirectCustomURL('/login', 'destination' );
        }
    }

}