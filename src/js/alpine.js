import './utils'
import Alpine from 'alpinejs';
import { refinementList } from 'instantsearch.js/es/widgets';

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

    makeToast() {
        if (sessionStorage.getItem('register'))
            this.createToast('Welcome! Your new profile was sucessfully created', 'You can view or change your membership by visiting <a href="/myprofile">My Account</a>.', 'info');
        if (sessionStorage.getItem('offer'))
            this.createToast('Success! Your offer was recieved', 'Someone will contact you soon.', 'success');
        if (sessionStorage.getItem('inquiry'))
            this.createToast('Success! Your message was recieved', 'Someone will contact you soon.', 'success');
        if (sessionStorage.getItem('isNewPerson'))
            this.createToast('Welcome ' + sessionStorage.getItem('firstName') + ', We created a user account for you!', 'Consider verifying your email, setting a password and completing your profile to enjoy all the benefits of a membership by visiting <a href="/myprofile">My Account</a>.', 'info');
        else if (sessionStorage.getItem('hasNotLoggedIn'))
            this.createToast('Welcome Back ' + sessionStorage.getItem('firstName') + '!', 'We noticed you have made an offer/inquiry before. Consider verifying  your email, setting a password and completing your profile to enjoy all the benefits of a membership by visiting <a href="/myprofile">My Account</a>.', 'info');
        else if (sessionStorage.getItem('loginviaForm'))
            this.createToast('Welcome Back ' + sessionStorage.getItem('firstName') + '!', 'We have logged you in to simplify making additional inquiries and offers. You can view or change your membership by visiting <a href="/myprofile">My Account</a>.', 'info');

        sessionStorage.clear();
    }
});


//--------------------
//FORMS
//--------------------
Alpine.store('forms', {

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

    // general
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

    get total() {
        return this.priceStated.value && this.qtyStated.value ? formatter.format(parseFloat(this.priceStated.value.replace(/[^0-9.]/g, '')).toFixed(2) * this.qtyStated.value) : '$0.00';
    },

    get termsRemain() {
        return this.textLimit - this.terms.length
    },

    get messageRemain() {
        return this.textLimit - this.message.length
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
        const route = `/${this.form}`;

        const data = new FormData(document.getElementById(`${this.form}frm`));

        // note getElementsByName can returns two fields for the same name (one on each tab) we need to relate the form to an ordinal number to validate the correct one
        const frmNumber = (this.form == 'inquiry' ? 1 : 0);

        // fn to process the form submit (called from promise to captcha below)
        const processForm = () => {

            const theform = this.form;

          
            // get the properties of this alpine store and filter out ones that do not have blurred property, then get either ones that are specfic to the form being submitted or does 
            // not have the form prop at all which means it is belongs to all forms.
            const toBeValidated = Object.entries(this).filter(([key, value]) => {
                    return value && value.hasOwnProperty('blurred') && (!value.hasOwnProperty('form') || value.form == theform)
                }
            );
            

            // for those inputs, call any custom methods for validation otherwise call standard validateele
            toBeValidated.forEach(ele => {
                const el = document.getElementsByName(ele[0]);
                if (el.length) {
                    (el.length == 1) ? this.toTarget(el[0]) : this.toTarget(el[frmNumber])
                };
            });


            // if any of the properites for errorMessage have been set, then abort.
            if (toBeValidated.find((ele) => ele[1].errorMessage)) return;

            // trigger spinning icon on button and disable it
            this.submitting = true;

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


                            } else {
                                // no refresh so show push method and close the modal if one open
                                Alpine.store('toast').makeToast();
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
        this.validateCaptcha(route)
            .then(token => { data.append('g-recaptcha-response', token); })
            .then(processForm)
        //    .catch(this.captchaError);

    }

});

// WATCHERS
Alpine.effect(() => {
    const modal = Alpine.store('imodal').modal;
    const content = Alpine.store('imodal').content;

    // when the modal closes, then reset the caroursel and forms back to some defaults       
    if (modal === false) {

        console.log('modal closed');
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