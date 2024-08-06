//--------------------
//contact
//--------------------
import Alpine from 'alpinejs';

Alpine.store('contact', {

    //visible
    name: { blurred: false, errorMessage: '', value: '' , ele:'visible'},
    email: { blurred: false, errorMessage: '', value: '' , ele:'visible'},
    message: { blurred: false, errorMessage: '', value: '', ele:'visible'},
   
    //utility defaults
    textLimit: 250,

    validateEmail(el) {
        const validRegex = /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/;
        this[el.name].blurred = true;
        el.value.match(validRegex) ?  Alpine.store('forms').validateEle(el, this) : this[el.name].errorMessage = 'not a valid email';
    },

    get messageRemain() {
        return this.textLimit - this.message.value.length
    }

});


