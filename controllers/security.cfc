component accessors=true {
	property framework;
    property userService;
    property config;

    function session( rc ) {
        variables.userService.defaultUserSession();
    }
   
   	/******************************
	 authorize on every page request
     ******************************/
    function authorize( rc ) {
		
		// if resource is not secured then just bail out of auth check
		if(!listfindnocase(config.getSetting("securelist"), variables.framework.getFullyQualifiedAction() ))
			return;

		// check to make sure the user is logged on and skip exempt pages
        if (!rc.userSession.isloggedIn &&
             !listfindnocase( 'login', variables.framework.getSection() ) && 
             !listfindnocase( 'main.error', variables.framework.getFullyQualifiedAction() ) ) {
			rc.destination = variables.framework.getItem();	 
            variables.framework.redirectCustomURL('/login', 'destination' );
        }
    }

}