// window functions

window.formatter = new Intl.NumberFormat('en-US', {
  style: 'currency',
  currency: 'USD'
});
// valid input includes alpha characters and full stop,comma,apostrophe,dash and space
window.validInput = (s) => s.toString().replace(/[^\p{L} '.,-]/gui, '');
// window.validInput = (s) => s.toString().replace(/[0-9~`!@#%&=_";:><\(\)\^\$\|\?\*\+\{\}\[\]\\\/]/gi, '');
window.stripHTML = (s) => s.toString().replace(/(<([^>]+)>)/gi, '');
window.integerOnly = (n) => n.toString().replace(/[^0-9]/g, '');
window.formatNumber = (n) => addCommas(integerOnly(n));
// https://stackoverflow.com/questions/2901102/how-to-print-a-number-with-commas-as-thousands-separators-in-javascript
// window.addCommas = (x) => x.toString().replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ',');
window.addCommas = (x) => {
  var parts = x.toString().split(".");
  parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",");
  return parts.join(".");
};
window.validTelNumber = (n) => n.toString().replace(/[^0-9\s-\+()\.]/g, '');
window.formatCurrency = (val, blur) => {
  if (!val) return '';
  const mapper = (e, i) => i == 1 ? (blur === "blur") ? formatNumber(e).concat('00').substring(0, 2) : formatNumber(e).substring(0, 2) : formatNumber(e);
  return (val.indexOf(".") >= 0) ? val.split(".").map(mapper).join(".") : (blur === "blur") ? formatNumber(val).concat('.00') : formatNumber(val);
};


window.iti = (el) => {
  const phone = document.getElementById(el);
  if (phone) {

    // const errorMap = ["Invalid number", "Invalid country code", "Too short", "Too long", "Invalid number"];
    const phoneInput = window.intlTelInput(phone, {
      utilsScript: "https://cdn.jsdelivr.net/npm/intl-tel-input@17/build/js/utils.min.js"
    });
    const blurHandler = (val) => {

      if (!val) return { success: true };
      const phoneNumber = phoneInput.getNumber().trim();

      if (phoneInput.isValidNumber()) {
        phoneInput.setNumber(phoneNumber);
        return {
          success: true,
          e164: phoneNumber
        }
      } else {
        return {
          success: false,
          error: 'Invalid Number'
        }

      }
    }
    return blurHandler;
  }
}

window.largeSOnly = function () {
  return window.matchMedia("(min-width: 1150px)").matches
}
window.smallSOnly = function () {
  return window.matchMedia("(max-width: 640px)").matches
}

// import { data } from 'autoprefixer';
// import { XML_1_0 } from 'xmlchars';
import { search } from './js/instantsearch';
search.start();


/*****************
Methods
*****************/

async function fetchItemAsJSON(itemno) {
  const response = await fetch(`/data/${itemno}.json`, { method: 'GET' });
  const data = await response.json();
  return data;
}

function configureItem() {
  if (!document.getElementById('item'))
    return;

  loadImageCount();
  Spruce.store('forms').qtyStated.value = document.getElementById('item').getAttribute('qty');
  Spruce.store('forms').maxqty = document.getElementById('item').getAttribute('qty');
  Spruce.store('forms').itemno = document.getElementById('item').getAttribute('itemno');
  Spruce.store('forms').priceStated.value = document.getElementById('item').getAttribute('price') == 'Best Price' ? '' : document.getElementById('item').getAttribute('price').replace('$', '');

}
function makeToast() {
 /// console.log(sessionStorage.getItem('register'));

  if (sessionStorage.getItem('register'))
    Spruce.store('toasts').createToast('Welcome! Your new profile was sucessfully created', 'You can view or change your membership by visiting <a href="/myprofile">My Account</a>.', 'info');
  if (sessionStorage.getItem('offer'))
    Spruce.store('toasts').createToast('Success! Your offer was recieved', 'Someone will contact you soon.', 'success');
  if (sessionStorage.getItem('inquiry'))
    Spruce.store('toasts').createToast('Success! Your message was recieved', 'Someone will contact you soon.', 'success');
  if (sessionStorage.getItem('isNewPerson'))
    Spruce.store('toasts').createToast('Welcome ' + sessionStorage.getItem('firstName') + '!. We created a user account for you', 'Consider setting a password and completing your profile to enjoy all the benefits of a membership by visiting <a href="/myprofile">My Account</a>.', 'info');
  else if (sessionStorage.getItem('hasNotLoggedIn'))
    Spruce.store('toasts').createToast('Welcome Back ' + sessionStorage.getItem('firstName') + '!', 'We noticed you have made an offer/inquiry before. Consider setting a password and completing your profile to enjoy all the benefits of a membership by visiting <a href="/myprofile">My Account</a>.', 'info');
  else if (sessionStorage.getItem('loginviaForm'))
    Spruce.store('toasts').createToast('Welcome Back ' + sessionStorage.getItem('firstName') + '!', 'We have logged you in to simplify making additional inquiries and offers. You can view or change your membership by visiting <a href="/myprofile">My Account</a>.', 'info');
  
  sessionStorage.clear();

}
function loadImageCount() {
  const ct = document.getElementById('item').getAttribute('itemct');
  Spruce.store('carousel').slides = Array(parseInt(ct));
}

/*****************
 Spruce Stores
*****************/
Spruce.store('tabs', () => {

  return {
    openTab: 1,
    content: {
      specstable: ''
    },
    activeTabClasses: 'activeTab',
    inactiveTabClasses: 'inActiveTab',
    activeBtnClasses: 'activeBtn',
    inactiveBtnClasses: 'inActiveBtn',
    showActiveTab(tab) {
      return this.openTab === tab ? this.activeTabClasses : this.inactiveTabClasses
    },
    showActiveButton(tab) {
      return this.openTab === tab ? this.activeBtnClasses : this.inactiveBtnClasses
    }
  }
})

Spruce.store('carousel', () => {

  return {
    slides: [],
    skip: 1,
    //active: 1,
    next() {

      this.to((current, offset) => current + (offset * this.skip))
    },
    prev() {
      this.to((current, offset) => current - (offset * this.skip))
    },
    to(strategy) {
      let slider = document.getElementById('slider');

      let current = slider.scrollLeft
      let offset = slider.lastElementChild.getBoundingClientRect().width
      let goto = strategy(current, offset);
      slider.scrollTo({ left: goto, behavior: 'smooth' })
      //this.active = Math.min(Math.max(Math.round(goto / offset)+1, 1), this.slides.length);
    }
  }
});

// showItem details in modal
Spruce.store('imodal', () => {

  return {
    modal: false,
    content: false,
    showModal() {
      // document.body.style.overflow = 'hidden';
    },
    closeModal(e) {
      document.body.style.overflow = 'unset';
      this.modal = false;
    },
    showItem(itemno) {

      try {
        fetchItemAsJSON(itemno).then(data => {
          this.content = data;
          this.content.itemses = data.pagetitle.toLowerCase().replace(/\s/g, '+');
          this.modal = true;
        });
      } catch (error) {
        console.log(error);
      }
    }
  }
})

Spruce.store("toasts", {
  counter: 0,
  list: [],
  createToast(title, message, type = "info") {
    const index = this.list.length
    let totalVisible =
      this.list.filter((toast) => {
        return toast.visible
      }).length + 1
    this.list.push({
      id: this.counter++,
      message,
      title,
      type,
      visible: true,
    })
    if (type != 'info') {
      setTimeout(() => {
        this.destroyToast(index)
      }, 2500 * totalVisible)
    }
  },
  destroyToast(index) {
    this.list[index].visible = false
  },
})

Spruce.store('forms', () => {
  const textLimit = 250;
  const captchaEnabled = true;

  // intl-tel-input plugin
  const onBlurPhone1 = iti('phone1');
  const onBlurPhone2 = iti('phone2');

  return {

    //  the captcha
    captcha: { blurred: false, errorMessage: '' },

    // offer fields
    qtyStated: { offer: true, form: 'offer', blurred: false, errorMessage: '', value: 1 },
    priceStated: { offer: true, form: 'offer', blurred: false, errorMessage: '', value: '' },
    qtyShown: '',
    priceShown: '',

    // personal fields
    firstName: { blurred: false, errorMessage: '', value: '' },
    lastName: { blurred: false, errorMessage: '', value: '' },
    email: { blurred: false, errorMessage: '', value: '' },
    phone1: { blurred: false, offer: true, form: 'offer', errorMessage: '', value: '' },
    phone2: { blurred: false, inquiry: true, form: 'inquiry', errorMessage: '', value: '' },
    coname: '',
    terms: '',

    // inquiry and offer field
    message: '',

    // register
    password: { blurred: false, form: 'register', errorMessage: '' },
    emailinuse: { blurred: false, form: 'register', errorMessage: '' },

    maxqty: 1,
    form: '',
    submitting: false,
    validate(e) {
      this.toTarget(e.target)
    },
    toTarget(el) {
      //const el = e.target;
      const input = el.name.charAt(0).toUpperCase() + el.name.slice(1);
      // custom function exist call that over the validateEle
      if (typeof this['validate' + input] === "function")
        this['validate' + input](el)
      else
        this.validateEle(el);
    },
    validateEle(el) {
      this[el.name].blurred = true;
      if (!el.checkValidity()) {
        // JS form validation https://www.w3schools.com/js/js_validation_api.asp
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
    validateFirstName(el) {
      //  this.firstName.value = validInput(this.firstName.value, 'blur');
      this.firstName.value = stripHTML(this.firstName.value, 'blur');
      this.validateEle(el);
    },
    validateLastName(el) {
      this.lastName.value = stripHTML(this.lastName.value, 'blur');
      this.validateEle(el);
    },
    validateTerms() {
      this.terms = stripHTML(this.terms, 'blur');
    },
    validateMessage() {
      this.message = stripHTML(this.message, 'blur');
    },
    validateConame() {
      this.coname = stripHTML(this.coname, 'blur');
    },
    validatePriceStated(el) {
      this.priceStated.value = formatCurrency(this.priceStated.value, 'blur');
      this.validateEle(el);
    },
    validateQtyStated(el) {
      this[el.name].blurred = true;
      Number.isInteger(parseInt(el.value)) ? this.validateEle(el) : this[el.name].errorMessage = 'not a valid number';
    },
    validatePhone1(el) {
      const result = onBlurPhone1(el.value);
      this[el.name].blurred = true;
      result.success ? this.validateEle(el) : this[el.name].errorMessage = result.error;
    },
    validatePhone2(el) {
      const result = onBlurPhone2(el.value);
      this[el.name].blurred = true;
      result.success ? this.validateEle(el) : this[el.name].errorMessage = result.error;
    },
    get total() {
      return this.priceStated.value && this.qtyStated.value ? formatter.format(parseFloat(this.priceStated.value.replace(/[^0-9.]/g, '')).toFixed(2) * this.qtyStated.value) : '$0.00';
    },
    get termsRemain() {
      return textLimit - this.terms.length
    },
    get messageRemain() {
      return textLimit - this.message.length
    },
    validateCaptcha(route) {
      // https://www.delftstack.com/howto/javascript/javascript-wait-for-function-to-finish/
      return new Promise((res, rej) => {
        grecaptcha.ready(() => {
          grecaptcha.execute('6LevHMkfAAAAAInPcjzzNLUUgvmKoeDzcIg4G6qS', { action: route }).then((token) => res(token));
        });
      });
    },
    captchaError(error) {
      console.log(`Error recieved in getting captcha token/processing form ${error}`);
    },
    submit() {
      // const settings = getSettings();

      // const route = settings[this.ttypeno].route;
      const route = `/${this.form}`;
      // const data = new FormData(settings[this.ttypeno].formdata);
      const data = new FormData(document.getElementById(`${this.form}frm`));
      // note getElementsByName can returns two fields for the same name (one on each tab)
      // we need to relate the form to an ordinal number to validate the correct one
      const frmNumber = (this.form == 'inquiry' ? 1: 0);
      // We need to use the one on the form we f
      // fn to process the form submit (called from promise to captcha below)
      const processForm = () => {
        const theform = this.form;
        // get the properties of this spruce store an filter out ones that do not have blurred property, then get either ones that are specfic to the form being submitted or does 
        // not have the form prop at all which means it is belongs to all forms.
        const toBeValidated = Object.entries(this).filter(([key, value]) => value.hasOwnProperty('blurred') && (!value.hasOwnProperty('form') || value.form == theform));
        // for those inputs, call any custom methods for validation otherwise call standard validateele
        toBeValidated.forEach(ele => {
          const el = document.getElementsByName(ele[0]);
          if (el.length) {
            (el.length == 1) ? this.toTarget(el[0]) :  this.toTarget(el[frmNumber]) 
          };
        });
        //  if any of the properites for errorMessage have been set, then abort.
        if (toBeValidated.find((ele) => ele[1].errorMessage)) return;
        // trigger spinning icon on button and disable it
        this.submitting = true;
        // let success =false;
        //  let payload;
        try {
          fetch(route, {
            method: 'POST',
            body: data
          })
            .then(response => response.json())
            .then(data => {
              console.log(data);
              // server side errors caught
              if (!data.res) {
                for (const [key, value] of Object.entries(data.errors)) {
                  this[key].blurred = true;
                  this[key].errorMessage = value;
                }
                // create a slight delay  in turning off the spin icon on the submit button.
                setTimeout(() => { this.submitting = false; }, 700);
                // success no validation errors    
              } else {
                sessionStorage.setItem(this.form, true);
                // if we have a payload then we have identified a new person; a returning user who has yet to login with a password OR a new registree
                if (data.payload) {

                  sessionStorage.setItem('firstName', data.payload.firstName);

                  // push message into session storage if we have one
                  if (data.payload.message) 
                    sessionStorage.setItem(data.payload.message, true);
                  
                  // a redirect to a new route  
                  if (data.payload.redirect)
                    location.href = data.payload.redirect;
                  // refresh and stay on same route to reveal the toast
                  else 
                    location.reload();

                  // if (data.payload.isNewPerson)
                  //   sessionStorage.setItem('isNewPerson', true);
                  // else if (!data.payload.regstat) 
                  //   sessionStorage.setItem('hasNotLoggedIn', true);
                  // else if (data.payload.regstat)
                  //   sessionStorage.setItem('loginviaForm', true);
                  
                } else {
                  // no refresh so show push method and close the modal if one open
                  makeToast();
                  this.submitting = false;
                  Spruce.store('imodal').closeModal(); 

                }

              }
            });
          // error handler    
        } catch (error) {
          console.log(error);
        }

      }
      // use a promise-based function to get a capatcha token followed by processing the form  
      this.validateCaptcha(route)
        .then(token => { data.append('g-recaptcha-response', token); })
        .then(processForm)
        .catch(this.captchaError);
    }
  }
})
/***********
 watchers 
************/

// when modal closes reset some defaults
Spruce.watch('imodal.modal', value => {

  if (!value) {
    const reset = {
      blurred: false,
      errorMessage: ''
    }

    Spruce.store('carousel').slides = [],
    Spruce.store('carousel').scrolling = false,
    Spruce.store('carousel').active = 0;
    Spruce.store('forms').priceStated = { ...Spruce.store('forms').priceStated, ...reset, ...{ value: '' } }
    Spruce.store('forms').qtyStated = { ...Spruce.store('forms').qtyStated, ...reset }
  }
})
// when new content is fetched for the item; pass image/tab data off to their respective components for mgmt.
Spruce.watch('imodal.content', content => {
  if (content) {
    Spruce.store('carousel').slides = [`${content.imgbase}${content.imgMain}`, ...content.imagesXtra.map(image => `${content.imgbase}${image}`)]
    Spruce.store('tabs').content.specstable = content.specstable;
    Spruce.store('forms').qtyStated.value = content.qty;
    Spruce.store('forms').priceStated.value = content.price == 'Best Price' ? '' : content.price.replace('$', '');
    Spruce.store('forms').qtyShown = content.qty;
    Spruce.store('forms').priceShown = content.price == 'Best Price' ? '' : content.price.replace(/[\$,]/g, '');
    Spruce.store('forms').maxqty = content.qty;
    Spruce.store('forms').itemno = content.itemno;
    content = { ...content, specstable: undefined, imagesXtra: undefined, imgMain: undefined };

    setTimeout(() => {
      //window.imageZoom('img_0', 'img_container0', 'img-result'); 
      document.getElementById('slider').scrollLeft = 0;
    }, 100);

  }
})

// Spruce.watch('tabs.openTab', value => {
//   Spruce.store('forms').submitted = false;
// })

/***********************
  Helper functions
***********************/
let domReady = (cb) => {
  document.readyState === 'interactive' || document.readyState === 'complete'
    ? cb()
    : document.addEventListener('DOMContentLoaded', cb);
};

domReady(() => {
  setTimeout(() => {
    configureItem();
    makeToast()

  }, 200);

});
