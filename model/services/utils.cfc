component accessors=true {
    property config;

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
            
            var route = '/'& gettoken(arguments.route, 1, ".");
            // writeDump(captcha);
            // writeDump(route );
            // writeDump(response);
            // abort;
            if (response.success and response.score gt 0.5 and response.action eq route ) {
                result = true;	
            }
            
        }

   
        return result;
        
    }

    // decrypt and AES token
	function decryptAESString(required string theString) {
		var result = {
			token : '',
            error: ''
		};

		try {
			// replace the _ back with slashes
			arguments.theString = replace(arguments.theString, "_", "/", "all");
			result.decString=decrypt(arguments.theString, config.getSetting("AESKey"), "AES", "Base64")

		} catch (e) {
            result.error = e.message;
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

    function isAjaxRequest() {
		var headers = getHttpRequestData().headers;
		return structKeyExists(headers, "X-Requested-With") 
			   && (headers["X-Requested-With"] eq "XMLHttpRequest");
	  }
   

}