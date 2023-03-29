component accessors=true extends="controllers.base.common" {

	// property config;
	 
	/******************************
	 default controller (GET)
	 home page
	******************************/
	function default(struct rc = {}) {
		// item quickview modal is present on home page, need to param it so it does not break
		param rc.content.specstable='';
	}
	
	/******************************
	 show item detail page (GET)
	******************************/
	public void function showItem(struct rc = {}) {
		param name="rc.id" default=0  type="integer";
		
		try {
			rc.content =deserializeJSON(fileRead(ExpandPath( "./" ) & '/data/#rc.id#.json'));
			rc.bc =fileRead(ExpandPath( "./" ) & '/data/bc/#rc.id#.cfm');
		} 
		catch(any e) {
				variables.fw.setView('main.notFound');
		}
	}

	
	/******************************
	 site wide error handler
	******************************/
	function error(struct rc = {}) {
		sendErrorEmail(rc)
		
	}
	
}