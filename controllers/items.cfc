component name="items" output="false" {

	function init( fw ) {
        variables.fw = fw;
	}
	
	public void function default(struct rc = {}) {
	}

	public void function show(struct rc = {}) {
		param rc.id='';
		var itemno = getToken(rc.id, 1, '-');
		try {
			rc.content =deserializeJSON(fileRead(ExpandPath( "./" ) & '/data/#itemno#.json'));
		} 
		catch(any e) {
				variables.fw.setView('main.notFound');
		}
	}
	
}