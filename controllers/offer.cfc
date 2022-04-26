component  accessors=true {

	property framework;
	property beanFactory;

	
	public void function create(struct rc = {}) {

		var response = {};
		response["req"] = rc;
		
		// get the bean and populate it from form fields
		var offer = variables.beanFactory.getBean( "offerbean" );
		variables.framework.populate( cfc=offer, key=rc.fieldnames, trim=true );

		// Validate form input
		if ( !offer.isValid() ) {
			//error
			response["res"] = false;
			response["errors"] = offer.getErrors();
		} else {
			
			response["res"] = true;
			response["errors"] ={};
			// interface to dynabuilt system by meeting requirements of template as an include 
			// setting flag to circumvent certain elements; redirects, html, data validation etc.
			variables.modern = true;
			Form.ccSender = true;
			
			// session exchange to local
			variables.validated = session.validated;
			variables.pno = session.pno;
			variables.sessionID = session.sessionID;
			variables.vizPagetop = session.vwrCoRelatNo;

			try {
				include "/cbilegacy/legacySiteSettings.cfm"
				include "/cbilegacy/proctrans.cfm"
			} catch (e) {
				response["res"] = false;
				response["errors"] = e.message;
				writeDump(e);
				abort;
			}

			
		}

		variables.framework.renderData().type( 'json' ).data( response ).statusCode( 200 ).statusText( "Successful" );
	}


	
}