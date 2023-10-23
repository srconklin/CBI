import Alpine from 'alpinejs';
import {handleFormSubmitResponse} from '../formsservice';

//--------------------
//FORMS
//--------------------
Alpine.store('forms', {

//  the captcha
captcha: { blurred: false, errorMessage: '' },

// offer fields
qtyStated: { blurred: false, errorMessage: '', value: 1, forms: ['offer'] },
priceStated: { blurred: false, errorMessage: '', value: '', forms: ['offer'] },
// hidden
//qtyShown: '',
//priceShown: '',

// personal fields
firstName: { blurred: false, errorMessage: '', value: '', forms: ['offer', 'inquiry', 'register']  },
lastName: { blurred: false, errorMessage: '', value: '', forms: ['offer', 'inquiry', 'register']  },
email: { blurred: false, errorMessage: '', value: '', forms: ['offer', 'inquiry', 'register']  },
phone1: { blurred: false, errorMessage: '', value: '', forms: ['offer', 'register']  },
phone2: { blurred: false, errorMessage: '', value: '', forms: ['inquiry', 'register']  },
coname: { blurred: false, errorMessage: '', value: '', forms: ['offer', 'inquiry', 'register']  },

// inquiry and offer field
message: { blurred: false, errorMessage: '', value: '' , forms: ['offer'] },
terms: { blurred: false, errorMessage: '', value: '' },

// register
emailinuse: { blurred: false, errorMessage: '' },
agreetandc: { blurred: false, errorMessage: '', value: false },

// password (reset, register, myaccount change password)
pwd1: { blurred: false, errorMessage: '', value: '' },
pwd2: { blurred: false, errorMessage: '', value: '' },
pwdcurrent: { blurred: false, errorMessage: '', value: '' },

//my address
address1: { blurred: false, errorMessage: '', value: '' },
address2: { blurred: false, errorMessage: '', value: '' },
postalcode: { blurred: false, errorMessage: '', value: '' },
PLocGID: { blurred: false, errorMessage: '', value: '' },
PCyGID: { blurred: false, errorMessage: '', value: '' },

// general utility
generalError: '',
maxqty: 1, //set onLoad of modal
itemno: {value:0, forms: ['offer']}, // set on onload of modal
form: '',
submitting: false,
textLimit: 250,
onBlurPhone1: '',
onBlurPhone2: '',

upper: false,
lower: false,
number: false,
minlength: false,

init() {

// initialize with the intl-tel-input plugin
this.onBlurPhone1 = window.iti('phone1');
this.onBlurPhone2 = window.iti('phone2');

},
getFormFieldsList() {

// console.time('filter with keys from store');
return Object.keys(this).filter(key => this[key].hasOwnProperty('forms') && this[key].forms.includes(this.form));
// console.timeEnd('filter with keys from store');
},

validate(e) {
this.toTarget(e.target)
},

toTarget(el) {
const input = el.name.charAt(0).toUpperCase() + el.name.slice(1);
// custom function exist call that over the validateEle
if (typeof this['validate' + input] === "function")
 this['validate' + input](el)
else
 this.validateEle(el);
},

validateEle(el) {
this[el.name].blurred = true;
this[el.name].value = stripHTML(this[el.name].value, 'blur');
if (!el.checkValidity()) {
 // JS form validation https://www.w3schools.com/js/js_validation_api.asp
 // check for custom message inline on the data element
 const messages = el.dataset.msg ? JSON.parse(el.dataset.msg) : [];
 const msg = messages.find((msg) => el.validity[msg.split(':')[0]]);
 this[el.name].errorMessage = msg != undefined ? msg.split(':')[1] : el.validationMessage;
 return false;
 // no error
} else {
 this[el.name].errorMessage = '';
 return true;
}
},

toggleError(name) { 
return this[name].errorMessage.length>0 && this[name].blurred;
},

// validateFirstName(el) {
//     this.firstName.value = stripHTML(this.firstName.value, 'blur');
//     this.validateEle(el);
// },

// validateLastName(el) {
//     this.lastName.value = stripHTML(this.lastName.value, 'blur');
//     this.validateEle(el);
// },

// validateAddress1(el) {
//     this.address1.value = stripHTML(this.address1.value, 'blur');
//     this.validateEle(el);
// },

// validateAddress2(el) {
//     this.address2.value = stripHTML(this.address2.value, 'blur');
//     this.validateEle(el);
// },

// validatePostalcode(el) {
//     this.postalcode.value = stripHTML(this.postalcode.value, 'blur');
//     this.validateEle(el);
// },

// validateTerms() {
//     this.terms = stripHTML(this.terms, 'blur');
// },

// validateMessage() {
//     this.message = stripHTML(this.message, 'blur');
// },

// validateConame() {
//     this.coname = stripHTML(this.coname, 'blur');
// },

validatePriceStated(el) {
this.priceStated.value = formatCurrency(this.priceStated.value, 'blur');
this.validateEle(el);
},

validateQtyStated(el) {
this[el.name].blurred = true;
Number.isInteger(parseInt(el.value)) ? this.validateEle(el) : this[el.name].errorMessage = 'not a valid number';
},

validatePhone1(el) {
const result = this.onBlurPhone1(el.value);
this[el.name].blurred = true;
result.success ? this.validateEle(el) : this[el.name].errorMessage = result.error;
},

validatePhone2(el) {
const result = this.onBlurPhone2(el.value);
this[el.name].blurred = true;
result.success ? this.validateEle(el) : this[el.name].errorMessage = result.error;
},

validatePLocGID(el) {
if (!this.PLocGID.value.length) {
 const messages = el.dataset.msg ? JSON.parse(el.dataset.msg) : [];
 const msg = messages.find((msg) => msg.split(':')[0] === 'valueMissing');
 this.PLocGID.blurred = true;
 this.generalError = msg.split(':')[1];             
} else {
 this.PLocGID.blurred = false;
 this.PLocGID.errorMessage = '';
}
},

validatePwd2(el) {
let error ='';

if (this.pwd1.value != this.pwd2.value && (this.pwd1.value.length && this.pwd2.value.length))  {
 error='mustMatch';                
} else if (!this.pwd2.value.length) {
 error='valueMissing';                
}

if (error) {
 const messages = el.dataset.msg ? JSON.parse(el.dataset.msg) : [];
 const msg = messages.find((msg) => msg.split(':')[0] === error);
 this.pwd2.blurred = true;
 this.pwd2.errorMessage = msg.split(':')[1];
}    
else {
 this.pwd2.blurred = false;
 this.pwd2.errorMessage = '';
}
},
pwdtests(e) {
//check for one lowercase letter
this.lower=this.pwd1.value.match(/[a-z]/g);  
//check for one uppercase letter
this.upper=this.pwd1.value.match(/[A-Z]/g);  
//check for one number
this.number=this.pwd1.value.match(/[0-9]/g);  
//check at least 8 characters
this.minlength=this.pwd1.value.length >= 8;  

},

pwdFailed() {
return !(this.upper && this.lower && this.number && this.minlength && (!this.pwd2.errorMessage && this.pwd2.value)  );
},

get total() {
return this.priceStated.value && this.qtyStated.value ? formatter.format(parseFloat(this.priceStated.value.replace(/[^0-9.]/g, '')).toFixed(2) * this.qtyStated.value) : '$0.00';
},

get termsRemain() {
return this.textLimit - this.terms.value.length
},

get messageRemain() {
return this.textLimit - this.message.value.length
},
processForm (frmData) {
// fn to process the form submit (called from promise to captcha below)

//validate form fields before attempting fetch
if (!this.validateForm(frmData)) 
return false;

// trigger spinning icon on button and disable it
this.submitting = true;

try {
    submitForm(`/${this.form}`, frmData).then(resObj => handleFormSubmitResponse(resObj, this))
} catch (error) {
  console.log(error);
}


},

validateForm(frmData) {

// sometimes we have more than one form on the page that shares the same elements. (firstname) we need to capture the
// ordinal position of the form to validate the correct one. we expect the form to tell us its position. 
// if not present them assume only one form.
//  const frmNumber = frmData.get('frmPos') ? frmData.get('frmPos') : 0;
const frmNumber = this.form == 'inquiry' ? 1 : 0;

/* iterate over the keys of the form fields, find the property in the alpine store, check if it has a blurred property,
run the validation routine, return if we have any errors.
note: sometimes we have more than one form on the page that shares the same elements. (firstname)
we need to capture the ordinal position of the form to validate the correct one. 
we expect the form to tell us its position. if not present them assume only one form.*/ 
// for (const [key, value] of frmData.entries()) {
//     console.log(key)
//     if (this[key] && this[key].hasOwnProperty('blurred')) {
//         const el = document.getElementsByName(key);
     
//         (el.length == 1) ? this.toTarget(el[0]) : this.toTarget(el[frmNumber])
//         if (this[key].errorMessage || this.generalError) 
//             return false;
//     }
// }

// get list of required fields for the current form
const arEles = this.getFormFieldsList();

// iteratte over exact listy of required fields and see if we have a value in the sumbitted object
for(let i = 0; i<arEles.length;i++){
 let key = arEles[i]
 //not found in submitted form data, add it
 if(!frmData.get(key)) 
     frmData.append(key, this[key].value);

 if (this[key] && this[key].hasOwnProperty('blurred')) {
     const el = document.getElementsByName(key);
     (el.length == 1) ? this.toTarget(el[0]) : this.toTarget(el[frmNumber])
     if (this[key].errorMessage || this.generalError) 
         return false;
 }
}

return true;
},

submit(frm) {
this.form=frm;
// get the data on the form by its name + frm
const frmData = new FormData(document.getElementById(`${this.form}frm`));

// add in checkboxes that do not get added to formdata when not checked, excluding checked ones
for (const ele of document.querySelectorAll('input[type=checkbox]')) {
 if(this[ele.name] && this[ele.name].hasOwnProperty('blurred') && !frmData.get(ele.name)) {
     frmData.append(ele.name, this[ele.name].value);
 }
}


// use a promise-based function to get a capatcha token followed by processing the form  
window.validateCaptcha(`/${this.form}`)
 .then(token => { frmData.append('g-recaptcha-response', token); })
 .then(this.processForm(frmData))
 .catch(window.captchaError);
}

});