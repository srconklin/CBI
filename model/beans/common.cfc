component accessors=true  {
  // can be reassinged to be used as a string
  variables.errors = {};  

  function getErrors() {
    return variables.errors;
  }

  function clearErrors() {
    variables.errors = {};
  }

}