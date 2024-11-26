
import Alpine from 'alpinejs';

//--------------------
//FORMS
//--------------------
Alpine.store('forms', {

form: '',
fobj:'',
submitting: false,

initialize(form) {
    this.form=form;
    // Get the form element
    const theform = document.getElementById(`${this.form}frm`);

    // Get the pathname directly from the form's action attribute
    const pathname = new URL(theform.action).pathname;

    this.formAction = pathname ?  pathname : `/${this.form}`;
    this.fobj = Alpine.store(this.form);
    this.clearErrors();
    
},
clearErrors() {
    const arEles = this.getFormFieldsList();
    // iterate over exact list of required fields and see if we have a value in the sumbitted object
    for(let i = 0; i<arEles.length;i++){
        const key = arEles[i];
        if (this.fobj[arEles[i]].hasOwnProperty('errorMessage')) 
            this.fobj[arEles[i]].errorMessage = '';
    }
    this.fobj.generalError = '';
},

createFormDataObject() {

        // use formdata object to get form values
       const frmData = new FormData(document.getElementById(`${this.form}frm`));

        // add in checkboxes that do not get added to formdata when not checked, excluding checked ones
        for (const ele of document.querySelectorAll('input[type=checkbox]')) {
            if(this.fobj[ele.name] && this.fobj[ele.name].hasOwnProperty('blurred') && !frmData.get(ele.name)) {
                frmData.append(ele.name, this.fobj[ele.name].value);
            }
        }
        // add in hidden fields
        this.getHiddenFormFields().forEach(ele => {
            if(!frmData.get(ele)) 
                frmData.append(ele, this.fobj[ele].value);
             
        });

        return frmData;
    
},

getFormFieldsList() {
    return Object.keys(this.fobj).filter(key => this.fobj[key].hasOwnProperty('ele'));
},

getHiddenFormFields() {
    return Object.keys(this.fobj).filter(key => this.fobj[key].hasOwnProperty('ele') && this.fobj[key].ele == 'hidden');
},

getformNumber() {
    return this.fobj['frmnumber'] ? this.fobj['frmnumber'] : 0;
},

toTarget(el, formstore) {
  
    const input = el.name.charAt(0).toUpperCase() + el.name.slice(1);
    // custom function exist in the formstore call that over the validateEle
    if (typeof formstore['validate' + input] === "function")
        formstore['validate' + input](el)
    else
        this.validateEle(el,formstore);
},

validate(e) {
    this.toTarget(e.target, this);
},

validateEle(el,formstore) {
    formstore[el.name].blurred = true;
    formstore[el.name].value = stripHTML(formstore[el.name].value, 'blur');
    if (!el.checkValidity()) {
        // JS form validation https://www.w3schools.com/js/js_validation_api.asp
        // check for custom message inline on the data element
        const messages = el.dataset.msg ? JSON.parse(el.dataset.msg) : [];
        const msg = messages.find((msg) => el.validity[msg.split(':')[0]]);
        formstore[el.name].errorMessage = msg != undefined ? msg.split(':')[1] : el.validationMessage;
        return false;
    // no error
    } else {
        formstore[el.name].errorMessage = '';
        return true;
    }
},
validateForm() {

    // get list of ALL fields (visible + hiddens) for the current form
    const arEles = this.getFormFieldsList();
    // iterate over exact list of required fields and see if we have a value in the sumbitted object
    for(let i = 0; i<arEles.length;i++){
        let key = arEles[i]
        // the blur property is an indication that the field is to be validated
        if (this.fobj[key].hasOwnProperty('blurred') && document.getElementsByName(key).length) {
            // get a handle to the dom element
            const el = document.getElementsByName(key);
            
            // account for the possiblity of forms that have a field with the same name twice. (people fragment)
            // then call toTarget to kickoff validation
            if (el.length == 1) 
                this.toTarget(el[0], this.fobj);
            else
                this.toTarget(el[this.getformNumber()], this.fobj);

            if (this.fobj[key].errorMessage || this.fobj.generalError)    {
                console.log(this.fobj[key].errorMessage);
                return false;
            }      
         }
    }

    return true;
},

submit(frm) {
   
    // fn to process the form submit (called from promise to captcha below)
    // trigger spinning icon on button and disable it
    this.submitting = true;
    
    // initialize form store and reset errors
    this.initialize(frm);

    // get the data on the form
    let frmData = this.createFormDataObject();
    
    // use a promise-based function to get a capatcha token followed by validating/processing the form  
    window.getCaptchaToken(this.formAction)
        // append token to form object
        .then(token => frmData.append('g-recaptcha-response', token))
        // validate the data entry by the user. if it fails break chain and throw an error
        .then(() =>  { if(!this.validateForm()) throw new Error("validationFailed"); })
        // process form which makes backend call to server
        //.then(resObj => this.handleFormSubmitResponse(resObj)))
        .then(() => window.submitForm(this.formAction, frmData).then((resObj => this.handleFormSubmitResponse(resObj))))
        // error handler
        .catch(error =>  { if(error.message == 'validationFailed')  this.fobj.generalError='Please fix the validation errors and try again.'})
        .then(() =>  this.submitting = false)
 },

 handleFormSubmitResponse(resobj) {
        /*******************************
         *  server side errors   
        *********************************/
        if (!resobj.res) {
          
            // an error that we don't report to same data input screen but rather redirect to a new route  
            if (resobj.payload.redirect)
             location.href = resobj.payload.redirect;
    
            // error is a string from backend then form must have a general error div
            if( typeof resobj.errors === 'string' ) {
                this.fobj.generalError =`${resobj.errors}`;
                // this.fobj.generalError = resobj.errors;
            // bean errors in the form of object with key values    
            } else {
                
                for (const [key, value] of Object.entries(resobj.errors)) {
                    this.fobj[key].blurred = true;
                    this.fobj[key].errorMessage = value;
                }
                    
            } 
      
    /*********************************
      *  success no validation errors    
    *********************************/
    } else {
            sessionStorage.setItem(this.form, true);
    
            if (Object.keys(resobj.payload).length > 0) {
                
                if (resobj.payload.firstName)
                   sessionStorage.setItem('firstName', resobj.payload.firstName);
        
                // push message into session storage if we have one
                if (resobj.payload.message)
                    sessionStorage.setItem(resobj.payload.message, true);
        
                // a redirect to a new route  
                if (resobj.payload.redirect)
                    location.href = resobj.payload.redirect;
                // refresh and stay on same route to reveal the toast
                else
                    location.reload();
        
        
            } else {
                // no refresh so show push method and close the modal if one open
                Alpine.store('toasts').makeToast();
                Alpine.store('item').closeModal();
        
            }

        }
      
    }

});