//--------------------
//pwd
//--------------------
import Alpine from 'alpinejs';

Alpine.store('pwd', {

    //visible
    // reset, register, change password
    pwd1: { blurred: false, errorMessage: '', value: '', ele:'visible'},
    pwd2: { blurred: false, errorMessage: '', value: '', ele:'visible' },

    upper: false,
    lower: false,
    number: false,
    minlength: false,

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
    pwdtests(e) {
        //check for one lowercase letter
        this.lower=this.pwd1.value.match(/[a-z]/g);  
        //check for one uppercase letter
        this.upper=this.pwd1.value.match(/[A-Z]/g);  
        //check for one number
        this.number=this.pwd1.value.match(/[0-9]/g);  
        //check at least 8 characters
        this.minlength=this.pwd1.value.length >= 8;  
            
    },
        
    pwdFailed() {
    return !(this.upper && this.lower && this.number && this.minlength && (!this.pwd2.errorMessage && this.pwd2.value)  );
    },
        

});