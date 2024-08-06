component accessors=true {

    property config;


	function getGeoByGID( required number GID ) {
		
        var params = {
            GID: arguments.GID,
        };
            
        var sql ='Select * FROM GeoData Where GID = :GID;'

        var arGeo = queryExecute( sql, params,  { returntype="array" });
        
        return arGeo;

	}		
	function toggleFavorite( required number itemno =0, required number pno, required boolean isfavorite ) {

		if(arguments.itemno gt 0 and arguments.pno gt 0) {
            
            cfstoredproc( procedure="setUserFavorites") {
                cfprocparam( cfsqltype="cf_sql_integer", value=arguments.itemno );
                cfprocparam( cfsqltype="cf_sql_integer", value=arguments.pno );
                cfprocparam( cfsqltype="cf_sql_bit", value=arguments.isfavorite?1:0);
            }
        }
	}		
	// function loadFavorite( required number itemno =0, required number pno) {

	// 	if(arguments.itemno gt 0 and arguments.pno gt 0) {
    //         var params = {
    //             itemno: arguments.itemno,
    //             pno: arguments.pno
    //         };
                
    //         var sql ='Select * FROM userFavorites Where itemno = :itemno and pno = :pno'
    
    //         var fav = queryExecute( sql, params,  { returntype="array" });
    //         if(arrayLen(fav))
    //             return 1;
    //         else 
    //             return 0;
           
    //     }
    //     return 0;
	//}		

	function getVenueContacts() {
		
        var params = {
            VTID: #config.getSetting('VTID')#,
        };
            
        var sql ='SELECT VV.AdmEmail as VenAdmEmail,VI.AdmEmail AS InvAdmEmail,VI.ccEmail,VV.LNm AS VenLNm 
                FROM CoVenues VV
                INNER JOIN CoVenues VI ON VI.VTID=VV.IVTID
                WHERE VV.VTID = :VTID'

        var arContacts = queryExecute( sql, params,  { returntype="array" });
        
        return arContacts[1];

	}					
}