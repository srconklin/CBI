component accessors=true extends="model.base.personal" {
	property pwd1;
	property pwd2;
  property config;
  
    function isValid( ){
      
         super.isValid();  
    
    //password - SRC: use pwd1 and pwd2 from resetpassword bean instead? 
    // if ( !len(getPwd1()) ) {
    //     variables.errors["pwd1"] =config.getContent('basicforms', 'missingPassword').instruction; 
    // }
    // if ( !len(getPwd2()) ) {
    //   variables.errors["pwd2"] =config.getContent('basicforms', 'missingPassword').instruction; 
    // }
    //password - SRC: use pwd1 and pwd2 from resetpassword bean instead? 
    // if ( !len(getPassword()) ) {
    //     variables.errors["password"] =config.getContent('basicforms', 'missingPassword').instruction; 
    // }
       
    
    return structCount(variables.errors) ? false: true;
  }


}