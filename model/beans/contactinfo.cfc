component accessors=true extends="model.beans.personal" {
  
  // accessors
  property pno;

  // private data

  // dependencies 
  property configservice;

  function isValid( ){
    super.isValid();  
    
    if ( !len(getPno()) or getPno() lt 1) {
      variables.errors["pno"] =  config.getContent('ContactInfo', 'pno').instruction; 
    } 
     
      return structCount(variables.errors) ? false: true;
  }

  private function setForm() {
    
    form.pno = getPno();
    form.firstName = getFirstName();
    form.lastName = getLastName();
    form.email = getEmail();
    form.coname = getConame();
    form.phone1 = getPhone1();

  }

  function update(){

    try {

      setForm();
      
      include "/cbilegacy/legacySiteSettings.cfm";
      include "/cbilegacy/procreg2.cfm";
      
    } catch (e) {
      variables.errors =e;
    }    


  }
}