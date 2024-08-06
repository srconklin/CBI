import Alpine from 'alpinejs';

// combine 2nd level stores function
const getStoreKeysFromFile = (store) => Object.keys(Alpine.store(store)).filter(key => key!='init');

// virtual stores
Alpine.store('updatecontactinfo', {});
Alpine.store('resetpassword', {});
Alpine.store('updateCommPref', {'generalError' : ''});

// The stores that need annotating 
const stores = ['offer', 'inquiry', 'register', 'updatecontactinfo', 'changepassword','updateaddress','resetpassword','contact'];

/************************************************
 every store gets the standard base functions
************************************************/
for(let i = 0; i< stores.length;i++) {
    const store = stores[i];
    Alpine.store(store)['generalError']  = '';
    Alpine.store(store)['validate']  = (e) => Alpine.store('forms').toTarget(e.target, Alpine.store(store));
    Alpine.store(store)['toggleError']  = (name) => Alpine.store(store)[name].errorMessage.length>0 && Alpine.store(store)[name].blurred;
}

/*************************************
  forms that need the PERSONAL fields
*************************************/

const personforms = ['offer', 'inquiry', 'register', 'updatecontactinfo'];
// personal fields 
const personalfields = ['firstName', 'lastName', 'email', 'coname', 'phone'];

for(let i = 0; i< personforms.length;i++) {
    const store = personforms[i];

    for(let j = 0; j< personalfields.length;j++) {
        const key = personalfields[j];
        Alpine.store(store)[key] = { blurred: false, errorMessage: '', value: '', ele:'visible' };
    }

    // stores that get the personal form also need the phone validator method. Phone a part of peronsal fields
    Alpine.store(store)['validatePhone'] = (el) => {
        const result = Alpine.store(store).phoneHandler(el.value);
        Alpine.store(store)[el.name].blurred = true;
        result.success ?  Alpine.store('forms').validateEle(el, Alpine.store(store)) : Alpine.store(store)[el.name].errorMessage = result.error;
    }
}    

// pwdmgr
// get the pwdmgr properties from the store file definition
const pwdmgr = getStoreKeysFromFile('pwd');
// forms that have the password mgr on the form
const pwdforms = ['register', 'changepassword', 'resetpassword'];
for(let i = 0; i< pwdforms.length;i++) {
    const store = pwdforms[i];
    for(let j = 0; j< pwdmgr.length;j++) {
        const prop = pwdmgr[j];
        Alpine.store(store)[prop] = Alpine.store('pwd')[prop];
    }
    
}    
 
