component extends="framework.one" output="false" {
	this.applicationTimeout = createTimeSpan(2, 0, 0, 0);
	this.setClientCookies = true;
	this.sessionManagement = true;
	this.sessionTimeout = createTimeSpan(0, 2, 0, 0);
	this.datasource = 'dp_cat';

	// FW/1 settings
	variables.framework = {
		action = 'action',
		defaultSection = 'main',
		defaultItem = 'default',
		generateSES = true,
		SESOmitIndex = true,
		decodeRequestBody = true,
		diEngine = "di1",
		diComponent = "framework.ioc",
		diLocations = "model, controllers",
		diConfig = { },
		reloadApplicationOnEveryRequest = true,
        routes = [

			{ "$GET/login/" = "/login/default" },
			{ "$POST/login/" = "/login/login" },
			{ "$GET/logout/" = "/login/logout" },

			{ "$GET/search/" = "/main/default" },

			{ "$GET/contact/$" = "/main/contact" },
			{ "$GET/faq/$" = "/main/faq" },
			{ "$GET/about/$" = "/main/about" },

			{ "$GET/items/:id/" = "/items/show/id/:id" },

			{ "$POST/offer/$" = "/offer/create/" },

			{ "$GET/test/" = "/test/default" }
		 ]
	};

	public void function setupSession() { 
		controller( 'security.session' );
	 }

	public void function setupRequest() { 
		controller( 'security.authorize' );
	 }

	public void function setupView() {  }

	public void function setupResponse() {  }

	public string function onMissingView(struct rc = {}) {
		//return "Error 404 - Page not found.";
		return view( 'main/notFound' );
	}

	function isAjaxRequest() {
		var headers = getHttpRequestData().headers;
		return structKeyExists(headers, "X-Requested-With") 
			   && (headers["X-Requested-With"] eq "XMLHttpRequest");
	  }

}
