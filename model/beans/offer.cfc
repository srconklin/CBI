component accessors=true extends="model.base.personal" {
	property itemno;
    property qtyStated;
    property priceStated;
	property terms;
	property message;
	property utilsService;
   
    property config;
    
    function isValid( ){

       
     // base handler for offer is the personal one. 
     // only called the isvalid on the base component  when the user is not logged in.
     if (session.pno eq 0)
        super.isValid();
      
    
    //qty 
    if ( !len(getQtyStated()) ) {
        variables.errors["qtyStated"] = config.getContent('basicforms', 'qtyMissing').instruction;
    } else if (!isValid('Numeric', replaceNoCase(getQtyStated(), ',', ''))) {
        variables.errors["qtyStated"] = config.getContent('basicforms', 'invalidNumber').instruction; 
    } else if (getQtyStated() gt 9999)  {
        variables.errors["qtyStated"] = config.getContent('basicforms', 'maxQty').instruction;
    }

    
    // price
    if ( !len(getPriceStated()) ) {
        variables.errors["priceStated"] = config.getContent('basicforms', 'priceMissing').instruction; 
    } else if (!isValid('float', replaceNoCase(getPriceStated(), ',', ''))) {
        variables.errors["priceStated"] = config.getContent('basicforms', 'invalidPrice').instruction; 
    } else if (getPriceStated() gt 9999999)  {
        variables.errors["priceStated"] = config.getContent('basicforms', 'maxPrice').instruction; 
    }


    // message     
    if(utilsService.hasHTML(getMessage())) {
        variables.errors["message"] = config.getContent('basicforms', 'noHTML').instruction; 
    } else if (len(getMessage()) gt 250)  {
        variables.errors["message"] = config.getContent('basicforms', 'tooLong').instruction; 
    }

    // terms     
     if ( len(getTerms()) ) {
            if(utilsService.hasHTML(getTerms())) {
                variables.errors["terms"] = config.getContent('basicforms', 'noHTML').instruction; 
            } else if (len(getTerms()) gt 250)  {
                variables.errors["terms"] = config.getContent('basicforms', 'tooLong').instruction; 
            }
     }

    
    return structCount(variables.errors) ? false: true;
  }


}