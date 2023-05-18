component accessors=true {

	property beanFactory;
	property config;
	property utils;


	function defaultUserSession( ) {
		 // get the bean 
		 var user = variables.beanFactory.getBean( 'userBean' );
		 structAppend(session, user.getUserData(), true);
		
	}

	function getUserSession( ) {
		return {
			isLoggedIn : isLoggedIn(),
			name: session.firstname & " " & session.lastname,
			firstName : session.firstname,
			avatar: left(ucase(session.firstname),1) &  left(ucase(session.lastname),1),
			email: session.email,
			pno: session.pno,
			validated: session.validated,
			vwrcorelatno: session.vwrcorelatno,
			isEmailVerified: (session.regstat or session.verifyVerified) ? true: false
		}

	}

	function setUserSession( user ={} ) {
		structAppend(session, user, true);
    }

	function logout( ) {
		defaultUserSession();
	}
	
    private function isLoggedIn( ) {
		// definition of logged is recognized thru offer submit or user registration log in
		return session.validated ? true : false;

	}
	
	
}