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
			// interface to dynabuilt system by meeting requirements of sister template and 
			// setting flag to circumvent certain elements; redirects, html, data validation etc.
			variables.modern = true;
			Form.ccSender = true;
			
			// session exchange
			variables.validated = session.validated;
			variables.pno = session.pno;
			variables.sessionID = session.sessionID;
			
			// vb settings
			variables.xndeal=0;
			variables.AllowVendorAliases = 0;
			variables.TVen = false;
			variables.vizPagetop = 0;
			variables.baseclientpath = "/clientSites/";
			request.vendir= "/clientSites/107/63160/";
			request.DSNCat = 'dp_cat';
			request.fullVenDir = "//localhost:8080/";
			request.fullVenDirNoProtocol = replacenocase(request.fullVendir, '//', '', 'all');
			request.fullVenDirWithProtocol = replacenocase(request.fullVendir, '//', "#iif(cgi.https eq 'on', DE('https://'), DE('http://') )#", 'all');
			request.isProductionServer = false;
			request.debug_to = "admin@capovani.com";
			request.SysMailSender = "cbionlineadmin@dynaprice.com";

			try {
				 include "/capovani/proctrans.cfm"
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