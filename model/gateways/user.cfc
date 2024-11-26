component accessors=true {

	property config;
	property generalGateway;

	function getBaseUserQuery( ) {
		
		// the base sql string for all USER based queries
		return 'select distinct  p.pno, p.userID, p.email, p.firstname, p.lastname, p.coname, p.phone1, p.regstat,
		ISNULL(PV.CoRelatNo, 0) as pvcorelatno,
		ISNULL(Permits.CoRelatNo,0) as corelatno,
		PV.bcast,
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

	function getUserFavorites( required numeric pno) {
            
        var params = {
            pno: arguments.pno
        };
            
        var sql = ' select Itemno FROM userfavorites where pno = :pno; '

        var arUser = queryExecute( sql, params,  { returntype="array" });

		
		// turn a std lucee query of array object into a plain array of itemnos
		items = arrayMap( arUser, function(ele){
			return ele.itemno;
		 });
        
        return items;
      
    }

	function getOffers( required numeric pno) {
            
        var params = {
            pno: { value=arguments.pno,	cfsqltype="integer"}
        };
            
        var sql = "SELECT 
				T.TransNo as refnr,
				CASE WHEN T.TTypeNo = 11 THEN 'Offer'  ELSE 'Inquiry' end as type,
				FORMAT(T.TransDate, 'MMM dd yyyy h:mm tt') as date,
				I.ItemNo as itemno, 
				I.Headline as description,
				CASE when t2.transno is null then 'Pending' else 'Answered' end as status
				FROM Transactions T
				LEFT JOIN Transactions T2 on T2.LinkedTrans = T.linkedtrans and T2.LastLink = 1 and T2.InitPno <> T.InitPNo
				INNER JOIN Items I on I.ItemNo=T.ItemNo
				WHERE T.InitPNo= :pno 
				AND T.VTID = #config.getSetting('VTID')#
				AND T.LinkedTrans = t.TransNo
				AND T.TTypeNo in (10,11,12)
				ORDER BY T.TransNo DESC";

        var arofTrans = queryExecute( sql, params,  { returntype="array" });
        return  arofTrans;
      
    }
	
	function getOfferDetails( required numeric refnr) {
            
        var params = {
            refnr: { value=arguments.refnr, cfsqltype="integer"}
        };
            
        var sql = "SELECT 
			T.TransNo as refnr, T.message, T.terms, t.pricestated, t.qtystated,
			T.transdir,
			CASE WHEN T.TTypeNo = 11 THEN 'Offer'  ELSE 'Inquiry' end as type,
			FORMAT(T.TransDate, 'MMM dd yyyy h:mm tt') as date,
			I.ItemNo as itemno, 
			I.Headline as description,
			Case when t.lastlink =1  THEN 
				Case when  t.transdir = 1 then 'Answered' else 'Pending' END
			ELSE 
				'NA'end as status
			FROM Transactions T
			INNER JOIN Items I on I.ItemNo=T.ItemNo
			WHERE T.Linkedtrans= :refnr AND T.VTID IN (#config.getSetting('VTID')#,#config.getSetting('IVTID')#)
			ORDER BY T.TransNo desc";

        var arofTrans = queryExecute( sql, params,  { returntype="array" });
        return  arofTrans;
      
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


	function createTT5Message(required numeric refnr, required numeric itemno, required string message, required numeric pno) {

		var result = {};
    	result['success']=true;
		result['errors']='';

		// we need to retrieve the recippno
		var MsgToPNo = variables.generalGateway.getInvPnoforItem(arguments.itemno);
		
		var params = {
			refnr: arguments.refnr,
			pno: arguments.pno,
			message: arguments.message
		};

		var sql = "SET nocount on;
					INSERT INTO Transactions
					(LinkedTrans,LastLink,InitPNo,RecipPNo,
					cotid,VTID,DataTID,TransDir,TransType,TTypeNo,TStatusNo,TDispTypeNo,
					ListNo,ItemNo,ItemEditDt,
					QtyShown,PriceShown,QtyStated,PriceStated,SideStated,Priunit,Message)
					SELECT
					LinkedTrans,1,:pno,#MsgToPNo#,
					cotid,VTID,dataTID,0,'Message',5,TStatusNo,TDispTypeNo,
					ListNo,ItemNo,ItemEditDt,
					QtyShown,PriceShown,QtyStated,PriceStated,0,priunit,:Message
					FROM Transactions
					WHERE TransNo=:refnr AND ArchDt IS NULL;

					UPDATE Transactions SET LastLink=0 WHERE TransNo =:refnr;
					";
			
			try {
				var qry = queryExecute( sql, params);
				
			}  catch (e) {
				result['success']=false;
				result['errors']=e;
			}

			return result;

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

	function markUserFullyValidated(required string email ) {
		var result = {};
    	result['success']=true;
		result['errors']='';

		
		var params = {
			email: arguments.email
		};

		var sql = 'SET nocount on;
					UPDATE people set regstat=1 
					WHERE email = :email;'
			
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
					verifyGUID=null, verifyDateTime=getDate()  WHERE email = :email;'
			
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
	function updateCommPref(required number pno, required binary bcastSetting ) {
		var result = {};
    	result['success']=true;
		result['errors']='';
		
			try {

				var params = {
					pno : {value=arguments.pno, cfsqltype="integer"},
					bcast : {value=arguments.bcastSetting, cfsqltype="bit"},
				};
		
				var sql = 'SET nocount on;
						   UPDATE permits SET bcast= :bcast WHERE pno = :pno and vtid = #config.getSetting('VTID')#	;'
			
						   
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