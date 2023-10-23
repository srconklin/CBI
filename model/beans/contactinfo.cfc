component accessors=true extends="model.beans.personal" {
  
  // accessors
  property pno;

  // private data

  // dependencies 
  property configservice;

  function isValid( ){
    super.isValid();  
    
    if ( !len(getPno()) or getPno() lt 1) {
      setErrorState('pnoNotFound');
    } 
     
      return !hasErrors();
  }

  private function setForm() {
    
    form.pno = getPno();
    form.firstName = getFirstName();
    form.lastName = getLastName();
    form.email = getEmail();
    form.coname = getConame();
    form.phone1 = getPhone();

  }

  function update(){

    try {

      setForm();
      
      include "/cbilegacy/legacySiteSettings.cfm";
      include "/cbilegacy/procreg2.cfm";
      
    } catch (e) {
      setErrorState(e)
    }    


  }
}