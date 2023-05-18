component accessors=true extends="model.beans.personal" {

  // accessors
  property agreetandc;
  property verifyToken;
  property bcast;
  property pno default="0" ;
  property pm;
  

  // private data

  variables.emailexistsNV = false;
  // password manager bean
  variables.pm = '';
  // authenticated user array 
  variables.user = '';

  // dependencies 
  property utils;
  property userGateway;
  
 function init(config)  {
      variables.config = arguments.config;
      variables.domain = cgi.https eq 'on'? 'https://' : "http://" & cgi.http_host;
      variables.aeskey = variables.config.getSetting("AESKey");
  }    

  function isValid( ){

    super.isValid();  

    if ( !len(getAgreeTandC()) ) {
      variables.errors["agreetandc"] =  config.getContent('basicforms', 'agreeTandC').instruction; 
    } 
    return structCount(variables.errors) ? false: true;

  }

  private function setForm() {
   
      form.pno = getPno();
      form.firstName = getFirstName();
      form.lastName = getLastName();
      form.email = getEmail();
      form.coname = getConame();
      form.phone1 = getPhone1();
      form.password = variables.pm.getPwd1();
      form.bcast = getBcast();
  
    }
  
  function emailNotVerified() {
    return variables.emailexistsNV
  }
  
  function getUserData() {
    return variables.user
  }
  
  function signUp(){

    try {

      if(!isObject(variables.pm)) {
        throw(message='password manager not setup', errorcode='pmmissing');
      } 
      if (! len(variables.pm.getPwd1())) {
        throw(message='password manager not setup', errorcode='pmmissing')
      }

      setForm();
      
      include "/cbilegacy/legacySiteSettings.cfm";
      include "/cbilegacy/procreg2.cfm";
       
    } catch (e) {
        if (e.errorcode eq 'emailinuse_nv')
          variables.emailexistsNV = true
        else  
          variables.errors =e;
    }    

  
  }

  function resendLink(  ) {

      //validate email against a user
      var arUser = variables.userGateway.getUserbyEmail(getEmail());
      
      // email found in encrypted string comes back as not being exactly one row in the db. fishy or broken link
      if (arUser.len() neq 1) {
        variables.errors='emaildidnotverify';
      // no reason to resend the link if the email has been verified
      } else if (arUser[1].verifyVerified) {	
          variables.errors='emailAlreadyVerified';    
     
      // user email successfully verified    
      } else {
          try {

            form.email = getEmail();
            form.firstname = arUser[1].firstname;
            form.lastname = arUser[1].lastname;
            form.resendVerifyLink = true;
    
            include "/cbilegacy/legacySiteSettings.cfm"
            include "/cbilegacy/procreg2.cfm"
            
          } catch (e) {
            variables.errors=e;   
          }
       
      }

	}
     
  function verifyToken(){

    clearErrors();

    // decrypt an AES encrypted string
    var decrypt = variables.utils.decryptAESString(getVerifyToken());
    // error decrypting 
    if(len(decrypt.error)) {
        variables.errors=decrypt.error;
    } else {

        // decompose token into email and secret
        var decomposedToken = variables.utils.decomposeResetToken(decrypt.decString);

        //problem with token
        if(len(decomposedToken.error)) {
            variables.errors=decomposedToken.error;
        } else {
        
            // setemail into bean
            setEmail(decomposedToken.email);

            //validate email against a user
            var arUser = variables.userGateway.getUserbyEmail(getEmail());
           
            // email found in encrypted string comes back as not being exactly one row in the db. fishy or broken link
            if (arUser.len() neq 1) {
                variables.errors='emaildidnotverify';
            } else if (arUser[1].verifyVerified) {	
                variables.errors='emailAlreadyVerified';    
            // link expired more than 2hours 
            } else if (datediff('n', arUser[1].verifyDateTime, now()) gt 120 ) {	
                variables.errors='verifyLinkExpired';
            // hash is invalid; something fishy
            } else if (! Argon2CheckHash( decomposedToken.secretGuid, arUser[1].verifyHash)) {
                variables.errors='emaildidnotverify';
            // user email successfully verified    
            } else {

               // mark email as verified
               result = variables.userGateway.markEmailVerified(getEmail());
               if (!result['success'])
                variables.errors =result['errors']
              else {
                //re-retrieve user with updated security settings
                arUser = variables.userGateway.getUserbyEmail(getEmail());
                variables.user = arUser[1];
              }

            }
        }
    }
    return len(variables.errors) ? false: true;

}


}