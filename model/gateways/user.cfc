component accessors=true {

	property config;

	function getBaseUserQuery( ) {
		
		// the base sql string for all USER based queries
		return 'select distinct  p.pno, p.userID, p.email, p.firstname, p.lastname, p.coname, p.phone1, p.regstat,
		ISNULL(PV.CoRelatNo, 0) as pvcorelatno,
		ISNULL(Permits.CoRelatNo,0) as corelatno,
		s.verifyVerified, s.verifyHash, isnull(s.verifyDateTime, ''1990-01-01'') as verifyDateTime,
		s.pwdVerified, s.pwdHash, isnull(s.pwdDateTime, ''1990-01-01'') as pwdDateTime	
		FROM people p 
		INNER join Permits PV ON PV.PNo = P.PNo AND PV.VTID=#config.getSetting('VTID')#	
		INNER JOIN Permits ON (Permits.PNo = P.PNo AND Permits.VTID IN (#config.getSetting('VTID')#,#config.getSetting('COTID')#,2))
		LEFT JOIN securityHashes s ON s.email = p.email
		WHERE deactivated is null ';
	}					

    function getUserbyCredentials( required string username,  required string password ) {
            
        var params = {
            username: arguments.username,
            password: hash(arguments.password)
        };
            
        var sql = getBaseUserQuery() & ' AND p.userID = :username and password = :password;'

        var arUser = queryExecute( sql, params,  { returntype="array" });
        
        return arUser;
      
    }

	function getUserbyEmail( required string email) {
            
        var params = {
            email: arguments.email
        };
            
        var sql = getBaseUserQuery() & ' AND p.email = :email;'

        var arUser = queryExecute( sql, params,  { returntype="array" });
        
        return arUser;
      
    }

    function getContactInfo(required numeric pno) {
		var user ='';
		
		var params = {
			pno: arguments.pno
		};
			
		var sql = getBaseUserQuery() & ' AND p.pno = :pno '
		
		var arUser = queryExecute( sql, params,  { returntype="array" });
			
		if(arUser.len() eq 1) {
			user=arUser[1];
		}
			
        return user;

	}

	
	function markPasswordVerified(required string email ) {
		var result = {};
    	result['success']=true;
		result['errors']='';

		
		var params = {
			email: arguments.email
		};

		var sql = 'SET nocount on;
					UPDATE securityHashes set pwdVerified=1, pwdHash=null, pwdGUID=null, pwdDateTime=null  WHERE email = :email;'
			
			try {
				var qry = queryExecute( sql, params);
				
			}  catch (e) {
				result['success']=false;
				result['errors']=e.message;
			}

			return result;
				
	}

	function markEmailVerified(required string email ) {
		var result = {};
    	result['success']=true;
		result['errors']='';

		
		var params = {
			email: arguments.email
		};

		var sql = 'SET nocount on;
					UPDATE securityHashes set verifyVerified=1, verifyHash=null, verifyGUID=null, verifyDateTime=null  WHERE email = :email;'
			
			try {
				var qry = queryExecute( sql, params);
				
			}  catch (e) {
				result['success']=false;
				result['errors']=e.message;
			}

			return result;
				
	}


	function updatePassword(required string email,  required string password ) {
		var result = {};
    	result['success']=true;
		result['errors']='';

		
		var params = {
			password:  hash(arguments.password),
			email: arguments.email
		};

		var sql = 'SET nocount on;
				   UPDATE people SET password= :password WHERE email = :email;'
			
			try {
				var qry = queryExecute( sql, params);
				
			}  catch (e) {
				result['success']=false;
				result['errors']=e.message;
			}

			return result;
	}
}