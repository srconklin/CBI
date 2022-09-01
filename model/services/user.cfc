component accessors=true {

	property beanFactory;
	// the base sql string for all queries for all functions
	baseAuthUserSQL  = 'select p.Pno, p.userID, p.email, p.firstname, p.lastname, p.coname, p.phone1, p.regstat,
					ISNULL(PV.CoRelatNo, 0) as pvcorelatno,
					ISNULL(Permits.CoRelatNo,0) as corelatno,
					isnull(s.verifyVerified, 0) as verifyVerified, s.verifyHash, isnull(s.verifyDateTime, ''1990-01-01'') as verifyDateTime
					FROM people p 
					INNER join Permits PV ON PV.PNo = P.PNo AND PV.VTID=#application.VTID#	
					INNER JOIN Permits ON (Permits.PNo = P.PNo AND Permits.VTID IN (#application.VTID#,#application.COTID#,2))
					LEFT JOIN securityHashes s ON s.email = p.email
					WHERE deactivated is null ';
					
  
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
		structClear(session);
		this.defaultUserSession();

	}
	
	function elevateUserStatus( ) { 
		// under these conditions then authenticate fully; why do partial login only for users who have/can login?
		if(session.validated eq 1 and session.regstat eq 1){
			session.validated = 2;
		}
	}

	function syncValidatedUser( rc={}  ) { 
		var result = {};
		session.email = rc.email;
		session.avatar =  left(ucase(rc.firstname),1) &  left(ucase(rc.lastname),1);

		// switch over to fully authenticated under certain conditions
		elevateUserStatus();

		// some additional settings to determine if user is new, recognized or elevated
		session.isNewPerson = rc.newperson

		// return for payload use
		// result["isNewPerson"] = session.isNewPerson;
		// result["regstat"] =  session.regstat;
		result["firstName"] =  gettoken(session.name, 1, " ");

		if (session.isNewPerson)
			result["message"] =  'isNewPerson';
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
			isEmailVerified: (session.regstat or session.verifyVerified) ? true: false
		}

	}
    
    function validateUser( required string username,  required string password ) {
		
		// get a user bean
		//var user = variables.beanFactory.getBean( "userbean" );
		var user ='';
		
		var params = {
			username: arguments.username,
			password: hash(arguments.password)
		};
			
		var sql = baseAuthUserSQL & ' AND p.userID = :username and password = :password;'
		var arUser = queryExecute( sql, params,  { returntype="array" });
		// there should be only one row returned, but always take the first one if we somehow get more than one.

			
		if(arUser.len() eq 1) {
			user=arUser[1];
		}
			
        return user;
    }

	function resetForgotenPwd(required string email ) {

		var result = {};
		result['message']='';

		if (!isValid('email', arguments.email)) {
			result['message']='Invalid Email Address';
			return result;
		}	
	
		return result;

	}

	function resendLink( required string email ) {

		var result = {};
		result['success']=true;

		var params = {
			email: arguments.email
		};
			
		var sql = baseAuthUserSQL & ' AND p.email = :email'
											
		var qryEmail = queryExecute( sql, params);

		if (qryEmail.recordcount eq 0) {
			result['success']=false;
		
		} else {
			try {

				//interface with required variables
				variables.domain = cgi.https eq 'on'? 'https://' : "http://" & cgi.http_host;
				variables.aeskey = application.AESKey;
				form.email = qryEmail.email;
				form.firstname = qryEmail.firstname;
				form.lastname = qryEmail.lastname;
				// use procreg2 to only resend verify link
				form.resendVerifyLink = true;

				include "/cbilegacy/legacySiteSettings.cfm"
				include "/cbilegacy/procreg2.cfm"
				
			} catch (e) {
				response["result"] = false;
				writeDump(e);
				abort;
			}
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
			decryptedToken=decrypt(arguments.token, application.AESKey, "AES", "Base64")
			secretGuid = getToken(decryptedToken, 1, '|');
			email = getToken(decryptedToken, 2, '|');

		} catch (e) {
			secretGuid = '';
			email = '';

		}
		
		var params = {
			email: email
		};
			
		var sql = baseAuthUserSQL & ' AND p.email = :email'
						
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


}