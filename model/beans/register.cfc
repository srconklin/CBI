component accessors=true extends="model.beans.personal" {

  // accessors
  property agreetandc;
  property route;
  property verifyToken;
  property bcast;
  property pno default="0" ;
  property pm;
  
  // private data

  //variables.emailexistsNV = false;
  // password manager bean
  variables.pm = '';
  // authenticated user array 
  ///variables.user = '';

  variables.verifylink;

  // dependencies 
  property utils;
  property userGateway;
  
 function init(config)  {
      variables.config = arguments.config;
      variables.aeskey = variables.config.getSetting("AESKey");
  }    

  function isValid( ){

    super.isValid();  

    // must agree to T&C
    if ( !len(getAgreeTandC()) ) {
      setErrorState('agreeTandC', 'agreeTandC');
      
    } 
    return !hasErrors();

  }

  private function setForm() {
   
      form.pno = getPno();
      form.firstName = getFirstName();
      form.lastName = getLastName();
      form.email = getEmail();
      form.coname = getConame();
      form.phone1 = getPhone();
      form.password = variables.pm.getPwd1();
      form.bcast = getBcast();
      form.route = getRoute();
     
  
    }
  
  // function emailNotVerified() {
  //   return variables.emailexistsNV
  // }
  
  // function getUserData() {
  //   return variables.user
  // }
  
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
      // only throws here; no slugs
       setErrorState(e);

    }    
  
  }

  function resendLink() {

      //validate email against a user
      var arUser = variables.userGateway.getUserbyEmail(getEmail());
      
      // user has an email in session that is needed to generate a new link. test it as still being valid
      if (arUser.len() neq 1) {
        setErrorState( key='verifylinknotcreated', origStatus='toomanyornouser');
      // no reason to resend the link if the email has been verified
      } else if (arUser[1].verifyVerified eq 1) {	
        setErrorState('emailAlreadyVerified');    
     
      // user email successfully verified    
      } else {
          try {

            form.email = getEmail();
            form.firstname = arUser[1].firstname;
            form.lastname = arUser[1].lastname;
            form.resendVerifyLink = true;
            form.route = getRoute();

            include "/cbilegacy/legacySiteSettings.cfm"
            include "/cbilegacy/procreg2.cfm"
            
          } catch (e) {
            setErrorState(e)
          }
       
      }

	}

  function markUserFullyValidated() {
    clearErrors();
    var result = variables.userGateway.markUserFullyValidated(getemail());
    
    if (!result['success'])
      setErrorState(result['errors']);

    return !hasErrors();
  }

  function verifyToken(){

    clearErrors();

    var result = variables.utils.verifyToken(getVerifyToken(), 'register');
    setEmail(result.email);  

    if (!result.success) {
       
        setErrorState(result['error']);

        // custom rules to reset errorstate to something else other than techie errors
        if (getOriginalStatus() eq 'linkExpired') {
           setErrorState(key='verifyLinkExpired', origStatus=getOriginalStatus());
       
         // everything but the following 2  get turned into a simple message
         // if we have a cfexception it is stored in originalerror 
        } else if (!listfindnocase('emailAlreadyVerified,emailAlreadyVerifiedButNeedPassword', getOriginalStatus())) 
          setErrorState(key='emaildidnotverify' , origStatus=getOriginalStatus());
      
      
    }
    else {
       
          // mark email as verified
          result = variables.userGateway.markEmailVerified(getemail());
          if (!result['success'])
            setErrorState(result['errors']);
             
    }

    return !hasErrors();

}

}