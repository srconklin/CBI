//-----------------------
//reply for dealmaking
//------------------------
import Alpine from 'alpinejs';

Alpine.store('reply', {

    //visible
    message: { blurred: false, errorMessage: '', value: '', ele:'visible'},

    //hidden 
    ttypeno: {value:5, ele:'hidden'}, // 5 is a response to a message

    //utility defaults
    textLimit: 250,
    frmnumber : 0,

   
    get messageRemain() {
        return this.textLimit - this.message.value.length
    }

        

});


