component accessors=true extends="model.beans.common"{
    // accessors
     property userName;
     property password;

	/************************************************************************************************* 
    private

    validated: (maintained in memory)
    0= the default
    1=recognized so partially logged in;  (session.validate to 1 in dealmkaing after execution of proctrans)
    2=fully logged in with complete profile
     set to 2 when a user logs into modern system   
   

    regstat (read from db)
    the registration profile setting that is stored in the db of a user. 
    0=found in db but never logged in. inserted from a previous offer/inquiry, no passsord and should not be able to manage profile
    1=found in db and user has properly registered; set a password and verified email ownership
    *******************************************************************************************************/
    variables.userData ={
        validated : 0,
		pno: 0,
		vwrcorelatno: 0,
		regstat : 0,
        hasPassword : 0,
		email  :  '',
		verifyVerified : 0,
		pwdVerified : 0,
        firstname : '',
        lastname : '',
        avatar : '',
        favorites:[]
    };

    // dependencies
    property config;
    property userGateway;
    
 
    function isValid() {
        var result = true;
        if ( !len(getUserName()) or !len(getPassword()) ) {
             setErrorState('missing_login_fields');
        }
        return !hasErrors();

    }
    /* 
     login function
    */
    function attemptLogin() {
        var result = false;
      
        if(! this.isValid()){
            return result;
        } 
        var arUser = variables.userGateway.getUserbyCredentials(getUsername(), getPassword());
      
        if(!isArray(arUser) or arUser.len() eq 0) 
            setErrorState('user_not_found');
        else if(arUser.len() gt 1) 
            setErrorState('duplicate_user');
        // user authenticated    
        else {
            // set up private data with user result from db
            refreshUserfromDB(arUser[1].email);
            // logging in via username and password validates a user to level
            // and we retrieve the array of favorites
            var favs = variables.userGateway.getUserFavorites(arUser[1].pno);
            addUserData({'validated' : 2, favorites: favs})
            result =true;
        }
       
        return result;

    }

    function getUserFromDB ( string email = '') {
        arUser = variables.userGateway.getUserbyEmail(arguments.email);
        return arUser[1];
    }

   function refreshUserfromDB ( string email = '') {
       // retrieve the latest data from db.
       var user = this.getUserFromDB(arguments.email);
       // filter out irrelevant fields 
      defaultUserData = getUserData();
       relevantUserData = user.filter(function(key, value){
           return structKeyExists(defaultUserData, key)
      });
      variables.userData=relevantUserData;
     // return relevantUserData;


    }

    function addUserData(userData = {}) {
        if(!structIsEmpty(userData))
         structAppend(variables.userData, arguments.userData, true);
    }

    function getUserData() {
        return variables.userData;
    }
  

}