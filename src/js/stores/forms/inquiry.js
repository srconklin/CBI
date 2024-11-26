//--------------------
//inquiry
//--------------------
import Alpine from 'alpinejs';

Alpine.store('inquiry', {

    //visible
    message: { blurred: false, errorMessage: '', value: '', ele:'visible'},

    //hidden
    ttypeno: {value:10, ele:'hidden'}, // 10 inquiry is default; 5 possible for sending a message
    itemno: {value:0, ele:'hidden'}, // set onload
    refnr: {value:0, ele:'hidden'}, // set on onload for use when sending a TT5 message in dealmaking conversation 

    //utility
    textLimit: 250,
    frmnumber : 1,

    get messageRemain() {
        return this.textLimit - this.message.value.length
    }

});