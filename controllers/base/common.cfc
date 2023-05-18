component accessors=true {

    property fw;
	property beanFactory;
    property userService;
	property utils;
	property config;
    
    // function init(config)  {
    //     variables.config = arguments.config;
    //     variables.baseVars = {
    //         domain = cgi.https eq 'on'? 'https://' : "http://" & cgi.http_host,
    //         aeskey = variables.config.getSetting("AESKey")
    //     }
	// }

    /*********************************************************************
	 before
     FW before lifecycle method to execute before every controller that
     extends this base controller
	*********************************************************************/
    function before( struct rc = {} ) {
        // basic response structure for controllers
        rc["vars"] = {};
		rc["response"]["req"] = rc;
		rc["response"]["res"] = false;
		rc["response"]["payload"] = {};
		rc["response"]["errors"] = '';
        rc["response"]["errorcode"] = '';
		
        //CAPTCHA
		// if post request AND form is captacha protected then validate
		if(GetHttpRequestData().method eq 'post' 
            and listfindnocase( config.getsetting('captchaProtect'), variables.fw.getFullyQualifiedAction() )) {
			param name="rc['g-recaptcha-response']" default="";
			if(not utils.validateCaptcha(rc['g-recaptcha-response'], rc.action)) {
                // ajax form then we can just abort submission and show error via Js fetch callback.
                // otherwise we catch the response.errors rc values and proceed in traditional form submissions
                if (utils.isAjaxRequest()) {
                    rc["response"]["errors"] = config.getContent('captchaProtect', 'invalid');
                    variables.fw.renderData().type( 'json' ).data( rc.response ).statusCode( 200 ).statusText( "Successful" );
                    variables.fw.abortController();
                } else {
                    rc["response"]["errors"] = 'invalidCaptcha';
                }
			}
          
		}

    }

    /*********************************************************************
	 validateForm 
     standard method to validate a form submit using fw bean/populate
     utities
	*********************************************************************/
    function validateForm(struct rc = {}, string bean = '') {
            
        // get the bean and populate it from form fields
		var thebean = variables.beanFactory.getBean( arguments.bean );
		variables.fw.populate( cfc=thebean, key=rc.fieldnames, trim=true );
       
        // Validate form input
        if ( !thebean.isValid() ) {
            rc["response"]["errors"] = thebean.getErrors();
            // if ajax form submit is detected; then stop processing here and render data back to client.
            if (utils.isAjaxRequest()) {
                variables.fw.renderData().type( 'json' ).data( rc.response ).statusCode( 200 ).statusText( "Successful" );
                variables.fw.abortController();
            }    
        }
        return thebean;
    }

    /*********************************************************************
	 makeLegacyCall 
     interface to include a file/execute a file in the legacy application 
     ********************************************************************/
    // function makeLegacyCall(struct rc = {}, string serverTemplate  = '', struct legacyvars = {}) {

    //     // beans are transiet. They have their own variables scope and are thrown away aftwards
    //     var legacyBean = variables.beanFactory.getBean( "legacybean" );
    //     try{
    //         var vars = legacyBean.makeLegacyCall( serverTemplate = arguments.serverTemplate,legacyvars=arguments.legacyvars);
    //         // stuff any return vars from the legacy system into the rc for harvesting in the calling program.
    //         structAppend(rc.vars, vars, true);
    //     } catch (e) {
    //             // we have an error. we report back to calling function rather than
    //             // render and abort controller as sometimes we have managed errors where
    //             // the message is looked up in content config
    //             // writeDump(e);
    //             // abort;
    //             // cfrethrow;
    //             // stick the exception object into the request to match how it works with FW1 onError.
    //             // the sendError routine expects this for error reporting via email
    //             request.exception = e;
    //             rc["response"]["errors"] = e.message;
    //             rc["response"]["errorcode"] = e.errorcode;
    //            	sendErrorEmail(rc);
			
    //     }

    //     //no errors turn response to true
	// 	 if(!len(rc.response.errors)) 
    //          rc["response"]["res"] = true;

    // }

    
     /**********************************************************
	 sendErrorEmail
     generic email handler for errors both explicity and implicity
     thrown
	*********************************************************/
	function sendErrorEmail(struct rc = {}) {
        var mail = variables.config.getSetting('mail');
		request.showDiagnostics = (variables.config.getSetting('env') eq 'dev') ? true : false;
        request.stacktrace ='';

            savecontent variable='request.stacktrace' {
                request.exception.tagcontext.each(function(element,index,array){
                    writeOutput("<b>#index#.</b><br>"); 
                    writeOutput("Line <b>#element.line#</b><br>Template: <b>#element.template#</b><br><br>"); 
                    writeOutput("Code: <pre>#encodeForHTML(element.codePrintPlain)#</pre>"); 
                    writeOutput("<hr>"); 
                });    
            }
    
		if (structKeyExists( request, 'failedAction' ))
			rc.action = replace( request.failedAction, chr(60), "&lt;", "all" );
		else
			rc.action ="unknown";

		cfmail( to = mail.ErrorTO, from = mail.ErrorFrom, type="html" subject = "An error occurred at #config.getSetting('name')#" ) { 
            include '/views/common/fragment/errorReport.cfm';
		}

	}
    
    /**********************************************************
	renderResult
    navigation renderer, either an ajax call so just renderdata 
    in place ot redirect to destiation 
	*********************************************************/
	function renderResult(struct rc = {}, string destination = '', string peristvars='') {

        if (len(arguments.destination) )
            variables.fw.redirectCustomURL(arguments.destination, arguments.peristvars );
        else
            variables.fw.renderData().type( 'json' ).data( rc.response ).statusCode( 200 ).statusText( "Successful" );
    }

   
}    