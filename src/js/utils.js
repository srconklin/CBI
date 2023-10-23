import intlTelInput from 'intl-tel-input';

// window functions
window.formatter = new Intl.NumberFormat('en-US', {
    style: 'currency',
    currency: 'USD'
  });
  // matches any kind of letter from any language and full stop,comma,apostrophe,dash and space
  // window.stripInvalidChars = (s) => s.toString().replace(/[^\p{L} '.,-]/gui, '');
  // window.stripInvalidCharsForPostal = (s) => s.toString().replace(/[^\p{L}[^0-9] -]/gui, '');
  // window.stripInvalidCharsForAddress = (s) => s.toString().replace(/[^\p{L}[^0-9] #'.,-;]/gui, '');
  window.stripInvalidChars = (s, type) => {
    let regex;

    switch(type) {
      case 'pc':
        regex = /[^\p{L}\d -]/gui;
        break;
      case 'ad':
        regex = /[^\p{L}\d #'.:,-;\/]/gui;
        break;
      default:
        regex = /[^\p{L} '.,-]/gui;
    } 
    return s.toString().replace(regex, '');
  }
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
    if (!val) return '';
    const mapper = (e, i) => i == 1 ? (blur === "blur") ? formatNumber(e).concat('00').substring(0, 2) : formatNumber(e).substring(0, 2) : formatNumber(e);
    return (val.indexOf(".") >= 0) ? val.split(".").map(mapper).join(".") : (blur === "blur") ? formatNumber(val).concat('.00') : formatNumber(val);
  };
  
  window.iti = (el) => {
    const phone = document.getElementById(el);
    if (phone) {
  
      // const errorMap = ["Invalid number", "Invalid country code", "Too short", "Too long", "Invalid number"];
      const phoneInput = intlTelInput(phone, {
        utilsScript: "https://cdn.jsdelivr.net/npm/intl-tel-input@17/build/js/utils.min.js"
      });
      const blurHandler = (val) => {
  
        if (!val) return { success: true };
        const phoneNumber = phoneInput.getNumber().trim();
  
        if (phoneInput.isValidNumber()) {
          phoneInput.setNumber(phoneNumber);
          return {
            success: true,
            e164: phoneNumber
          }
        } else {
          return {
            success: false,
            error: 'Invalid Number'
          }
  
        }
      }
      return blurHandler;
    }
  }
  
  window.largeSOnly = () => {
    return window.matchMedia("(min-width: 1150px)").matches
  }
  window.smallSOnly =  () => {
    return window.matchMedia("(max-width: 640px)").matches
  }
  
  window.fetchItemAsJSON = async (itemno)  => {
    const response = await fetch(`/data/${itemno}.json`, { method: 'GET' });
    return await response.json();;
  }

  window.getCaptchaToken = (route) => {
    // https://www.delftstack.com/howto/javascript/javascript-wait-for-function-to-finish/
    return new Promise((res, rej) => {

      try {
          grecaptcha.ready(() => {
              grecaptcha.execute('6LevHMkfAAAAAInPcjzzNLUUgvmKoeDzcIg4G6qS', { action: route }).then((token) => res(token));
          });

        } catch (e) {
          console.log(e);
          rej(e);
        }

    });
  }

  window.submitForm = async (route, data) => {
    const response = await fetch( route, {
      headers: {
        'X-Requested-With' : 'XMLHttpRequest'
      },
      method: 'POST',
      body: data
    });
    return await response.json();
  }

  window.submitCap = (frm, route) => {
        window.getCaptchaToken(route) 
          .then(token => { 
            console.log(token);
            let theForm = document.forms[frm];
            let input = document.createElement('input');
            input.type = 'hidden';
            input.name = 'g-recaptcha-response';
            input.value = token;
            theForm.appendChild(input);
            theForm.submit();
          })
          .catch(error =>  console.log(`Error recieved in getting captcha token/processing form ${error}`))
  }

  
  window.domReady = (cb) => {
    document.readyState === 'interactive' || document.readyState === 'complete'
      ? cb()
      : document.addEventListener('DOMContentLoaded', cb);
  };
  
// // When the user scrolls the page, execute myFunction
// window.onscroll = function() {
//   // Get the header
//   const header = document.getElementById("nav");
//   // Get the offset position of the navbar
//   const sticky = header.offsetTop;
//   if (window.pageYOffset > sticky) {
//     header.classList.add("sticky");
//   } else {
//     header.classList.remove("sticky");
//   }

// };

