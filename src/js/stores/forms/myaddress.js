//--------------------
//myaddress
//--------------------
import Alpine from 'alpinejs';

Alpine.store('myaddress', {

    // visible
    address1: { blurred: false, errorMessage: '', value: '' , ele: 'visible' },
    address2: { blurred: false, errorMessage: '', value: '' , ele: 'visible' },
    postalcode: { blurred: false, errorMessage: '', value: '', ele: 'visible'  },
    
    // not visible but treated like
    PLocGID: { blurred: false, errorMessage: '', value: '', ele: 'visible'  },
    PCyGID: { blurred: false, errorMessage: '', value: '', ele: 'visible' },
    //PStPGID: { value: '', ele: 'visible' },

    // hidden

    validatePLocGID(el) {
        if (!el.value.length) {
            const messages = el.dataset.msg ? JSON.parse(el.dataset.msg) : [];
            const msg = messages.find((msg) => msg.split(':')[0] === 'valueMissing');
            this.PLocGID.blurred = true;
            this.generalError = msg.split(':')[1];             
        } else {
            this.PLocGID.blurred = false;
            this.PLocGID.errorMessage = '';
        }
    },

    validatePCyGID(el) {
        if (!el.value.length) {
            const messages = el.dataset.msg ? JSON.parse(el.dataset.msg) : [];
            const msg = messages.find((msg) => msg.split(':')[0] === 'valueMissing');
            this.PCyGID.blurred = true;
            this.generalError = msg.split(':')[1];             
        } else {
            this.PCyGID.blurred = false;
            this.PCyGID.errorMessage = '';
        }
    },

});