component accessors=true {

    variables.errors = {};

	property itemno;
    property qtyStated;
    property priceStated;
	property terms;
	property message;
    property firstName;
    property lastName;
    property email;
    property company;
    property phone1;
    
    
    function getErrors() {
        return errors;
    }

    function isValid( ){
          
    //var valid = true;
    structClear(variables.errors);
    
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

    //firstname 
    if ( !len(getFirstName()) ) {
        variables.errors["firstName"] = "This field is required";
    }

   //lastname 
   if ( !len(getlastName()) ) {
        variables.errors["lastName"] = "This field is required";
    }

    //email 
    if ( !len(getEmail()) ) {
        variables.errors["email"] = "This field is required";
    } else if (!isValid('email', getEmail())) {
        variables.errors["email"] = "Not a valid email";
    }

    //tel 
    if ( !len(getPhone1()) ) {
        variables.errors.phone1 = "This field is required";

        //
        //^\+?[0-9 \-()\.]{6,14}$
    } else if (!isValid("regular_expression", getPhone1(), '^\+?\(?(?:([0-9]|\)(?!\)))[ \-\.]?){6,14}[0-9]$')) {
        variables.errors.phone1 = "Not a valid phone number";
    }

    return structCount(variables.errors) ? false: true;
  }


}