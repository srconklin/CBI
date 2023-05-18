component accessors=true extends="model.beans.common" {
    // accesstors 
	property pwd1;
	property pwd2;
    property email;

    // dependencies 
    property config;
    property userGateway;

        
    function isValid(){
        
        clearErrors();
        
        if(!len(getPwd1())){
            variables.errors["pwd1"] =config.getContent('setpassword', 'missingPassword').instruction;
        } else if (!len(getPwd2())){
            variables.errors["pwd2"] = config.getContent('setpassword', 'missingConfirmationPassword').instruction;
        } else if (!refind("[a-z]", getPwd1()))  {
            variables.errors["pwd1"] =config.getContent('setpassword', 'nolowercase').instruction;
        } else if (!refind("[A-Z]", getPwd1()))  {
            variables.errors["pwd1"] =config.getContent('setpassword', 'nouppercase').instruction;
        } else if (!refind("[0-9]", getPwd1()))  {
            variables.errors["pwd1"] =config.getContent('setpassword', 'nodigit').instruction;
        } else if (len(getPwd1()) lt 8)  {
            variables.errors["pwd1"] =config.getContent('setpassword', 'tooshort').instruction;
        } else if ( compare(getPwd1(),getPwd2()) neq 0 ) {
            variables.errors["pwd2"] =config.getContent('setpassword', 'passwordsDoNotMatch').instruction;
        }

        return len(variables.errors) ? false: true;
  }

    

  //  update password from a user reset.
  function updatePassword() {   

        // see if user exists
        var arUser = variables.userGateway.getUserbyEmail(getEmail());
        if (arUser.len() neq 1) 
            variables.errors=config.getContent('setpassword', 'EmailNotFound').instruction;

        // if it does then update the password
        else {
            var result = variables.userGateway.updatePassword(getEmail(), getPwd1());

            if (!result.success) 
                variables.errors=result['errors'];
                         
           
        }

    }

 

}