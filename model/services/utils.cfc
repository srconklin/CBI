component accessors=true {
    
    function hasHTML(str) {
        
        return REFindNoCase("<[^>]*>",str);
    }
        
    function validateCaptcha(rc) {

        var result = false;

        // validate the g-captcha-repsonse
        if (structKeyExists(rc, 'g-recaptcha-response')) {
            //validate token with Google
            cfhttp(method="POST", url="https://www.google.com/recaptcha/api/siteverify", result="captchaResponse") {
                cfhttpparam(name="secret", type="formfield", value="6LevHMkfAAAAAM2ohc3wTWLu8gYj0acuUXaG1_da");
                cfhttpparam(name="response", type="formfield", value=rc['g-recaptcha-response']);
                cfhttpparam(name="Accept", type="header", value='application/json');
            }
            var response = deserializeJSON(captchaResponse.filecontent);
            // writeDump(response);
            // abort;
            var route = '/'& gettoken(rc.action, 1, ".");

            if (response.success and response.score gt 0.5 and response.action eq route ) {
                result = true;	
            }
            
        }

        return result;
        
    }
   

}