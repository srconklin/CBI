component accessors=true  {
  // private data
    variables.errors = {};  // can be reassigned to be used as a string
  
    // internal flags
  variables.modern = true;

  function getErrors() {
    return variables.errors;
  }

  function clearErrors() {
    variables.errors = {};
  }

  function getData() {
    return variables;
  }

  function hasErrors() { 
    var result = false;

    if( (isStruct(variables.errors) and !structIsEmpty(variables.errors)) )
       result = true;
    else if (len(variables.errors))
      result = true;

    return result;

}

}