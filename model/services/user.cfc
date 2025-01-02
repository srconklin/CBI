component accessors=true {

	property beanFactory;
	property config;
	property utils;
	property userGateway;


	function defaultUserSession( ) {
		 // get the bean 
		 var user = variables.beanFactory.getBean( 'userBean' );
		param name="session.user" default={};
		setUserSession(user.getUserData());
		
	}

	function getUserSession( ) {
		var userSession = session.user;

		structAppend(userSession, {
			isLoggedIn : isLoggedIn(),
			name: session.user.firstname & " " & session.user.lastname,
			isEmailVerified: (session.user.verifyVerified eq 1 or session.user.regstat gt 0) ? true: false,
			hasPassword: (session.user.pwdVerified eq 1 or session.user.regstat gt 0) ? true: false,
			avatar: left(ucase(session.user.firstname),1) &  left(ucase(session.user.lastname),1)
		}, true);

		return userSession;

	}

	function setUserSession( user ={} ) {
		structAppend(session.user, arguments.user, true);
    }

	function logout( ) {
		structClear(session);
		defaultUserSession();
	}
	
	/*
		definition of logged in is recognized thru 
		offer submit  validated=1
		or user registration validated=2
	*/
    private function isLoggedIn( ) {
		return structkeyExists(session.user, 'validated') and session.user.validated ? true : false;
	}

	
	function getUserFromDb(string email = '') {
		var user = variables.beanFactory.getBean( 'userbean' );
		user.refreshUserfromDB(arguments.email);
		return user.getUserData();
	
	}
	
}