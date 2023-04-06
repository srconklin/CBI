/**
* Copyright Since 2005 Ortus Solutions, Corp
* www.ortussolutions.com
**************************************************************************************
*/
component {

	this.name = "A TestBox Runner Suite" & hash( getCurrentTemplatePath() );
	// any other application.cfc stuff goes below:
	this.sessionManagement = true;
	this.datasource = 'dp_cat';
	// any mappings go here, we create one that points to the root called test.
	this.mappings[ "/tests" ] = getDirectoryFromPath( getCurrentTemplatePath() );

	// any orm definitions go here.

	// request start
	public boolean function onRequestStart( String targetPage ){
		
		request.beanFactory = createObject('component', 'framework.ioc').init(
            folders: [ "/model", "/controllers" ],
            config: {
                exclude: ['/model/base/', ',model/beans/common.cfc']
            } 
        );
		// 	writedump(var="#application#",  abort="false");
		// request.beanFactory = new core.BeanFactory();

		return true;
	}
}