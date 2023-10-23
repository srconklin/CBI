component accessors=true {

    property fw;
	property beanFactory;
    property userService;
	property utils;
	property config;
    
    /*********************************************************************
	 before
     FW before lifecycle method to execute before every controller that
     extends this base controller
	*********************************************************************/
    function before( struct rc = {} ) {
        // basic response structure for controllers
        rc["vars"] = {};
		rc["response"]["res"] = false;
		rc["response"]["payload"] = {};
		rc["response"]["errors"] = '';
		
        //CAPTCHA
		// if post request AND form is captacha protected then validate
		if(GetHttpRequestData().method eq 'post' 
            and listfindnocase( config.getsetting('captchaProtect'), variables.fw.getFullyQualifiedAction() )) {
			param name="rc['g-recaptcha-response']" default="";
			if(not utils.validateCaptcha(rc['g-recaptcha-response'], rc.action)) {
                // ajax form then we can just abort submission and show error via Js fetch callback.
                // otherwise we catch the response.errors rc values and proceed in traditional form submissions
                if (utils.isAjaxRequest()) {
                    rc["response"]["errors"] = config.lookupStatus('captchaProtect');
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
     utilties
	*********************************************************************/
    function validateForm(struct rc = {}, string bean = '') {
            
        // get the bean and populate it from form fields
		var thebean = variables.beanFactory.getBean( arguments.bean );
		variables.fw.populate( cfc=thebean, key=rc.fieldnames, trim=true );
       
        // Validate form input
        if ( !thebean.isValid() ) {
            // if ajax form submit is detected; then stop processing here and render data back to client.
            if (utils.isAjaxRequest()) {
                rc["response"]["errors"] = thebean.getErrors();
                variables.fw.renderData().type( 'json' ).data( rc.response ).statusCode( 200 ).statusText( "Successful" );
                variables.fw.abortController();
            } else {
                // slug only in errors so that it can be looked up from content to page in view or redirect
                rc["response"]["errors"] = thebean.getStatus();
            }   
        }
        return thebean;
    }

    /**************************************************************
	 handleServerError
     takes a bean where its errorcontext is retrieved 
     can be an exact error message, a slug for a lookup or cf 
     exception
	**************************************************************/
	function handleServerError(required struct e) {
       
        /*
            e.error can be

               cleansed cf exception response
               are own harvested cf thrown message
               looked up message in messages struct
               for non-ajax cases it it not applicable but it should be 
               filled with next best choice from the content struct
        */
      

        rc["response"]["errors"] = e.error;

        // cf thrown exception
        if(e.errortype eq "CFException" or !structIsEmpty(e.originalError)) {
            //email original exception
            request.exception = e.orignalError;
            sendErrorEmail(rc);
        }
        // custom thrown exception
        else if(e.errortype eq "customException") {
            // save message to show later
            session.dperror =  e.error;
        }

       
        // e.clearErrors
        /* status can be set to
              'application' which falls back to catchall if being looked up in content
              'dperror' which means look to session scope to retrieve later.
               a slug for lookup in content later
               for an ajax it is not applicable but it is the key that was found in the messages struct
        */     
        return e.status;

    }
	// function handleServerError(struct e = {}) {
    //     var result = '';

    //     // cf exception object
    //     if(e.errortype contains "Exception") {
    //         rc["response"]["errors"] = e.error;
    //        // rc["response"]["errors"] = e.errors.message;
    //         // returns the errocode of the exception
    //         result= e.status;
    //         request.exception = e.errors;
    //         sendErrorEmail(rc);
        
    //         // an actual message
    //     } else if (e.errortype eq "message") {
    //         rc["response"]["errors"] = e.error;
    //         // returns actual error we found in the status messages struct
    //         result= e.error;
        
    //         // slug to lookup a message    
    //     } else {
    //         rc["response"]["errors"] = e.status;
    //         // return the slug for lookup in content later
    //         result= e.status;
    //     }

    //     return result;

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