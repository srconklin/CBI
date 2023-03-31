component accessors=true {

	property beanFactory;
	property config;

	function baseAuthUserSQL( ) {
		
		// the base sql string for all queries for all functions
		return 'select p.pno, p.userID, p.email, p.firstname, p.lastname, p.coname, p.phone1, p.regstat,
		ISNULL(PV.CoRelatNo, 0) as pvcorelatno,
		ISNULL(Permits.CoRelatNo,0) as corelatno,
		s.verifyVerified, s.verifyHash, isnull(s.verifyDateTime, ''1990-01-01'') as verifyDateTime,
		s.pwdVerified, s.pwdHash, isnull(s.pwdDateTime, ''1990-01-01'') as pwdDateTime		FROM people p 
		INNER join Permits PV ON PV.PNo = P.PNo AND PV.VTID=#config.getSetting('VTID')#	
		INNER JOIN Permits ON (Permits.PNo = P.PNo AND Permits.VTID IN (#config.getSetting('VTID')#,#config.getSetting('COTID')#,2))
		LEFT JOIN securityHashes s ON s.email = p.email
		WHERE deactivated is null ';
	}					

	
	function defaultUserSession( ) {
		// defult session
		session.validated=0;
		session.pno=0;
		session.vwrcorelatno=0;
		session.regstat=0;
		session.isNewPerson=0;
		session.name = '';
		session.email = '';
		session.avatar = '';
		session.verifyVerified=0;
	}

	function logout( ) {
		this.defaultUserSession();

	}
	
	function elevateUserStatus( ) { 
		// under these conditions then authenticate fully; why do partial login only for users who have/can login?
		if(session.validated eq 1 and session.regstat eq 1){
			session.validated = 2;
		}
	}

	function syncValidatedUser( user={}  ) { 
		var result = {};
		session.email = arguments.user.email;
		session.avatar =  left(ucase(arguments.user.firstname),1) &  left(ucase(arguments.user.lastname),1);

		// switch over to fully authenticated under certain conditions
		elevateUserStatus();

		// some additional settings to determine if user is new, recognized or elevated
		session.isNewPerson = arguments.user.newperson

		// return for payload use
		// result["isNewPerson"] = session.isNewPerson;
		// result["regstat"] =  session.regstat;
		result["firstName"] =  gettoken(session.name, 1, " ");

		if (session.isNewPerson)
			result["message"] =  'isNewPerson';
		else if (!session.regstat) 
	  		result["message"] = 'hasNotLoggedIn';
	  	else if (session.regstat)
		  result["message"] = 'loginviaForm';

		return result;
	}			
	 
	function setUserSession( user ={} ) {
           
		session.pno = user.pno;
		session.name =  user.firstname & " " & user.lastname;
		session.avatar =  left(ucase(user.firstname),1) &  left(ucase(user.lastname),1);
		session.email = user.email;
		session.verifyVerified = user.verifyVerified;
		session.regstat = user.regstat;
        session.vwrCorelatno = Max(session.vwrCoRelatNo,max(user.pvcorelatno, user.corelatno));
		// user logged in; 0 = guest, logged in = 2, recognized = 1
        session.validated = user.validated;
		
    }

    function isLoggedIn( ) {
		// definition of logged is recognized thru offer submit or user registration log in
		if(structKeyExists(session, 'pno') && session.validated gt 0) 
			return true;
		else 
			return false;

	}

	function getUserSession( ) {
		return {
			isLoggedIn : isLoggedIn(),
			name: session.name,
			avatar: session.avatar,
			email: session.email,
			pno: session.pno,
			isEmailVerified: (session.regstat or session.verifyVerified) ? true: false
		}

	}
	function getContactInfo(required numeric pno) {
		var user ='';
		
		var params = {
			pno: arguments.pno
		};
			
		var sql = baseAuthUserSQL() & ' AND p.pno = :pno '
		
		var arUser = queryExecute( sql, params,  { returntype="array" });
			
		if(arUser.len() eq 1) {
			user=arUser[1];
		}
			
        return user;

	}
    
    function validateUser( required string username,  required string password ) {
		
		// get a user bean
		//var user = variables.beanFactory.getBean( "userbean" );
		var user ='';
		
		var params = {
			username: arguments.username,
			password: hash(arguments.password)
		};
			
		var sql = baseAuthUserSQL() & ' AND p.userID = :username and password = :password;'
		
		var arUser = queryExecute( sql, params,  { returntype="array" });
		// there should be only one row returned, but always take the first one if we somehow get more than one.

			
		if(arUser.len() eq 1) {
			user=arUser[1];
		}
			
        return user;
    }

	// function resetForgotenPwd(required string email ) {

	// 	var result = {};
	// 	result['success']=true;

	// 	var params = {
	// 		email: arguments.email
	// 	};
			
	// 	var sql = baseAuthUserSQL() & ' AND p.email = :email'
	// 	var qryEmail = queryExecute( sql, params);

	// 	if (qryEmail.recordcount eq 0) {
	// 		result['success']=false;
		
	// 	} else {
			
	// 		try {

	// 			//interface with required variables
	// 			//var domain = cgi.https eq 'on'? 'https://' : "http://" & cgi.http_host;
	// 			// var aeskey = config.getSetting("AESKey");
	// 			form.email = qryEmail.email;
	// 			form.firstname = qryEmail.firstname;
	// 			form.lastname = qryEmail.lastname;

	// 			include "/cbilegacy/legacySiteSettings.cfm"
	// 			include "/cbilegacy/resetForgottenPwd.cfm"
				
	// 		} catch (e) {
	// 			result["success"] = false;
	// 			cfrethrow;
				
	// 		}
	// 	}

	// 	return result;

	// }

	function resendLink( required string email ) {

		var result = {};
		result['success']=true;

		var params = {
			email: arguments.email
		};
			
		var sql = baseAuthUserSQL() & ' AND p.email = :email'
		
											
		var qryEmail = queryExecute( sql, params);

		if (qryEmail.recordcount eq 0) {
			result['success']=false;
		
		} else {
			try {

				//interface with required variables
				var domain = cgi.https eq 'on'? 'https://' : "http://" & cgi.http_host;
			
				form.email = qryEmail.email;
				form.firstname = qryEmail.firstname;
				form.lastname = qryEmail.lastname;
				// use procreg2 to only resend verify link
				form.resendVerifyLink = true;

				include "/cbilegacy/legacySiteSettings.cfm"
				include "/cbilegacy/procreg2.cfm"
				
			} catch (e) {
				result["success"] = false;
				// writeDump(e);
			}
		}

		return result;


	}

	// decompose a token into eamil and secret GUID
	function decomposeToken(required string token) {
		var result = {
			secretGuid : '',
			email : ''
		};
		

		try {
			// replace the _ back with slashes
			arguments.token = replace(arguments.token, "_", "/", "all");
			var decryptedToken=decrypt(arguments.token, config.getSetting("AESKey"), "AES", "Base64")
			result.secretGuid = getToken(decryptedToken, 1, '|');
			result.email = getToken(decryptedToken, 2, '|');

		} catch (e) {
			result.secretGuid = '';
			result.email = '';
		}
		
		return result;
	}

	// verify password reset link is valid
	function verifyPwdReset(required string token) {

		var result = {};
		result['errors']='';
		// var email = '';
		// var secretGuid = '';

		var decomposedToken = decomposeToken(arguments.token);
		var params = {
			email: decomposedToken.email
		};
			
		var sql = baseAuthUserSQL() & ' AND p.email = :email'
		var arUser = queryExecute( sql, params, { returntype="array" });
	

		// email found in encryption package comes back as not being in the db. fishy or broken link
		if (arUser.len() neq 1) {
			result['errors']='passwordNotReset';
		// link expired
		} else if (datediff('n', arUser[1].pwdDateTime, now()) gt 120) {	
			result['errors']='passwordLinkExpired';
			result['email']=decomposedToken.email;
		// hash is invalid; something fishy
		} else if (! Argon2CheckHash( decomposedToken.secretGuid, arUser[1].pwdHash)) {
			result['errors']='passwordNotReset';
		}
		
		return result;


	}
	// verify email is secured by salted hash; we can return something back (pno) to be used to pass to other functions for longing in.
    function verifyEmail(required string token ) {
		var result = {};
		result['success']=true;
		var email = '';
		var secretGuid = '';

		try {
			// replace the _ back with slashes
			arguments.token = replace(arguments.token, "_", "/", "all");
			decryptedToken=decrypt(arguments.token, config.getSetting("AESKey"), "AES", "Base64")
			secretGuid = getToken(decryptedToken, 1, '|');
			email = getToken(decryptedToken, 2, '|');

		} catch (e) {
			secretGuid = '';
			email = '';

		}
		
		var params = {
			email: email
		};
			
		var sql = baseAuthUserSQL() & ' AND p.email = :email'
		
						
		var arUser = queryExecute( sql, params, { returntype="array" });
		
		// email found in encryption package comes back as not being in the db. fishy or broken link
		if (arUser.len() neq 1) {
			result['success']=false;
		// already verified	
		} else if (arUser[1].verifyVerified) {	
			result['success']=false;
			result['alreadyVerified']=true;
		// link expired
		} else if (datediff('n', arUser[1].verifyDateTime, now()) gt 60 ) {	
			result['success']=false;
			result['expired']=true;
			result['email']=email;
		// hash is invalid; something fishy
		} else if (! Argon2CheckHash( secretGuid, arUser[1].verifyHash)) {
			result['success']=false;
		} else {
			//update authentication bit for user
			sql = 'update securityHashes set verifyVerified=1, verifyHash=null, verifyGUID=null, verifyDateTime=null  WHERE email = :email'
			queryExecute( sql, {email: email});
			result['user']=arUser[1];
			// sync verified email status with db change above.

			result['user']['verifyVerified'] = 1;
		}

		return result;

	}

	// updatePassword
    function updatePassword(required string email, required string password ) {

		var result = {};
		result['success']=true;
			
		var params = {
			password:  hash(arguments.password),
			email: arguments.email
		};

		var sql = 'SET nocount on;
                   DECLARE @return smallint;
 				   IF EXISTS(SELECT pno from people WHERE email = :email)
				   BEGIN
				   	UPDATE people SET password= :password WHERE email = :email;
					UPDATE securityHashes set pwdVerified=1, pwdHash=null, pwdGUID=null, pwdDateTime=null  WHERE email = :email;
					SET @return = 1;
				   END
				   ELSE	
				   BEGIN
				   	SET @return = 0;
				   END
				SELECT @return as result;'
		try {
			var qry = queryExecute( sql, params);
			if (qry.result eq 0) {
				result['success']=false;
				result['errors']= config.getContent('setpassword', 'EmailNotFound').instruction;
			}
			
		}  catch (e) {
			result['success']=false;
			result['errors']=e.message;
		}
		
		return result;

	}

}