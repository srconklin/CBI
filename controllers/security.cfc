component accessors=true {

    // function init( fw ) {
    //     variables.fw = fw;
	// }
	
	property framework;

	variables.secrurelist = 'main.about';
    function session( rc ) {
        // set up the user's session
        session.auth = {};
        session.auth.isLoggedIn = false;
        session.auth.fullname = '';
    }

    function authorize( rc ) {
		
		// if resource is not secured then just bail out of aothorize check
		if(!listfindnocase( variables.secrurelist, variables.framework.getFullyQualifiedAction() ))
			return;

		// check to make sure the user is logged on and skip exempt pages
        if ( not ( structKeyExists( session, "auth" ) && session.auth.isLoggedIn ) && 
             !listfindnocase( 'login', variables.framework.getSection() ) && 
             !listfindnocase( 'main.error', variables.framework.getFullyQualifiedAction() ) ) {
			rc.destination = variables.framework.getItem();	 
            variables.framework.redirectCustomURL('/login', 'destination' );
        }
    }

}