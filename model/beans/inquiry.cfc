component accessors=true extends="model.base.personal" {
	property itemno;
    property message;
   
 
    function isValid( ){
     // base handler for offer is the personal one. 
     // only called the isvalid on the base component  when the user is not logged in.
     if (session.pno eq 0)
        super.isValid();
    
    return structCount(variables.errors) ? false: true;
  }


}