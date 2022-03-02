component  accessors=true {

	property framework;
	property beanFactory;

	
	public void function create(struct rc = {}) {

		var response = {};
		response["req"] = rc;
		
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
			// log transaction and send email
		}

		variables.framework.renderData().type( 'json' ).data( response ).statusCode( 200 ).statusText( "Successful" );
	}


	
}