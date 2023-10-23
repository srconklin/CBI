component accessors=true extends="model.beans.common" {
  
  // accessors
  property placesResponse;

  // private data
  variables.geoChain = [];

  // dependencies 
  property config;

  array function getGeoChain(){
    return variables.geoChain
  }

  function performLookup(){
    var geodata = '';

    try {

			form.placesResponse = getplacesResponse();
			include "/cbilegacy/legacySiteSettings.cfm";
			savecontent variable="geodata" {
				include "/websnips/geoProcess.cfm";
			}
      variables.geoChain = deserializeJSON(geodata).data;
        
		} catch (e) {
      setErrorState(e);
		}


  }
}