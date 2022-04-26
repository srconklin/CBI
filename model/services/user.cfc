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
			
		var sql = 'select p.Pno, p.userID, p.email, p.firstname, p.lastname, p.coname, p.phone1,
				   ISNULL(PV.CoRelatNo, 0) as pvcorelatno,
				   ISNULL(Permits.CoRelatNo,0) as corelatno
				   FROM people p 
				   INNER join Permits PV ON PV.PNo = P.PNo AND PV.VTID=63160	
				   INNER JOIN Permits ON (Permits.PNo = P.PNo AND Permits.VTID IN (63160,107,2))
				   where p.userID = :username and password = :password;'
						
		var arUser = queryExecute( sql, params,  { returntype="array" });
		
		if(arUser.len() eq 1) {
			user=arUser[1];
		}
			
        return user;
    }

   

}