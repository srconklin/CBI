//--------------------
//offer
//--------------------
import Alpine from 'alpinejs';

Alpine.store('offer', {

    //visible
    qtyStated: { blurred: false, errorMessage: '', value: 1, ele:'visible'},
    priceStated: { blurred: false, errorMessage: '', value: '', ele:'visible'},
    message: { blurred: false, errorMessage: '', value: '', ele:'visible'},
    terms: { blurred: false, errorMessage: '', value: '' , ele:'visible'},

    //hidden 
    ttypeno: {value:11, ele:'hidden'}, // 11 is a counteroffer
    qtyShown: {value:1, ele:'hidden'}, // set on onload of modal watcher
    priceShown: {value:0, ele:'hidden'}, // set on onload of modal watcher
    itemno: {value:0, ele:'hidden'}, // set on onload of modal watcher
    refnr: {value:0, ele:'hidden'}, // set on onload for use when sending a TT5 message or an offer in dealmaking conversation 


    //utility defaults
    maxqty: 1, //set onLoad of modal watcher
    textLimit: 250,
    frmnumber : 0,

    validatePriceStated(el) {
        this.priceStated.value = formatCurrency(this.priceStated.value, 'blur');
        Alpine.store('forms').validateEle(el, this);
    },

    validateQtyStated(el) {
        this[el.name].blurred = true;
        Number.isInteger(parseInt(el.value)) ?  Alpine.store('forms').validateEle(el, this) : this[el.name].errorMessage = 'not a valid number';
    },
  
    get total() {
        return this.priceStated.value && this.qtyStated.value ? formatter.format(parseFloat(this.priceStated.value.replace(/[^0-9.]/g, '')).toFixed(2) * this.qtyStated.value) : '$0.00';
    },

    get messageRemain() {
        return this.textLimit - this.message.value.length
    },

    get termsRemain() {
        return this.textLimit - this.terms.value.length
    }
        

});


