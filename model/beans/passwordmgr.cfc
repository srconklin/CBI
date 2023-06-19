component accessors=true extends="model.beans.common" {
    // accesstors 
	property pwd1;
	property pwd2;

    //optional
    property pno; // used for changing a password (lookup if user exists)
    property pwdcurrent; // used for changing a password
    property email; // used in resetpassword from forgotten password facility 

    // dependencies 
    property config;
    property userGateway;

        
    function isValid(){
        
        clearErrors();
        //base functionality of validating the password manager 
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
   

  private function persistPassword (){
    var result = variables.userGateway.updatePassword(getEmail(), getPwd1());

    if (!result.success) 
        variables.errors=result['errors'];
             
  }

  //  update password from myProfile -> changepassword.
  function changePassword() {   
        // see if user exists by pno
        var arUser = variables.userGateway.getUserbyPno(getPno());
        if (arUser.len() neq 1) 
            variables.errors['pwdcurrent']=config.getContent('setpassword', 'pnoNotFound').instruction;
        // next see if the current password is correct by checking credentials
        else {
            arUser = variables.userGateway.getUserbyCredentials(arUser[1].userID, getPwdCurrent());
            if (arUser.len() neq 1) 
                variables.errors['pwdcurrent']=config.getContent('setpassword', 'passwordnotcorrrect').instruction;
            // no errors; then make the change    
            else {
                // we have a pno, set an email so we can use persistspassword fn
                setEmail(arUser[1].email);
                persistPassword();
            }
            
        }
  }    

  //  update password from a user reset.
  function resetPassword() {   

        // see if user exists
        var arUser = variables.userGateway.getUserbyEmail(getEmail());
        if (arUser.len() neq 1) 
            variables.errors=config.getContent('setpassword', 'EmailNotFound').instruction;
        // if it does then update the password
        else 
            // email set exernally
            persistPassword();

    }

}