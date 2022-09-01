component  accessors=true extends="model.base.personal" {

	property framework;
	property beanFactory;

	// process forgotpassword
	public void function forgotpassword(struct rc = {}) {
		// email present assume a post request to get the email
		if(structKeyExists(rc, 'email')){
			variables.userService.resetForgotenPwd(rc.email);
			
	
		}
		
			
	
		
	}

	

}