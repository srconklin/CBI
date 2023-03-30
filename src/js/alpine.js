import { getConfigSetting } from './config'
import './utils'
import Alpine from 'alpinejs';
import { refinementList } from 'instantsearch.js/es/widgets';
// import { config } from 'process';

//--------------------
// TABS
//--------------------
Alpine.store('tabs', {

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

});


//--------------------
// CAROUSEL
//--------------------
Alpine.store('carousel', {
    slides: [],
    skip: 1,

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

});

//--------------------
// IMODAL
//--------------------
Alpine.store('imodal', {

    modal: undefined,
    content: false,

    closeModal(e) {
        this.modal = false;
    },

    showItem(itemno) {

        try {
            fetchItemAsJSON(itemno).then(data => {
                this.content = data;
                this.content.itemses = data.pagetitle.toLowerCase().replace(/\s/g, '+');
                this.modal = true;
                //document.getElementById('priceStated').focus();
            });
        } catch (error) {
            console.log(error);
        }
    }
});

//--------------------
// TOASTS
//--------------------
Alpine.store('toasts', {

    counter: 0,
    list: [],

    //title, message, type = "info"
    createToast({title, message, type = "info"}) {
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

        console.log(this.list)
    },

    destroyToast(index) {
        this.list[index].visible = false
    },

    makeToast() {

        let keys = Object.keys(sessionStorage);
        for(let key of keys) {
          
           let toast = getConfigSetting('toasts', key)
           if (toast) {
            //this.createToast(toast.title, toast.message, toast.type);
            // convert placeholders to live data
            toast.title = toast.title.replace('firstName', sessionStorage.getItem('firstName'))
            this.createToast(toast);
           }
           
        }
        sessionStorage.clear();
    }
});


