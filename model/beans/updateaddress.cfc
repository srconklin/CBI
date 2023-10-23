component accessors=true extends="model.beans.common" {
  
  // accessors
  property pno;
  property address1;
  property address2;
  property postalcode;
  property pLocGID;
  property pStPGID;
  property pCyGID;

  // private data

  // dependencies 
  property utils;
  property config;
  property userGateway;
  property generalGateway;


  function isValid(){
    
    if ( !len(getPno()) or getPno() lt 1) {
         setErrorState('pno', 'pnoNotFound');
    } 
    
    if ( !len(getAddress1()) ) {
        setErrorState('address1', 'missingAddress');
    }else if(utils.hasHTML(getAddress1())) {
        setErrorState('address1', 'noHTML');
    } else if(len(getAddress1()) gt 50)  {
        setErrorState('address1', 'addressTooLong');
    }

    if(utils.hasHTML(getAddress2())) {
        setErrorState('address2', 'noHTML');
    } else if(len(getAddress2()) gt 50)  {
        setErrorState('address2', 'addressTooLong');
    }
     
    if (!len(getPostalCode()) ) {
        setErrorState('postalcode', 'missingpostalcode');
    } else if(utils.hasHTML(getPostalCode())) {
        setErrorState('postalcode', 'noHTML');
    } else if(len(getPostalCode()) gt 20)  {
        setErrorState('postalcode', 'postalcodetoolong');
    }

    if ( !len(getPLocGID())) {
        setErrorState('PLocGID', 'missingLocGID');
    } else if(! isNumeric(getPLocGID()))  {
        setErrorState('PLocGID', 'invalidNumber');
    } else if(! isValidGID(getPLocGID()))  {
        setErrorState('PLocGID', 'InvalidGID');
    } 
    
    if ( len(getPStPGID())) {
      if(! isNumeric(getPStPGID()))  {
        setErrorState('PStPGID', 'invalidNumber');
      } else if(! isValidGID(getPStPGID()))  {
        setErrorState('PStPGID', 'InvalidGID');
      } 
    }
    
    if (!len(getPCyGID())) {
        setErrorState('PCyGID', 'missingCyGID');
    } else if(! isNumeric(getPCyGID()))  {
        setErrorState('PCyGID', 'invalidNumber');
    } else if(! isValidGID(getPCyGID()))  {
       setErrorState('PCyGID', 'InvalidGID');
    } 
     
      return !hasErrors();
  }

  private function isValidGID(required number GID) {
     return arrayLen(variables.generalGateway.getGeobyGID(arguments.GID)) ? true : false;
  }

  function update(){

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