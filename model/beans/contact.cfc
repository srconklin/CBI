component accessors=true extends="model.beans.common"{
    //accessors
    property name;
	property email;
	property message;
	
    // private data

    //dependencies
    property utils;
    property config;
    property general;
    
    
    function isValid( ){

         //name 
         if ( !len(getname()) ) {
            setErrorState('missingname', 'name');
        } else if ( utils.hasHTML(getname())) {
            setErrorState('noHTML', 'name');
        } else if (len(getname()) gt 60)  {
            setErrorState('nameToolong', 'name');
        }

        //email 
        if ( !len(getEmail()) ) {
            setErrorState('missingLastName', 'email');
        } else if (!isValid('email', getEmail())) {
            setErrorState('invalidEmail', 'email');
        } else if (len(getEmail()) gt 50)  {
            setErrorState('emailToolong', 'email');
        }
  
        if (!len(getMessage()) ) {
            setErrorState('missingMessage', 'message');
        }  
        else if(utils.hasHTML(getMessage())) {
            setErrorState('noHTML', 'message');
        } else if (len(getMessage()) gt 250)  {
            setErrorState('tooLong', 'message');
        }
        

        return !hasErrors();
  }

  function messageSent() {
    return (hasErrors()) ? false: true;
  }
    
  function sendMessage(){

    try{
       //send email
       var contacts = general.getVenueContacts();
       include "/cbilegacy/legacySiteSettings.cfm";
       cfmail( to = "#contacts.VenAdmEmail#" , 
               cc= "#contacts.InvAdmEmail#,#contacts.ccEmail#", 
               from = "#getname()# <#request.SysMailSender#>", 
               replyto="#getname()# <#getEmail()#>" 
               failto = "#request.SysMailSender#",  
               type="html" 
               subject = "Question or Comment From a Contact us Message" ) { 
                    include '/views/common/fragment/Contactus.cfm';
    }
       
    } catch (e) {
        setErrorState(e)
        
    }    
    return messageSent();
  }



}