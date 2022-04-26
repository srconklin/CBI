component accessors=true extends="model.base.personal" {
	property itemno;
    property qtyStated;
    property priceStated;
	property terms;
	property message;
   
 
    function isValid( ){
     // base handler for offer is the personal one. 
     // only called the isvalid on the base component  when the user is not logged in.
     if (session.pno eq 0)
        super.isValid();
         
    
    //qty 
    if ( !len(getQtyStated()) ) {
        variables.errors["qtyStated"] = "This field is required";
    }
    
    // price
    if ( !len(getPriceStated()) ) {
        variables.errors["priceStated"] = "this field is required";
    } else if (!isValid('float', replaceNoCase(getPriceStated(), ',', ''))) {
        variables.errors["priceStated"] = "not a valid price";
    }

    
    return structCount(variables.errors) ? false: true;
  }


}