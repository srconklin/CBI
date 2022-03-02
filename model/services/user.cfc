component accessors=true {

	//property framework;
	property beanFactory;

    <!--- function init() {
           return this;
    } --->

  
    function validateUser( required string username,  required string password ) {
		
		// get a user bean
		//var user = variables.beanFactory.getBean( "userbean" );
		var user;
		
		var params = {
			username: arguments.username,
			password: hash(arguments.password)
		};
			
		var sql = 'select p.Pno, p.userID, p.email, p.firstname, p.lastname, pv.corelatno 
				   from people p 
				   inner join Permits PV ON PV.PNo = P.PNo AND PV.VTID=63160	
				   where p.userID = :username and password = :password;'
						
		var arUser = queryExecute( sql, params,  { returntype="array" });
		
		if(arUser.len() eq 1) {
			user=arUser[1];
		}
			
        return user;
    }

   

}