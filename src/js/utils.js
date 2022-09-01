import intlTelInput from 'intl-tel-input';

// window functions
window.formatter = new Intl.NumberFormat('en-US', {
    style: 'currency',
    currency: 'USD'
  });
  // valid input includes alpha characters and full stop,comma,apostrophe,dash and space
  window.validInput = (s) => s.toString().replace(/[^\p{L} '.,-]/gui, '');
  // window.validInput = (s) => s.toString().replace(/[0-9~`!@#%&=_";:><\(\)\^\$\|\?\*\+\{\}\[\]\\\/]/gi, '');
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
    const data = await response.json();
    return data;
  }
  
  window.domReady = (cb) => {
    document.readyState === 'interactive' || document.readyState === 'complete'
      ? cb()
      : document.addEventListener('DOMContentLoaded', cb);
  };
  