//--------------------
//FORMS
//--------------------
Alpine.store('forms', {
     
    //   properties: presence of blurred property means it has a validation rule; i.e. needs to be validated
    
    //  the captcha
    captcha: { blurred: false, errorMessage: '' },

    // offer fields
    qtyStated: { blurred: false, errorMessage: '', value: 1 },
    priceStated: { blurred: false, errorMessage: '', value: '' },
    qtyShown: '',
    priceShown: '',

    // personal fields
    firstName: { blurred: false, errorMessage: '', value: '' },
    lastName: { blurred: false, errorMessage: '', value: '' },
    email: { blurred: false, errorMessage: '', value: '' },
    phone1: { blurred: false, errorMessage: '', value: '' },
    phone2: { blurred: false, errorMessage: '', value: '' },
    coname: '',
    terms: '',

    // inquiry and offer field
    message: '',

    // register
    //password: { blurred: false, errorMessage: '' },
    emailinuse: { blurred: false, errorMessage: '' },
    agreetandc: { blurred: false, errorMessage: '', value: false },

    // password (reset, register, myaccount change password)
    pwd1: { blurred: false, errorMessage: '', value: '' },
    pwd2: { blurred: false, errorMessage: '', value: '' },
    upper: false,
    lower: false,
    number: false,
    minlength: false,

    // general
    generalError: '',
    maxqty: 1,
    form: '',
    submitting: false,
    textLimit: 250,
    captchaEnabled: true,
    onBlurPhone1: '',
    onBlurPhone2: '',

    init() {

        // initialize with the intl-tel-input plugin
        this.onBlurPhone1 = window.iti('phone1');
        this.onBlurPhone2 = window.iti('phone2');

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

    validateFirstName(el) {
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
        const result = this.onBlurPhone1(el.value);
        this[el.name].blurred = true;
        result.success ? this.validateEle(el) : this[el.name].errorMessage = result.error;
    },

    validatePhone2(el) {
        const result = this.onBlurPhone2(el.value);
        this[el.name].blurred = true;
        result.success ? this.validateEle(el) : this[el.name].errorMessage = result.error;
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
    // validateAgreetandc(el) {
    //         if(!this.agreetandc) {
    //             const error ='valueMissing';
    //             const messages = el.dataset.msg ? JSON.parse(el.dataset.msg) : [];
    //             const msg = messages.find((msg) => msg.split(':')[0] === error);
    //             this.agreetandc.blurred = true;
    //             this.agreetandc.errorMessage = msg.split(':')[1];
    //         } else {
    //             this.agreetandc.blurred = false;
    //             this.agreetandc.errorMessage ='';
    //         }
            
    // },
    pwdtests(e) {
        //check for one lowercase letter
        this.lower=this.pwd1.value.match(/[a-z]/g);  
        //check for one uppercase letter
        this.upper=this.pwd1.value.match(/[A-Z]/g);  
        //check for one number
        this.number=this.pwd1.value.match(/[0-9]/g);  
        //check for one number
        this.minlength=this.pwd1.value.length >= 8;  

    },


    pwdFailed() {
        return !(this.upper && this.lower && this.number && this.minlength && (!this.pwd2.errorMessage && this.pwd2.value)  );
    },

    get total() {
        return this.priceStated.value && this.qtyStated.value ? formatter.format(parseFloat(this.priceStated.value.replace(/[^0-9.]/g, '')).toFixed(2) * this.qtyStated.value) : '$0.00';
    },

    get termsRemain() {
        return this.textLimit - this.terms.length
    },

    get messageRemain() {
        return this.textLimit - this.message.length
    },

    submit() {
        // the current route
        const route = `/${this.form}`;
        // get the data on the form by
        const data = new FormData(document.getElementById(`${this.form}frm`));

        // add in checkboxes that do not get added to formdata when not checked, excluding checked ones
        for (const ele of document.querySelectorAll('input[type=checkbox]')) {

            if(this[ele.name] && this[ele.name].hasOwnProperty('blurred') && !data.get(ele.name)) {
                data.append(ele.name, this[ele.name].value);
            }

        }
        // sometimes we have more than one form on the page that shares the same elements. (firstname) we need to capture the
        // ordinal position of the form to validate the correct one. we expect the form to tell us its position. if not present them assume only one form.
        const frmNumber = data.get('frmPos') ? data.get('frmPos') : 0;
        // the elements to be validated
        const toBeValidated = [];
       
        // fn to process the form submit (called from promise to captcha below)
        const processForm = () => {
           
          /* iterate over the keys of the form fields, find the property in the alpine store, check if it has a blurred property,
            run the validation routine, return if we have any errors
            note: sometimes we have more than one form on the page that shares the same elements. (firstname)
            we need to capture the ordinal position of the form to validate the correct one. 
            we expect the form to tell us its position. if not present them assume only one form.*/ 
            for (const [key, value] of data.entries()) {
                console.log(key)
                if (this[key] && this[key].hasOwnProperty('blurred')) {
                    const el = document.getElementsByName(key);
                  
                    (el.length == 1) ? this.toTarget(el[0]) : this.toTarget(el[frmNumber])
                    if (this[key].errorMessage) 
                    return;
                }
            }

            // trigger spinning icon on button and disable it
            this.submitting = true;
         
            try {
                fetch(route, {
                    headers: {
                        'X-Requested-With' : 'XMLHttpRequest'
                    },
                    method: 'POST',
                    body: data
                })
                    .then(response => response.json())
                    .then(data => {
                        console.log(data);
                        // server side errors caught
                        if (!data.res) {

                            // error is a string from backend then form must have a general error div
                            if( typeof data.errors === 'string' ) {
                                this.generalError = data.errors;
                             // bean errors in the form of object with key values    
                            } else {
                              
                                for (const [key, value] of Object.entries(data.errors)) {
                                    this[key].blurred = true;
                                    this[key].errorMessage = value;
                                }
                            } 
                                
                            // create a slight delay  in turning off the spin icon on the submit button.
                            setTimeout(() => { this.submitting = false; }, 700);
                            // success no validation errors    
                        } else {
                            sessionStorage.setItem(this.form, true);
                            // if we have a payload then we have identified a new person; a returning user who has yet to login with a password OR a new registree
                            
                            if (Object.keys(data.payload).length > 0) {

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


                            } else {
                                // no refresh so show push method and close the modal if one open
                                Alpine.store('toasts').makeToast();
                                this.submitting = false;
                                Alpine.store('imodal').closeModal();

                            }

                        }
                    });
                // error handler    
            } catch (error) {
                console.log(error);
            }

        }
        // use a promise-based function to get a capatcha token followed by processing the form  
        window.validateCaptcha(route)
            .then(token => { data.append('g-recaptcha-response', token); })
            .then(processForm)
            .catch(window.captchaError);
    }

});

// WATCHERS
Alpine.effect(() => {
    const modal = Alpine.store('imodal').modal;
    const content = Alpine.store('imodal').content;

    // when the modal closes, then reset the caroursel and forms back to some defaults       
    if (modal === false) {

       // console.log('modal closed');
        const reset = {
            blurred: false,
            errorMessage: ''
        }

        Alpine.store('carousel').slides = [];
        Alpine.store('carousel').scrolling = false;
        Alpine.store('carousel').active = 0;
        Alpine.store('forms').priceStated = { ...Alpine.store('forms').priceStated, ...reset, ...{ value: '' } };
        Alpine.store('forms').qtyStated = { ...Alpine.store('forms').qtyStated, ...reset };
        Alpine.store('imodal').content = false;

    } else if (modal) {

        console.log('modal opened');

        // if the modal has recieved some new content from a new item fetch
        // reset the commponents with data fetched from the item 
        if (content) {

            Alpine.store('carousel').slides = [`${content.imgbase}${content.imgMain}`, ...content.imagesXtra.map(image => `${content.imgbase}${image}`)]
            Alpine.store('tabs').content.specstable = content.specstable;
            Alpine.store('tabs').openTab = 1;
            Alpine.store('forms').qtyStated.value = content.qty;
            Alpine.store('forms').priceStated.value = content.price == 'Best Price' ? '' : content.price.replace('$', '');
            Alpine.store('forms').qtyShown = content.qty;
            Alpine.store('forms').priceShown = content.price == 'Best Price' ? '' : content.price.replace(/[\$,]/g, '');
            Alpine.store('forms').maxqty = content.qty;
            Alpine.store('forms').itemno = content.itemno;
            //Alpine.store('imodal').content = { ...content, specstable: undefined, imagesXtra: undefined, imgMain: undefined };

            // reset the slider to the first scroll position
            setTimeout(() => {
                document.getElementById('slider').scrollLeft = 0;
                document.getElementById('priceStated').focus();
            }, 100);

        }
    }

})


export { Alpine as alpine }