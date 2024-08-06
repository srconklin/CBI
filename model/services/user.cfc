component accessors=true {

	property beanFactory;
	property config;
	property utils;
	property userGateway;


	function defaultUserSession( ) {
		 // get the bean 
		 var user = variables.beanFactory.getBean( 'userBean' );
		 //structAppend(session, {user: user.getUserData()}, true);
		// session.user = user.getUserData();
		param name="session.user" default={};
		setUserSession(user.getUserData());
		
	}

	function getUserSession( ) {
		var userSession = duplicate(session.user);

		structAppend(userSession, {
			isLoggedIn : isLoggedIn(),
			name: session.user.firstname & " " & session.user.lastname,
			isEmailVerified: (session.user.verifyVerified or session.user.regstat gt 0) ? true: false,
			hasPassword: (session.user.pwdVerified or session.user.regstat gt 0) ? true: false,
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
	
    private function isLoggedIn( ) {
		// definition of logged is recognized thru offer submit or user registration log in
		// validated 1 or 2
		return structkeyExists(session.user, 'validated') and session.user.validated ? true : false;

	}
	function updateUserState(string email = '', state= {}) {
		var user = variables.beanFactory.getBean( 'userbean' );
		user.refreshUserfromDB(arguments.email);
		if(!structIsEmpty(arguments.state))
			user.addUserData(arguments.state);
		setUserSession(user.getUserData());
	}
	
	
}