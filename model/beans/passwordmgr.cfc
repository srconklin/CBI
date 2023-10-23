component accessors=true extends="model.beans.common" {
    // accesstors 
	property pwd1;
	property pwd2;

    //optional
    property pno; // used for changing a password (lookup if user exists)
    property pwdcurrent; // used for changing a password
    property email; // used in resetpassword from forgotten password facility (also needed in changepassword)

    // dependencies 
    property userGateway;
        
    function isValid(){
        
        clearErrors();
        //base functionality of validating the password manager 
        if(!len(getPwd1())){
            setErrorState('missingpassword', 'pwd1');
        } else if (!len(getPwd2())){
            setErrorState('missingConfirmationPassword', 'pwd2');
        } else if (!refind("[a-z]", getPwd1()))  {
            setErrorState('nolowercase', 'pwd1');
        } else if (!refind("[A-Z]", getPwd1()))  {
            setErrorState('nouppercase', 'pwd1');
        } else if (!refind("[0-9]", getPwd1()))  {
            setErrorState('nodigit', 'pwd1');
        } else if (len(getPwd1()) lt 8)  {
            setErrorState('tooshort', 'pwd1');
        } else if (len(getPwd1()) gt 20)  {
            setErrorState('toolong', 'pwd1');
        } else if ( compare(getPwd1(),getPwd2()) neq 0 ) {
            setErrorState('passwordsDoNotMatch', 'pwd2');
        }
        return !hasErrors();
  }
   

  private function persistPassword (){
    var result = variables.userGateway.updatePassword(getEmail(), getPwd1());
    if (!result.success) 
        setErrorState(result.errors);
  }

  //  update password from myProfile -> changepassword.
  function changePassword() {   

      if ( !len(getPno()) or getPno() lt 1) {
        setErrorState('pnoNotFound', 'pwdcurrent');
      } else { 

       // see if user exists by pno
        var arUser = variables.userGateway.getUserbyPno(getPno());
        if (arUser.len() neq 1) 
            setErrorState('pnoNotFound', 'pwdcurrent');
        // next see if the current password is correct by checking credentials
        else {
            arUser = variables.userGateway.getUserbyCredentials(arUser[1].userID, getPwdCurrent());
            if (arUser.len() neq 1) 
                setErrorState('passwordnotcorrrect', 'pwdcurrent');
            // no errors; then make the change    
            else {
                // we have a pno, set an email so we can use persistspassword fn
                setEmail(arUser[1].email);
                persistPassword();
            }
            
        }
    }    
  }    

  //  update password from a user reset.
  function resetPassword() {   

        // see if user exists
        var arUser = variables.userGateway.getUserbyEmail(getEmail());
        if (arUser.len() neq 1) 
            setErrorState('emailNotFound');
        // if it does then update the password
        else 
            // email set exernally
            persistPassword();

    }

}