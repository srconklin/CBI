component accessors=true extends="model.base.personal" {
	property password;
    
    function isValid( ){
         super.isValid();  
        
         
    //password
    if ( !len(getPassword()) ) {
        variables.errors["password"] = "This field is required";
    }
       
    
    return structCount(variables.errors) ? false: true;
  }


}