component name="items" output="false" {

	function init( fw ) {
        variables.fw = fw;
	}
	
	public void function default(struct rc = {}) {
	}

	public void function show(struct rc = {}) {
		cfparam(name="rc.id" default=0, type="integer");
		// var itemno = getToken(rc.id, 1, '-');
		try {
			rc.content =deserializeJSON(fileRead(ExpandPath( "./" ) & '/data/#rc.id#.json'));
			rc.bc =fileRead(ExpandPath( "./" ) & '/data/bc/#rc.id#.cfm');
		} 
		catch(any e) {
				variables.fw.setView('main.notFound');
		}
	}
	
}