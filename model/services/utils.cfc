component accessors=true {
    property config;

    function hasHTML(str) {
        return REFindNoCase("<[^>]*>",str);
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

    // decompose a token into eamil and secret GUID
	function decomposeAESToken(required string token) {
		var result = {
			secretGuid : '',
			email : ''
		};
		

		try {
			// replace the _ back with slashes
			arguments.token = replace(arguments.token, "_", "/", "all");
			var decryptedToken=decrypt(arguments.token, config.getSetting("AESKey"), "AES", "Base64")
			result.secretGuid = getToken(decryptedToken, 1, '|');
			result.email = getToken(decryptedToken, 2, '|');

		} catch (e) {
			result.secretGuid = '';
			result.email = '';
		}
		
		return result;
	}

    function isAjaxRequest() {
		var headers = getHttpRequestData().headers;
		return structKeyExists(headers, "X-Requested-With") 
			   && (headers["X-Requested-With"] eq "XMLHttpRequest");
	  }
   

}