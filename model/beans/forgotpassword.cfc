component accessors=true extends="model.beans.common" {
    //accessors
	property email;
	property resetToken;
    
    // private data
   
    variables.hashes = {
        secret : '',
        theArgonHash : ''
    };
    variables.encryptedHash = '';
    variables.resetlink = '';

    // dependencies 
    property utils;
    property userGateway;

    function init(config)  {
        variables.config = arguments.config;
        variables.domain = cgi.https eq 'on'? 'https://' : "http://" & cgi.http_host;
        variables.aeskey = variables.config.getSetting("AESKey");
    }     

    function isValid( ){
            
        if(!len(getEmail())){
            setErrorState('missingEmail');
        } else if (!isValid('email', getEmail())){
            setErrorState('InvalidEmail');
        }    
        
        return !hasErrors();
    }

    function markPasswordVerified () {
       var  result = variables.userGateway.markPasswordVerified(getEmail());   
       if (!result.success) 
            setErrorState(result['errors']);
    }

    function generateLink(){
        form.email = getEmail();

        try{
            include "/cbilegacy/legacySiteSettings.cfm";
            include "/cbilegacy/resetForgottenPwd.cfm";
        
        } catch (e) {
            setErrorState(e);

        }   
        
    }
    
    function verifyToken(){

        clearErrors();

       var result = variables.utils.verifyToken(getResetToken(), 'password');
        if (!result.success) {

            setErrorState(result['error']);
            
             // rules to reset errorstate to something else than techie results
            if (getOriginalStatus() eq 'linkExpired') {
                setErrorState(key='passwordLinkExpired', origStatus=getOriginalStatus());
            // everything but alreadyverified is getting turned into a simple message 
            // if we have a cfexception is it stored in originalerror 
            } else if (getOriginalStatus() neq 'emailAlreadyVerified') {
                setErrorState(key='passwordNotReset' , origStatus=getOriginalStatus());
            }
            
            
        }
         else 
           setEmail(result.email);  

        return !hasErrors();

    }
}