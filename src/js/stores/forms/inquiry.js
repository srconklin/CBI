//--------------------
//inquiry
//--------------------
import Alpine from 'alpinejs';

Alpine.store('inquiry', {

    //visible
    message: { blurred: false, errorMessage: '', value: '', ele:'visible'},

    //hidden
    ttypeno: {value:10, ele:'hidden'}, // 10 inquiry
    itemno: {value:0, ele:'hidden'}, // set on onload of modal watcher

    //utility
    textLimit: 250,
    frmnumber : 1,

    get messageRemain() {
        return this.textLimit - this.message.value.length
    }

});