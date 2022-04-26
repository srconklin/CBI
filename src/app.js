// window functions

window.formatter = new Intl.NumberFormat('en-US', {
  style: 'currency',
  currency: 'USD'
});
window.stripHTML = (s) => s.toString().replace(/(<([^>]+)>)/gi, '');
window.integerOnly = (n) => n.toString().replace(/[^0-9]/g, '');
window.formatNumber = (n) => addCommas(integerOnly(n));
// https://stackoverflow.com/questions/2901102/how-to-print-a-number-with-commas-as-thousands-separators-in-javascript
// window.addCommas = (x) => x.toString().replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ',');
window.addCommas = (x) => {
  var parts = x.toString().split(".");
    parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    return parts.join(".");
};
window.validTelNumber = (n) => n.toString().replace(/[^0-9\s-\+()\.]/g, '');
window.formatCurrency = (val, blur) => {
  if(!val) return '';
  const mapper = (e,i) => i==1 ?  (blur === "blur") ? formatNumber(e).concat('00').substring(0, 2) : formatNumber(e).substring(0, 2) : formatNumber(e);
  return (val.indexOf(".") >= 0) ?  val.split(".").map(mapper).join(".") :  (blur === "blur") ? formatNumber(val).concat('.00') : formatNumber(val);
 };


 window.iti = (el) => {
  const phone = document.getElementById(el);
  
  if (phone){

      // const errorMap = ["Invalid number", "Invalid country code", "Too short", "Too long", "Invalid number"];
      const phoneInput = window.intlTelInput(phone, {
        utilsScript: "https://cdn.jsdelivr.net/npm/intl-tel-input@17/build/js/utils.min.js"
      });
      const blurHandler = (val) => {
        
          if (!val) return {success: true};
          const phoneNumber = phoneInput.getNumber().trim();

          if (phoneInput.isValidNumber()) {
            phoneInput.setNumber(phoneNumber);
            return {
              success: true,
              e164: phoneNumber
            }
          } else {
            return {
              success:false,
              error : 'Invalid Number'
              }
          
          }
      }
      return blurHandler;
    }
}

window.largeSOnly = function() {
  return window.matchMedia( "(min-width: 1150px)" ).matches
}      
window.smallSOnly = function() {
  return window.matchMedia( "(max-width: 640px)" ).matches
}      

// import { data } from 'autoprefixer';
// import { XML_1_0 } from 'xmlchars';
import { search } from './js/instantsearch';
search.start();


/*****************
Methods
*****************/

async function fetchItemAsJSON(itemno) {
  const response = await fetch(`/data/${itemno}.json`, {method: 'GET' });
  const data = await response.json();
  return data;
}

function configureItem() {
  if (!document.getElementById('item')) 
    return;
  
  loadImageCount();
  Spruce.store('offer').qtyStated.value =  document.getElementById('item').getAttribute('qty');
  Spruce.store('offer').maxqty =  document.getElementById('item').getAttribute('qty');
  Spruce.store('offer').itemno =  document.getElementById('item').getAttribute('itemno');
  Spruce.store('offer').priceStated.value =  document.getElementById('item').getAttribute('price') == 'Best Price' ? '' : document.getElementById('item').getAttribute('price').replace('$', '');
  
}

function loadImageCount() {
    const ct = document.getElementById('item').getAttribute('itemct');
    Spruce.store('carousel').slides = Array(parseInt(ct));
}

/*****************
 Spruce Stores
*****************/
Spruce.store('tabs', () => {

  return {
    openTab :1, 
    content: {
      specstable: ''
    },
    activeTabClasses : 'activeTab',  
    inactiveTabClasses : 'inActiveTab',  
    activeBtnClasses : 'activeBtn', 
    inactiveBtnClasses : 'inActiveBtn',
    showActiveTab (tab) {
       return this.openTab === tab ? this.activeTabClasses :this.inactiveTabClasses
    },
    showActiveButton (tab) {
      return this.openTab === tab ? this.activeBtnClasses :this.inactiveBtnClasses
    }
  }
})

Spruce.store('carousel', () => {
 
    return {
      slides: [],
      skip: 1,
      //active: 1,
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
    }  
});

// showItem details in modal
Spruce.store('imodal', () => {

  return  { 
    modal: false, 
    content: false,
    showModal() {
     // document.body.style.overflow = 'hidden';
    },
    closeModal(e) {
      document.body.style.overflow = 'unset';
      this.modal = false; 
    },
    showItem(itemno) {

      try {
        fetchItemAsJSON(itemno).then(data => {
          this.content = data;
          this.content.itemses = data.pagetitle.toLowerCase().replace(/\s/g, '+'); 
          this.modal = true;
        });
      } catch (error) {
         console.log(error);
      }
    }
  }
})

