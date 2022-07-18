component accessors=true extends="model.base.personal" {

  property itemno;
  property message;

  property utilsService;

   
  function isValid( ){
     // base handler for offer is the personal one. 
     // only called the isvalid on the base component  when the user is not logged in.
     if (session.pno eq 0)
        super.isValid();

    // message     
    if (! len(getMessage()))
      variables.errors["message"] = "You must enter a message";
    else if (utilsService.hasHTML(getMessage())) {
      variables.errors["message"] = "HTML not allowed";
    } else if (len(getMessage()) gt 250)  {
      variables.errors["message"] = "input too long";
    }
      
    return structCount(variables.errors) ? false: true;
  }


}