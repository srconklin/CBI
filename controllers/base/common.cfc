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
		//writedump(var="before with rc.action #rc.action#  (internally known as :  #variables.fw.getFullyQualifiedAction()# ) and method #GetHttpRequestData().method#",  abort="false");

        if(!listfindnocase('main.error', variables.fw.getFullyQualifiedAction() )) {

            /*******************
            Security
            *******************/
            authorize(rc);

            /*******************
            CAPTCHA
            *******************/
            validateCaptcha(rc)
        }

    }

    /********************************************************
     validateCaptcha
	 all post requests validatecaptcha 
     ********************************************************/
     function validateCaptcha( struct rc = {} ) {
        
        // if post request AND form is captacha protected then validate
		if(GetHttpRequestData().method eq 'post' ) {
            // and listfindnocase( config.getsetting('captchaProtect'), variables.fw.getFullyQualifiedAction() )) {
             param name="rc['g-recaptcha-response']" default="";
             var route = '/' & getToken(variables.fw.getRoutePath(), 2, "/");
             if(not utils.validateCaptcha(rc['g-recaptcha-response'], route)) {
                 // ajax form then we can just abort submission and show error via Js fetch callback.
                 // otherwise we catch the response.errors rc values and proceed in traditional form submissions
                 if (utils.isAjaxRequest()) {
                     rc["response"]["errors"] = config.lookupStatus('captchaProtect');
                     renderResult(rc=rc,abort=true);
                 } else {
                     rc["response"]["errors"] = 'captchaProtect';
                     
                 }
             }
           
         }

     }

    /********************************************************
     authorize
	 secrity checked for pages that require authentication
     ********************************************************/
     function authorize( struct rc = {} ) {
		
        var sl = config.getSetting("securelist");
        
		// check if resource is secured
		if(structKeyExists(sl, variables.fw.getSection() ) && listfindnocase(sl[variables.fw.getSection()], variables.fw.getItem() )) {
            // check to make sure the user is logged on and skip exempt pages
            if (!rc.userSession.isloggedIn 
                    && !listfindnocase( 'login', variables.fw.getSection() ) 
                    && !listfindnocase( 'main.error', variables.fw.getFullyQualifiedAction() ) ) {

                if (utils.isAjaxRequest()) {        
                    rc["response"]["payload"]["redirect"] = '/login';
                    renderResult(rc=rc,abort=true);
                } else {
                    rc.destination = variables.fw.getSection();	
                    renderResult(rc, '/login', 'destination' ) ; 

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
                 renderResult(rc=rc,abort=true);
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
	function handleServerError(struct rc = {}, required struct e) {
       
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
            request.exception = e.originalError;
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

    function captchaProtect (struct rc= {}) {
        	// captcha - extra protection against bots
			if(rc.response.errors eq 'captchaProtect') { 
				throw(message='sorry, we think you are not human', errorcode='not_human');
			}	
    }
    
    /**********************************************************
	renderResult
    navigation renderer, either an ajax call so just renderdata 
    in place ot redirect to destiation 
	*********************************************************/
	function renderResult(struct rc = {}, string destination = '', string peristvars='', boolean abort = false) {

        
        if (len(arguments.destination) )
            if(left(arguments.destination , 8) eq '//search') 
                location(mid(arguments.destination,3, len(arguments.destination)), "false", "301"); 
            else
               variables.fw.redirectCustomURL(arguments.destination, arguments.peristvars );
        else {
            variables.fw.renderData().type( 'json' ).data( rc.response ).statusCode( 200 ).statusText( "Successful" );
            if (arguments.abort)
                variables.fw.abortController();

        }
    }
}    