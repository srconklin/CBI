component accessors=true  {

    // dependencies 
    property config;

    // private data
    variables.errors = {};  // can be reassigned to be used as a string
    variables.status = {};      
    variables.errorType = '';
    variables.errorOriginal = {};
    variables.statusOriginal = '';
    
    // internal flags
    variables.modern = true;

    function getErrors() {
      return variables.errors;
    }

   function clearErrors() {
      variables.errors = {};
      variables.status = {};      
      variables.errorType = '';
      variables.errorOriginal = {};
      variables.statusOriginal = '';
    }

    function getData() {
      return variables;
    }

    function getStatus() {
        return variables.status;
    }

    function getOriginalStatus() {
        return variables.status;
    }

    function getErrorContext() {
      return {
        'error': getErrors(),
        'status': getStatus(),
        'errorType' :variables.errorType,
        'originalError' : variables.errorOriginal,
        'originalStatus' : variables.statusOriginal
       

      }
    }

    function hasErrors() { 
      var result = false;

      if( (isStruct(variables.errors) and !structIsEmpty(variables.errors)) )
        result = true;
      else if (len(variables.errors))
        result = true;

      return result;

   }

   function setErrorState(any key='', string field='', string origstatus = '') {
    
      if(len(arguments.key)) {
          
          // field present means we are creating a struct of errors for each field
          if(len(arguments.field)) {
            variables.errors[arguments.field] = config.lookUpStatus(arguments.key);
            variables.status[arguments.field] = arguments.key;
            variables.statusOriginal = 'na';
            variables.errorType = 'fieldmatchederror';
          }
          // key only present 
          // either 
          // 1) simple error string for non visible field
          // 2) a slug for a title instruction content lookup later
          // 3) a cf exception object (custom or system)

          else {

            // user defined cfthrow from Dynaprice or a real cf thrown exception
            if(isStruct(arguments.key) and structKeyExists(arguments.key, 'errorCode')) {

              if (arguments.key.type eq 'dperror') {
                // our own message we want the world to see
                variables.errors = arguments.key.message;  
                //custom thrown error; we only want the message
                variables.errorType = 'customException';
                // dperror in the status is a flag to store a message away to survive page reloads
                // controller must store away error message in persisted state for deferred retrieval
                variables.status = 'dperror';
                // 'dperror' status will fail testing; save the the user defined errorcode away for unit tests
                variables.statusOriginal = arguments.key.errorcode;

              // the cfthrow error object
              } else {
                
                // Cleanse the cf error message to generic one
                variables.errors = config.lookUpStatus('catchall');
                // full exception stored here SENDEMAIL using this
                variables.errorOriginal = arguments.key;  
                variables.errorType = 'cfException';
                // status application will not be found in content an so will defer to catchall in content 
                variables.status = 'application';
                 // 'application' error status not so useful; save the the cf errorcode for better diagnostics
                variables.statusOriginal = arguments.key.errorcode;
              }

            } 

            // Slug for content lookup or key to message error
            else {
              // original key stored a way for reference. can be overwritten by user friendly one.
              variables.statusOriginal = arguments.key;

              // key may not always be found; reset to user directed slug that will find a lookup message
              variables.status = arguments.key;

              // lookup Status returns notfound if no match in messages ; assume it to a slug
              variables.errors = config.lookUpStatus(arguments.key);
              
              if (variables.errors eq 'notfound') {
                variables.errorType = 'slug';
              
                // now lets try to get some better message into the errors key than just a repeat of the status
                // this is needed for beans used in ajax and nonajax scenarios where the bean returns a slug that is not found in messages
                // we look to content to bridge the gap and find a suitable message to show the ajax version
                variables.errors = config.getContent('', arguments.key);

              }
              else 
                variables.errorType = 'message';

              
            }
        }

        if(len(arguments.origStatus))
          variables.statusOriginal = arguments.origStatus;
     
      }   
      else     
        clearErrors();
    }

}