component accessors=true extends="model.base.personal" {

  property itemno;
  property message;
  property utils;
  property config;
   
  function isValid(){
     // base handler for offer is the personal one. 
     // only called the isvalid on the base component  when the user is not logged in.
     if (session.pno eq 0)
        super.isValid();

    // message     
    if (! len(getMessage()))
      variables.errors["message"] = config.getContent('basicforms', 'missingMessage').instruction; 
    else if (utils.hasHTML(getMessage())) {
      variables.errors["message"] = config.getContent('basicforms', 'noHTML').instruction; 
    } else if (len(getMessage()) gt 250)  {
      variables.errors["message"] = config.getContent('basicforms', 'tooLong').instruction;
    }
      
    return structCount(variables.errors) ? false: true;
  }


}