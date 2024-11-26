component accessors=true extends="model.beans.personal" {
    //accessors
    property refnr;
	property message;
 	
    //dependencies
    property utils;
    property config;
    property userService;
    
    
    function isValid( ){

        if (!hiddenNotValid())
            return false;
  
         // message required on inquiry only  
        if (!len(getMessage()) ) {
            setErrorState('missingMessage', 'message');
        }  
        else if(utils.hasHTML(getMessage())) {
            setErrorState('noHTML', 'message');
        } else if (len(getMessage()) gt 250)  {
            setErrorState('tooLong', 'message');
        }
        
        return !hasErrors();
  }

  function hiddenNotValid( ){

  
     //refnr 
     if ( !len(getRefNr()) or getRefNr() eq 0 ) {
        setErrorState('badrefnr'); 
    } else if (!isValid('Numeric', replaceNoCase(getRefNr(), ',', ''))) {
        setErrorState('badrefnr'); 
    }

    return !hasErrors();

  }

  function offerSentSuccesfully() {
    return (hasErrors() or !variables.offerSent) ? false: true;
  }
    
  function sendMessage(){

    if (!this.isValid()) return;

    var arUser = variables.userGateway.getUserbyPno(getPno());
    if (arUser.len() neq 1) 
        setErrorState('pnoNotFound', 'pno');
    else {
    
        var result = variables.userGateway.saveAddress(getPNO(), getaddress1(), getaddress2(), getPostalCode(), getPLocGID());

        if (!result.success) 
            setErrorState(result['error']);
    }    
    
  }



}