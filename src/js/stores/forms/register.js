//--------------------
//Register
//--------------------
import Alpine from 'alpinejs';

Alpine.store('register', {

    // visible
    agreetandc: { blurred: false, errorMessage: '', value: false, ele:'visible' },

    //hidden

    //utility
    emailinuse: { blurred: false, errorMessage: '' },

});