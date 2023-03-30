component accessors=true extends="model.beans.common" {
    
	property email;

    function isValid( ){
        
        if(!len(getEmail())){
            variables.errors ='missingEmail';
        } else if (!isValid('email', getEmail())){
            variables.errors ='InvalidEmail';
        }    
        
        return len(variables.errors) ? false: true;
  }
  

}