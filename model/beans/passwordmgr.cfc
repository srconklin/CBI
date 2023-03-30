component accessors=true extends="model.beans.common" {
    
	property pwd1;
	property pwd2;
    property config;

    function isValid(){
        
        if(!len(getPwd1())){
            variables.errors["pwd1"] =config.getContent('setpassword', 'missingPassword').instruction;
        } else if (!len(getPwd2())){
            variables.errors["pwd2"] = config.getContent('setpassword', 'missingConfirmationPassword').instruction;
        } else if (getPwd1() neq getPwd2()){
            variables.errors["pwd2"] =config.getContent('setpassword', 'passwordsDoNotMatch').instruction;
        }    
        
        return len(variables.errors) ? false: true;
  }
 

}