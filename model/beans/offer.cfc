component accessors=true extends="model.base.personal" {
	property itemno;
    property qtyStated;
    property priceStated;
	property terms;
	property message;
	property utilsService;
   
 
    function isValid( ){

       
     // base handler for offer is the personal one. 
     // only called the isvalid on the base component  when the user is not logged in.
     if (session.pno eq 0)
        super.isValid();
      
    
    //qty 
    if ( !len(getQtyStated()) ) {
        variables.errors["qtyStated"] = "This field is required";
    } else if (!isValid('Numeric', replaceNoCase(getQtyStated(), ',', ''))) {
        variables.errors["qtyStated"] = "not a valid number";
    } else if (getQtyStated() gt 9999)  {
        variables.errors["qtyStated"] = "Price max reached";
    }

    
    // price
    if ( !len(getPriceStated()) ) {
        variables.errors["priceStated"] = "this field is required";
    } else if (!isValid('float', replaceNoCase(getPriceStated(), ',', ''))) {
        variables.errors["priceStated"] = "not a valid price";
    } else if (getPriceStated() gt 9999999)  {
        variables.errors["priceStated"] = "Price max reached.";
    }


    // message     
    if(utilsService.hasHTML(getMessage())) {
        variables.errors["message"] = "HTML not allowed";
    } else if (len(getMessage()) gt 250)  {
        variables.errors["message"] = "input too long";
    }

    // terms     
     if ( len(getTerms()) ) {
            if(utilsService.hasHTML(getTerms())) {
                variables.errors["terms"] = "HTML not allowed";
            } else if (len(getTerms()) gt 250)  {
                variables.errors["terms"] = "input too long";
            }
     }

    
    return structCount(variables.errors) ? false: true;
  }


}