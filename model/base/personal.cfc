component accessors=true {

    variables.errors = {};
    property firstName;
    property lastName;
    property email;
    property coname;
    property phone1 default='ns';
    property phone2 default='ns';
    property utilsService;
    
    
    function getErrors() {
        return errors;
    }

    function isValid( ){
     
    //var valid = true;
    structClear(variables.errors);

    //firstname 
    if ( !len(getFirstName()) ) {
        variables.errors["firstName"] = "This field is required";
    }else if(utilsService.hasHTML(getFirstName())) {
        variables.errors["firstName"] = "HTML not allowed";
    } else if(len(getFirstName()) gt 20)  {
        variables.errors["firstName"] = "first name too long";
    }

   //lastname 
   if ( !len(getlastName()) ) {
        variables.errors["lastName"] = "This field is required";
    } else if ( utilsService.hasHTML(getLastName())) {
        variables.errors["lastName"] = "HTML not allowed";
    } else if (len(getLastName()) gt 30)  {
        variables.errors["lastName"] = "last name too long";
    }

    //email 
    if ( !len(getEmail()) ) {
        variables.errors["email"] = "This field is required";
    } else if (!isValid('email', getEmail())) {
        variables.errors["email"] = "Not a valid email";
    } else if (len(getEmail()) gt 50)  {
        variables.errors["email"] = "email too long";
    }

    //company name
    if (utilsService.hasHTML(getConame())) {
        variables.errors["coname"] = "HTML not allowed";
    } else if (len(getConame()) gt 50)  {
        variables.errors["coname"] = "email too long";
    }

    //tel 
    // if phone1 is not equal to ns then we must be being supplied the phone1 form field otherwise we have to be getting a phone2
      if ( getPhone1() neq 'ns' ) {
        if ( !len(getPhone1()) ) {
            variables.errors["phone1"] = "a phone number is required";
        } else if (len(getPhone1()) gt 25)  {
            variables.errors["phone1"] = "phone too long";
        } else if (!isValid("regular_expression", getPhone1(), '^\+?\(?(?:([0-9]|\)(?!\)))[ \-\.]?){6,14}[0-9]$')) {
            variables.errors["phone1"] = "Not a valid phone number";
        }
    } else {
        if ( !len(getPhone2()) or getPhone2() eq 'ns' ) {
            variables.errors["phone2"] = "a phone number is required";
        } else if (len(getPhone2()) gt 25)  {
            variables.errors["phone2"] = "phone too long";
        } else if (!isValid("regular_expression", getPhone2(), '^\+?\(?(?:([0-9]|\)(?!\)))[ \-\.]?){6,14}[0-9]$')) {
            variables.errors["phone2"] = "Not a valid phone number";
        }
    }

        
    return structCount(variables.errors) ? false: true;
  }


}