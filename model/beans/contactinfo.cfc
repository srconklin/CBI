component accessors=true extends="model.base.personal" {
	property password;

  function isValid( ){
      
         super.isValid();  
    
        return structCount(variables.errors) ? false: true;
  }

}