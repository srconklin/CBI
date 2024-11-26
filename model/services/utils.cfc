component accessors=true {
    property config;
    property userGateway;

    function hasHTML(str='') {
        return REFindNoCase("<[^>]*>",arguments.str);
    }
        
    function validateCaptcha(captcha, route) {
        var result = false;

        // validate the g-captcha-repsonse
        if (len(arguments.captcha)) {

            //validate token with Google
            cfhttp(method="POST", url="https://www.google.com/recaptcha/api/siteverify", result="captchaResponse") {
                cfhttpparam(name="secret", type="formfield", value=config.getSetting("captchasecret"));
                cfhttpparam(name="response", type="formfield", value=arguments.captcha);
                cfhttpparam(name="Accept", type="header", value='application/json');
            }
            var response = deserializeJSON(captchaResponse.filecontent);
            // writeDump(route);
            // writeDump(response);
            // abort;
            if (response.success and response.score gt 0.5 and response.action eq arguments.route ) {
                result = true;	
            }
    
        }
        return result ;
        
    }

    // decrypt an AES token
	function decryptAESString(required string theString) {
		var result = {
			decString : '',
            error: ''
		};

		try {
			// replace the _ back with slashes
			arguments.theString = replace(arguments.theString, "_", "/", "all");
			result.decString=decrypt(arguments.theString, config.getSetting("AESKey"), "AES", "Base64");

		} catch (e) {
            result.error = e;
		}
		
		return result;
	}

    function decomposeResetToken(token){
        var result = {
			secretGuid : '',
			email : '',
            error: ''
		};

        // a reset token consists of a secret (GUID) and an email
        result.secretGuid = getToken(arguments.token, 1, '|');
		result.email = getToken(arguments.token, 2, '|');

        if(!findNoCase('|', arguments.token))
            result.error = 'badformat';	
        else if(!len(result.secretGuid))
            result.error = 'missingsecret';
        else if(!len(result.email))
            result.error = 'missingemail';
        else if(!isValid('email', result.email))
            result.error = 'bademail';
        
        
        return result;

    }

    function verifyToken(token, type='register'){
        var result = {
            success : false,
			email : '',
            error: ''
		};

        // decrypt an AES encrypted string
        var decrypt = decryptAESString(arguments.token);
        // error decrypting; a cf exception
        if(len(decrypt.error)) {
             result.error = decrypt.error;
        } else {

            // decompose token into email and secret
            var decomposedToken = decomposeResetToken(decrypt.decString);

            //problem with token
            if(len(decomposedToken.error)) {
                // decomposeResetToken returns very specific errors on issues with token
                result.error = decomposedToken.error;
            } else {
            
                result.email = decomposedToken.email;

                //validate email against a user
                var arUser = variables.userGateway.getUserbyEmail(result.email);
                //writedump(var="#arUser#",  abort="true");
               
                // email found in encrypted string comes back as not being excatly one row in the db. fishy or broken link
                if (arUser.len() neq 1) {
                    result.error = 'toomanyornouser';
                             
                } else {

                    // register checks    
                    if (arguments.type eq 'register') {
             
                        if (arUser[1].verifyVerified eq 1 && arUser[1].pwdVerified) {	
                            result.error = 'emailAlreadyVerified';
                        } else if (arUser[1].verifyVerified eq 1 && !arUser[1].pwdVerified)
                           result.error = 'emailAlreadyVerifiedButNeedPassword';
                        // register token date link expired more than the threshold allows
                        else if ( datediff('n', arUser[1].verifyDateTime, now()) gt config.getSetting('threshold')) {	
                            result.error = 'linkExpired';
                        // hash is invalid; something fishy    
                        } else if (! Argon2CheckHash( decomposedToken.secretGuid, arUser[1].verifyHash)) {
                            result.error = 'invalidHash';
                        }


                    // password checks        
                    } else if (arguments.type eq 'password') {
                       
                        // pwd token date link expired more than the threshold allows
                        if ( datediff('n', arUser[1].pwdDateTime, now()) gt config.getSetting('threshold')) {	
                            result.error = 'linkExpired';
                        // hash is invalid; something fishy    
                        } else if (! Argon2CheckHash( decomposedToken.secretGuid, arUser[1].pwdHash)) {
                           result.error = 'invalidHash';
                        }

                    // coding issuing where type is not defined    
                    } else {
                        result.error = 'typemismatch';
                    }

                }

            }
        }
        
        result['success'] = len(result.error) ? false : true;
        return result;
    }
    function isAjaxRequest() {
		var headers = getHttpRequestData().headers;
		return structKeyExists(headers, "X-Requested-With") 
			   && (headers["X-Requested-With"] eq "XMLHttpRequest");
	  }
   

}