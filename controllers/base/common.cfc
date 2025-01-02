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
		rc["response"]["status"] = 200;
		rc["response"]["errors"] = '';
		//writedump(var="before with rc.action #rc.action#  (internally known as :  #variables.fw.getFullyQualifiedAction()# ) and method #GetHttpRequestData().method#",  abort="false");

        // Set rc in the variables scope to make it accessible across controllers
        variables.rc = rc;

        if(!listfindnocase('main.error', variables.fw.getFullyQualifiedAction() )) {

            /*******************
            Security
            *******************/
            authorize();

            /*******************
            CAPTCHA
            *******************/
            validateCaptcha()
        }

    }

    /********************************************************
     validateCaptcha
	 all post requests validatecaptcha 
     ********************************************************/
    private function validateCaptcha() {
        
        // if post request AND form is captacha protected then validate
		if(GetHttpRequestData().method eq 'post' ) {
            
            var route = '/' & getToken(variables.fw.getRoutePath(), 2, "/");

             if (!structKeyExists(rc, "g-recaptcha-response")) {
                rc["g-recaptcha-response"] = "";
             }
        
            if(not utils.validateCaptcha(rc['g-recaptcha-response'], route)) {
                 // ajax form then we can just abort submission and show error via Js fetch callback.
                 // otherwise we catch the response.errors rc values and proceed in traditional form submissions
                 if (utils.isAjaxRequest()) {
                     rc["response"]["errors"] = config.lookupStatus('captchaProtect');
                     renderResult(abort=true);
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
    private function authorize() {
		
        var sl = config.getSetting("securelist");
        
		// check if resource is secured
		if(structKeyExists(sl, variables.fw.getSection() ) && listfindnocase(sl[variables.fw.getSection()], variables.fw.getItem() )) {
            // check to make sure the user is logged on and skip exempt pages
            if (!rc.userSession.isloggedIn 
                    && !listfindnocase( 'login', variables.fw.getSection() ) 
                    && !listfindnocase( 'main.error', variables.fw.getFullyQualifiedAction() ) ) {

                if (utils.isAjaxRequest()) {        
                    rc["response"]["payload"]["redirect"] = '/login';
                    renderResult(abort=true);
                } else {
                    rc.destination = variables.fw.getSection();	
                    renderResult('/login', 'destination' ) ; 

                }

            }
            
        }
		
    }
    /*********************************************************************
	 validateForm 
     standard method to validate a form submit using fw bean/populate
     utilties
	*********************************************************************/
    private function validateForm(string bean = '') {
            
        // get the bean and populate it from form fields
		var thebean = variables.beanFactory.getBean( arguments.bean );
		variables.fw.populate( cfc=thebean, key=rc.fieldnames, trim=true );
       
        // Validate form input
        if ( !thebean.isValid() ) {
            // if ajax form submit is detected; then stop processing here and render data back to client.
            if (utils.isAjaxRequest()) {
                rc["response"]["errors"] = thebean.getErrors();
                 renderResult(abort=true);
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
	private function handleServerError(required struct e) {
       
        /*
            e.error can be
               cleansed cf exception response
               our own harvested cf thrown message
               looked up message in messages struct
               for non-ajax cases it it not applicable but it should be 
               filled with next best choice from the content struct
        */
        rc["response"]["errors"] = e.error;

        // cf thrown exception
        if(e.errortype eq "CFException" or !structIsEmpty(e.originalError)) {
            //email original exception
            request.exception = e.originalError;
            sendErrorEmail();
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
	private function sendErrorEmail() {
        var mail = variables.config.getSetting('mail');
		///request.showDiagnostics = (variables.config.getSetting('env') eq 'dev') ? true : false;
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

    private function captchaProtect () {
        	// captcha - extra protection against bots
			if(rc.response.errors eq 'captchaProtect') { 
				throw(message='sorry, we think you are not human', errorcode='not_human');
			}	
    }

   
    /**********************************************************
	renderResult
    navigation renderer, either an ajax call so just renderdata 
    in place or redirect to destination 
	*********************************************************/
	private function renderResult(string destination = '', string peristvars='', boolean abort = false) {

        
        if (len(arguments.destination) )
            if(left(arguments.destination , 8) eq '//search') 
                location(mid(arguments.destination,3, len(arguments.destination)), "false", "301"); 
            else
               variables.fw.redirectCustomURL(uri=arguments.destination, preserve=arguments.peristvars );
        else {
            variables.fw.renderData().type( 'json' ).data( rc.response ).statusCode( rc.response.status ).statusText( "Successful" );
            if (arguments.abort)
                variables.fw.abortController();

        }
    }

    /**
	 * getSessionEmail
	 * Retrieves the registrant's email from the session.
	 * 
	 * @return The registrant's email if it exists in the session; otherwise, an empty string.
	 */
	private function getSessionEmail() {
        return isDefined("variables.rc.userSession.email") ? variables.rc.userSession.email : "";
	}

    /**
     * Retrieves a user by email, sets the user in the session, and updates the 
     * the user session with whatever custom key value pairs passed.
     * 
     * @param email (string) - The email address used to retrieve the user.
     * @param state (struct) - A key value pairs to append or overwrite into user session.
     * 
     */
    private function getUserByEmailAndSetSessionWithState(required string email,  struct userdata={}) {
        // get user from the database using their email
        var user = variables.userService.getUserFromDb(email = arguments.email);
        structAppend(user,arguments.userdata)
        updateUserSession(user);
    }
    
    /**
     * update the user sesson and sync to rc
     * 
     * @param state (struct) - A key value pairs to append or overwrite into user session.
     * 
     */
    private function updateUserSession(userdata={}) {
      // persist to the session scope
      variables.userService.SetUserSession(arguments.userdata);
      // sync session to rc scope
      variables.rc.userSession = variables.userService.getUserSession();

    }

}    