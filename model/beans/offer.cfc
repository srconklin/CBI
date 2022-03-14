component accessors=true extends="model.base.personal" {
	property itemno;
    property qtyStated;
    property priceStated;
	property terms;
	property message;
   
 
    function isValid( ){

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