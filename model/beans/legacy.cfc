component accessors=true  {
  // can be reassinged to be used as a string
  variables.errors = {};  

  
  function init() {
    // set flag to circumvent certain elements; redirects, html, data validation etc.
    variables.modern = true;

  }

  function makeLegacyCall(string serverTemplate  = '', struct legacyvars = {}) {
  
      structAppend(variables, legacyvars, true);
      include "/cbilegacy/legacySiteSettings.cfm";
      // some session variables like pno will get set in legacy system
      include "/cbilegacy/#arguments.serverTemplate#.cfm";
      return variables;
   
  }

  

}