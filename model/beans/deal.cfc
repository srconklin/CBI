component accessors=true extends="model.beans.personal" {
    //accessors
	property itemno default="0" ;
    property qtyStated;
    property priceStated;
    property qtyShown;
    property priceShown;
	property terms;
	property message;
    // deal type inquiry=10, offer=11
    property ttypeno;
	
    // private data
    variables.offerSent = false;
    
    /* 
      business logic data:
	
		These variables CAN  be set in the legacy system:
		pno  
        newperson -  0=exisiting email; 1=found 
        validated
        regstat

	
    */
    // 
    variables.newperson; 
   
    // the registration profile setting that is stored in the db of a user. 
    // 0=found in db but never logged in. inserted from a previous offer/inquiry, no passsord and should not be able to manage profile
    // 1=found in db and user has properly registered; set a password and verified email ownership (in legacy system 1 means all fields entered)
    // read bt proctrans when partially logging the user in
    variables.regstat; 

    // validated is current status of the user making the offer/inquiry  (in memory variable that shows the follwoing status)
    // 0=guest who has an account but is not logged in OR a new user we don't know about; the default
    // 1=recognized so partially logged in;  (session.validate to 1 in proctrans)
    // 2=fully logged in with complete profile
    // note if the user came in with a 0 then it gets flipped to one; can be 2 from a login in which case it is it not affected by proctrans
    variables.validated;
    
    // the pno can be set from 0 to 1 if the user is recognized in the system based on the email.
    variables.pno;
    
    // if the user has a password set
    variables.hasPassword = 0
    
    // if the user has verified their email
    variables.verifyVerified = 0

    variables.vizPagetop;

    //dependencies
    property utils;
    property config;
    property userService;
    
    
    function isValid( ){

        if (!hiddenNotValid())
            return false;
            
        // base handler is personal bean
        // only called the isvalid on the base component when the user is not logged in.
        if (!userService.getUserSession().isloggedIn)
            super.isValid();
   
        // only on make offer screen
        if (getTtypeno() eq 11) {

            //qty 
            if ( !len(getQtyStated()) ) {
                setErrorState('qtyMissing', 'qtyStated');
            } else if (!isValid('Numeric', replaceNoCase(getQtyStated(), ',', ''))) {
                setErrorState('invalidNumber', 'qtyStated');
            } else if (getQtyStated() gt 9999)  {
                setErrorState('maxQty', 'qtyStated');
            }

            
            // price
            if ( !len(getPriceStated()) ) {
                setErrorState('priceMissing', 'priceStated');
            } else if (!isValid('float', replaceNoCase(getPriceStated(), ',', ''))) {
                setErrorState('invalidPrice', 'priceStated');
            } else if (getPriceStated() gt 9999999)  {
                setErrorState('maxPrice', 'priceStated');
            }

            // terms     
            if (len(getTerms()) ) {
                if(utils.hasHTML(getTerms())) {
                    setErrorState('noHTML', 'terms');
                } else if (len(getTerms()) gt 250)  {
                    setErrorState('tooLong', 'terms');
                }
            }
        }

         // message required on inquiry only  
        if (getttypeno() eq 10 and !len(getMessage()) ) {
            setErrorState('missingMessage', 'message');
        }  

        else if(utils.hasHTML(getMessage())) {
            setErrorState('noHTML', 'message');
        } else if (len(getMessage()) gt 250)  {
            setErrorState('tooLong', 'message');
        }
        

        return !hasErrors();
  }

  function hiddenNotValid( ){

     //ttypeno 
     if (!listfindnocase('10,11', getTTypeno())) {
       setErrorState('badTypeno'); 
     } 
     //itemno 
     if ( !len(getItemno()) or getItemno() eq 0 ) {
        setErrorState('badItemno'); 
    } else if (!isValid('Numeric', replaceNoCase(getItemno(), ',', ''))) {
        setErrorState('badItemno'); 
    }

    return !hasErrors();

  }

  function isNewPerson() {
       return variables.newPerson;
  }  

  function offerSentSuccesfully() {
    return (hasErrors() or !variables.offerSent) ? false: true;
  }
    
  function sendOffer(){

    variables.offerSent = true;

    // interface to dynabuilt system by meeting requirements of template as an include
    setOfferer(userService.getUserSession());
    setForm();

    try{
        include "/cbilegacy/legacySiteSettings.cfm";
        include "/cbilegacy/proctrans.cfm";
        
    } catch (e) {
        setErrorState(e)
        
    }    
    return offerSentSuccesfully();
  }

  private function setOfferer(user={}) {
    
    variables.validated = user.validated;
    variables.pno = user.pno;
    variables.vizPagetop = user.vwrCoRelatNo;

  }

  private function setForm() {
   
	form.ccSender = true;
    form.itemno = getItemno();
    form.qtyStated = getQtyStated();
    form.priceStated = getPriceStated();
    form.qtyShown = getQtyShown();
    form.priceShown = getPriceShown();
	form.terms = getTerms();
	form.message = getMessage();
    form.ttypeno = getttypeno();
    form.firstName = getFirstName();
    form.lastName = getLastName();
    form.email = getEmail();
    form.coname = getConame();
    form.phone1 = getPhone();

  }



}