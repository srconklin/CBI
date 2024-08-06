component accessors=true extends="model.beans.common" {
    // accessors 
	property bcast;
    property pno; 
    // dependencies 
    property userGateway;
        
    function isValid(){
        return true;
   }
   

  function updateCommPref() {   

      if ( !len(getPno()) or getPno() lt 1) {
        setErrorState('pnoNotFound', 'updatecommpref');
      } else { 

        var result = variables.userGateway.updateCommPref(getPno(), getBcast());

        if (!result.success) 
          setErrorState(result['errors']);
      
    }    
  }    


}