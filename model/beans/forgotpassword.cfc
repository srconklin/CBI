component accessors=true extends="model.beans.common" {
    //accessors
	property email;
	property resetToken;
    
    // private data
    variables.threshold =120;
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
                variables.errors ='missingEmail';
            } else if (!isValid('email', getEmail())){
                variables.errors ='InvalidEmail';
            }    
            
            return len(variables.errors) ? false: true;
    }

    function markPasswordVerified () {
       var  result = variables.userGateway.markPasswordVerified(getEmail());   
        if (!result.success) 
            variables.errors=result['errors']; 
    }

    function generateLink(){
        var result = false;
    
        form.email = getEmail();

        try{
            include "/cbilegacy/legacySiteSettings.cfm";
            include "/cbilegacy/resetForgottenPwd.cfm";
            result = true;
        
        } catch (e) {
            variables.errors =e;
        }   
        
        return result;
    }
  
    
    function verifyToken(){

        clearErrors();

        // decrypt an AES encrypted string
        var decrypt = variables.utils.decryptAESString(getResetToken());
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
               
                // email found in encrypted string comes back as not being excatly one row in the db. fishy or broken link
                if (arUser.len() neq 1) {
                    variables.errors='toomanyornouser';
                // link expired more than 2hours 
                } else if (datediff('n', arUser[1].pwdDateTime, now()) gt variables.threshold) {	
                    variables.errors='passwordLinkExpired';
                // hash is invalid; something fishy
                } else if (! Argon2CheckHash( decomposedToken.secretGuid, arUser[1].pwdHash)) {
                    variables.errors='invalidHash';
                }
            }
        }
        return len(variables.errors) ? false: true;

    }
}