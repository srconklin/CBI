component accessors=true {

    variables.errors = {};
    property firstName;
    property lastName;
    property email;
    property coname;
    property phone1 default='ns';
    property phone2 default='ns';
    property utils;

    function isValid(){
     
        //var valid = true;
        structClear(variables.errors);

        //firstname 
        if ( !len(getFirstName()) ) {
            variables.errors["firstName"] =  config.getContent('basicforms', 'missingFirstName').instruction; 
        }else if(utils.hasHTML(getFirstName())) {
            variables.errors["firstName"] = config.getContent('basicforms', 'noHTML').instruction; 
        } else if(len(getFirstName()) gt 20)  {
            variables.errors["firstName"] = config.getContent('basicforms', 'firstNameToolong').instruction; 
        }

        //lastname 
        if ( !len(getlastName()) ) {
            variables.errors["lastName"] = config.getContent('basicforms', 'missingLastName').instruction; 
        } else if ( utils.hasHTML(getLastName())) {
            variables.errors["lastName"] = config.getContent('basicforms', 'noHTML').instruction; 
        } else if (len(getLastName()) gt 30)  {
            variables.errors["lastName"] = config.getContent('basicforms', 'lastNameToolong').instruction; 
        }

        //email 
        if ( !len(getEmail()) ) {
            variables.errors["email"] = config.getContent('basicforms', 'missingEmail').instruction; 
        } else if (!isValid('email', getEmail())) {
            variables.errors["email"] = config.getContent('basicforms', 'invalidEmail').instruction; 
        } else if (len(getEmail()) gt 50)  {
            variables.errors["email"] = config.getContent('basicforms', 'emailToolong').instruction; 
        }

        //company name
        if (utils.hasHTML(getConame())) {
            variables.errors["coname"] = config.getContent('basicforms', 'noHTML').instruction; 
        } else if (len(getConame()) gt 50)  {
            variables.errors["coname"] = config.getContent('basicforms', 'companyToolong').instruction; 
        }

        //tel 
        // if phone1 is not equal to ns then we must be being supplied the phone1 form field otherwise we have to be getting a phone2
        if ( getPhone1() neq 'ns' ) {
            if ( !len(getPhone1()) ) {
                variables.errors["phone1"] = config.getContent('basicforms', 'missingPhone').instruction; 
            } else if (len(getPhone1()) gt 25)  {
                variables.errors["phone1"] = config.getContent('basicforms', 'phoneToolong').instruction; 
            } else if (!isValid("regular_expression", getPhone1(), '^\+?\(?(?:([0-9]|\)(?!\)))[ \-\.]?){6,14}[0-9]$')) {
                variables.errors["phone1"] =config.getContent('basicforms', 'invalidPhone').instruction; 
            }
        } else {
            if ( !len(getPhone2()) or getPhone2() eq 'ns' ) {
                variables.errors["phone2"] = config.getContent('basicforms', 'missingPhone').instruction; 
            } else if (len(getPhone2()) gt 25)  {
                variables.errors["phone2"] = config.getContent('basicforms', 'phoneToolong').instruction; 
            } else if (!isValid("regular_expression", getPhone2(), '^\+?\(?(?:([0-9]|\)(?!\)))[ \-\.]?){6,14}[0-9]$')) {
                variables.errors["phone2"] = config.getContent('basicforms', 'invalidPhone').instruction; 
            }
        }

            
        return structCount(variables.errors) ? false: true;
  }


}