Spruce.store('offer', () => { 
  const textLimit = 250;
  // intl-tel-input plugin
  const itiBlur = iti('phone1');
    
  return  { 

    // offer fields
    qtyStated :  {offer: true, blurred: false, errorMessage: '', value:1},
    priceStated: {offer: true, blurred: false, errorMessage: '', value:''},
    
    qtyShown :  '',
    priceShown: '',
    
    // personal fields
    firstName : {blurred: false, errorMessage: ''},
    lastName : {blurred: false, errorMessage: ''},
    email : {blurred: false, errorMessage: ''},
    phone1: {blurred: false, errorMessage: ''},
    terms: '',

    // inquiry and offer field
    message: '',

    maxqty: 1,
    //default is inquiry 
    ttypeno: 10,
    submitting: false,
    submitted: false,
    validate (e) {
       this.toTarget(e.target)
    },
    toTarget (el) {
      //const el = e.target;
      const input =  el.name.charAt(0).toUpperCase() + el.name.slice(1);
      // custom function exist call that over the validateEle
      if (typeof this['validate'+input] === "function" )
        this['validate'+input](el)
      else 
        this.validateEle(el);
    },
    validateEle (el) {
      this[el.name].blurred = true;
      if (!el.checkValidity())  {
         const messages = el.dataset.msg ? JSON.parse(el.dataset.msg) : [];
         const msg = messages.find( (msg) => el.validity[msg.split(':')[0]]);
         this[el.name].errorMessage = msg != undefined ? msg.split(':')[1] : el.validationMessage;
        //   this[el.name].errorMessage = el.validationMessage;
        return false;
       // no error
      } else {
        this[el.name].errorMessage ='';
        return true;
      }
    }, 
    validateTerms () {
      this.terms = stripHTML(this.terms, 'blur');
    },
    validateMessage () {
      this.message = stripHTML(this.message, 'blur');
    },
     validatePriceStated (el) {
      this.priceStated.value= formatCurrency(this.priceStated.value, 'blur');
      this.validateEle(el);
    },
    validatePhone1 (el) {
        const result = itiBlur(el.value);
       this[el.name].blurred = true; 
        result.success ? this.validateEle(el) : this[el.name].errorMessage =result.error;
    },
    get total() {
        return this.priceStated.value && this.qtyStated.value ? formatter.format( parseFloat( this.priceStated.value.replace(/[^0-9.]/g, '')).toFixed(2) *  this.qtyStated.value) : '$0.00';
    },
    get termsRemain() {
      return textLimit - this.terms.length
    },
    get messageRemain() {
      return textLimit - this.message.length
    },
    submit() {

      // determine which form is submitting
      const offer = this.ttypeno == 11;
      const form = this.ttypeno == 11 ? document.getElementById("offerfrm") : document.getElementById("inquiryfrm");
      const route = this.ttypeno == 11 ? '/offer' : '/inquiry';
      const data = new FormData(form);
    
      let error;  
      // get the inputs that are to be validated (they have a blurred property)
      const inputs = Object.entries(this).filter((ele) => {
        if (!ele[1].hasOwnProperty('blurred')) 
          return false;
        if (!document.getElementById(ele[0]))
          return false;
        let target=true;
        if (this.ttypeno == 10 && ele[1].hasOwnProperty('offer'))
           target = false;
        return target;   
      });
      // for those inputs, call any custom methods for validation otherwise call standard validateele
      inputs.forEach(ele => this.toTarget(document.getElementById(ele[0]))); 

       const errors = inputs.find((ele) => ele[1].errorMessage);
       if (!errors ) {
         this.submitting = true;
         let success =false;
            try {
              fetch(route, {
                  method: 'POST',
                  body: data 
                })
              .then(response => response.json())
              .then(data => {
                if (!data.res) {
                  console.log(data);
                    for (const [key, value] of Object.entries(data.errors)) {
                      this[key].blurred = true;
                      this[key].errorMessage = value;
                    }
                } else
                  success =true;
              });
          } catch (error) {
            console.log(error);
          } finally {
            setTimeout(() => {
              this.submitting = false;
              this.submitted = success;
            }, 700);
          }
      }


     }
  }
})
/***********
 watchers 
************/

// when modal closes reset some defaults
Spruce.watch('imodal.modal', value => {
  
  if (!value) {
     const reset = {
      blurred:false, 
      errorMessage: ''
     }
          
      Spruce.store('carousel').slides = [],
      Spruce.store('carousel').scrolling =false,
      Spruce.store('carousel').active = 0;
      //Spruce.store('offer').priceStated.value = '';
      Spruce.store('offer').submitted = false;
      Spruce.store('offer').priceStated = {...Spruce.store('offer').priceStated, ...reset, ...{value:''}}
      Spruce.store('offer').qtyStated = {...Spruce.store('offer').qtyStated, ...reset}
    }
  })
 // when new content is fetched for the item; pass image/tab data off to their respective components for mgmt.
Spruce.watch('imodal.content', content => {
    if (content) {
      Spruce.store('carousel').slides = [ `${content.imgbase}${content.imgMain}`, ... content.imagesXtra.map( image => `${content.imgbase}${image}`)]
      Spruce.store('tabs').content.specstable =  content.specstable;
      Spruce.store('offer').qtyStated.value =  content.qty;
      Spruce.store('offer').priceStated.value =  content.price == 'Best Price' ? '' : content.price.replace('$', '');
      Spruce.store('offer').qtyShown =  content.qty;
      Spruce.store('offer').priceShown =  content.price == 'Best Price' ? '' : content.price.replace(/[\$,]/g, '');
      Spruce.store('offer').maxqty =  content.qty;
      Spruce.store('offer').itemno =  content.itemno;
      content = {... content, specstable:undefined, imagesXtra:undefined, imgMain:undefined };
      
      setTimeout(() => {
        //window.imageZoom('img_0', 'img_container0', 'img-result'); 
        document.getElementById('slider').scrollLeft=0;  
      },100);
    
    }
  })
  
  Spruce.watch('tabs.openTab', value => {
    Spruce.store('offer').submitted = false;
  })

/***********************
  Helper functions
***********************/
let domReady = (cb) => {
  document.readyState === 'interactive' || document.readyState === 'complete'
    ? cb()
    : document.addEventListener('DOMContentLoaded', cb);
};

domReady(() => {
    setTimeout(() => {
        configureItem()
        
     }, 200);

});
