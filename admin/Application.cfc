component output="false" {

	this.applicationTimeout = createTimeSpan(2, 0, 0, 0);
	this.setClientCookies = true;
	this.sessionManagement = true;
	this.sessionTimeout = createTimeSpan(0, 2, 0, 0);
	this.datasource = 'dp_cat';
	// this.mappings["/classFiles"]= "C:\inetpub\DynaPrice\Shared\Classfiles";
	// this.mappings["/clientSites"]= "C:\inetpub\wwwroot\DynaClients";
 

	// this.mappings["/classFiles"]= "/app/admin/classFiles";
	// this.mappings["/clientSites"]= "/app/admin/clientSites";
 


}
