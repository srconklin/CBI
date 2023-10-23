component accessors=true extends="model.beans.common"{
    // accessors
     property userName;
     property password;

	// private
    variables.userData ={
        validated : 0,
		pno: 0,
		vwrcorelatno: 0,
		regstat : 0,
		isNewPerson : 0,
		email  :  '',
		verifyVerified : 0,
        firstname : '',
        lastname : ''
    };

    //variables.status = 'ok';

    // dependencies
    property config;
    property userGateway;
    
 
    function isValid() {
        var result = true;
        if ( !len(getUserName()) or !len(getPassword()) ) {
             setErrorState('missing_login_fields');
        }
        return len(getErrors()) ? false: true;

    }
    function isUserValid() {
        var result = false;
      
        if(! this.isValid()){
            return result;
        } 
        var arUser = variables.userGateway.getUserbyCredentials(getUsername(), getPassword());
      
        if(!isArray(arUser) or arUser.len() eq 0) {
            setErrorState('user_not_found');
        }    
        else if(arUser.len() gt 1) {
            setErrorState('duplicate_user');
        }
        // user authenticated    
        else {
            autoLoginUser(arUser[1]);
            result =true;
        }
        return result;

    }

    function autoLoginUser(user= {}) {
        variables.userData=user;
        variables.userData.vwrCorelatno = max(user.pvcorelatno, user.corelatno);
        variables.userData.validated = 2;
    }

    function getUserData() {
        return variables.userData;
    }
  

}