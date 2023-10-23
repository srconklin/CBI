component accessors=true {

	function getGeoByGID( required number GID ) {
		
        var params = {
            GID: arguments.GID,
        };
            
        var sql ='Select * FROM GeoData Where GID = :GID;'

        var arGeo = queryExecute( sql, params,  { returntype="array" });
        
        return arGeo;

	}					
}