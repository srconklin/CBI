component accessors=true extends="model.beans.common" {

     //accessors
    property firstName;
    property lastName;
    property email;
    property coname;
    property phone;
   

    //dependencies
    property utils;
    property config;

    function isValid(){
     
        clearErrors();

        //firstname 
        if ( !len(getFirstName()) ) {
            setErrorState('missingFirstName', 'firstName');
        }else if(utils.hasHTML(getFirstName())) {
            setErrorState('noHTML', 'firstName');
        } else if(len(getFirstName()) gt 20)  {
            setErrorState('firstNameToolong', 'firstName');
        }

        //lastname 
        if ( !len(getlastName()) ) {
            setErrorState('missingLastName', 'lastname');
        } else if ( utils.hasHTML(getLastName())) {
            setErrorState('noHTML', 'lastname');
        } else if (len(getLastName()) gt 30)  {
            setErrorState('lastNameToolong', 'lastname');
        }

        //email 
        if ( !len(getEmail()) ) {
            setErrorState('missingLastName', 'email');
        } else if (!isValid('email', getEmail())) {
            setErrorState('invalidEmail', 'email');
        } else if (len(getEmail()) gt 50)  {
            setErrorState('emailToolong', 'email');
        }

        //company name
        if (utils.hasHTML(getConame())) {
            setErrorState('noHTML', 'coname');
        } else if (len(getConame()) gt 50)  {
            setErrorState('companyToolong', 'coname');
        }

        //tel 
        if ( !len(getPhone()) ) {
            setErrorState('missingPhone', 'phone');
        } else if (len(getPhone()) gt 25)  {
            setErrorState('phonetoolong', 'phone');
        } else if (!isValid("regular_expression", getPhone(), '^\+?\(?(?:([0-9]|\)(?!\)))[ \-\.]?){6,14}[0-9]$')) {
            setErrorState('invalidphone', 'phone');
        }
            
        return !hasErrors();
  }


}