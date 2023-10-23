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

	function getUserbyPno( required numeric pno) {
            
        var params = {
            pno: arguments.pno
        };
            
        var sql = getBaseUserQuery() & ' AND p.pno = :pno;'

        var arUser = queryExecute( sql, params,  { returntype="array" });
        
        return arUser;
      
    }
	function getUserPrimaryAddress( required numeric pno) {
            
        var params = {
            pno: arguments.pno
        };
            
        var sql = ' select [pno], [Street1] ,[Street2],  [PostalCode], [CityTxt], [StateTxt], [CountryTxt], [LocGID], [StPGID], [CyGID]  
					FROM addresses where bprimary = 1 and pno = :pno; '

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
				result['errors']=e;
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
					UPDATE securityHashes set verifyVerified=1, verifyHash=null, 
					verifyGUID=null, verifyDateTime=null  WHERE email = :email;'
			
			try {
				var qry = queryExecute( sql, params);
				
			}  catch (e) {
				result['success']=false;
				result['errors']=e;
			}

			return result;
				
	}


	function updatePassword(required string email,  required string password ) {
		var result = {};
    	result['success']=true;
		result['errors']='';

		
			try {

				var params = {
					password:  hash(arguments.password),
					email: arguments.email
				};
		
				var sql = 'SET nocount on;
						   UPDATE people SET password= :password WHERE email = :email;'
			
						   
				var qry = queryExecute( sql, params);
				
			}  catch (e) {
				result['success']=false;
				result['errors']=e;
			}

			return result;
	}

	function saveAddress(required number pno, required string street1, required string street2, required string postalcode, required number LocGID) {
		var result = {};
    	result['success']=true;
		result['errors']='';
		
		try {

			variables.cityGID = arguments.LocGID;
				
			include "/cbilegacy/legacySiteSettings.cfm"
			include "/serversnips/getgeoHierarchy.cfm"
				
		var params = {
			Pno : {value=arguments.pno, cfsqltype="integer"},
				street1:  {value=arguments.street1, cfsqltype="varchar"},
				street2:  {value=arguments.street2, cfsqltype="varchar"},
				postalcode:  {value=arguments.postalcode, cfsqltype="varchar"},
				locGID:  {value=geoDataPacket.City_GID, cfsqltype="integer"},
				StPGID:  {value=geoDataPacket.state_GID, cfsqltype="integer"},
				CyGID:  {value=geoDataPacket.Country_GID, cfsqltype="integer"},
				CityTxt:  {value=geoDataPacket.city, cfsqltype="varchar"},
				StateTxt:  {value=geoDataPacket.state, cfsqltype="varchar"},
				CountryTxt:  {value=geoDataPacket.country, cfsqltype="varchar"}
		};
		
		

		var sql = 'SET nocount on;
				   UPDATE addresses
				   SET 
				   street1= :street1,
				   street2= :street2,
				   postalcode= :postalcode,
				   locGID= :locGID,
				   StPGID= :StPGID,
				   CyGID= :CyGID,
				   CityTxt= :CityTxt,
				   StateTxt= :StateTxt,
				   CountryTxt= :CountryTxt
    			   WHERE pno = :pno;'
		
		var qry = queryExecute( sql, params);
			
		}  catch (e) {
			result['success']=false;
			result['errors']=e;
		}

		return result;
	}
}