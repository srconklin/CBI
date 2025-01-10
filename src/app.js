// CSS 

import 'modern-normalize/modern-normalize';
import "./css/customReset.css";
///import 'instantsearch.css/themes/algolia';
import 'intl-tel-input/build/css/intlTelInput';
import 'tippy.js/dist/tippy.css'; 
import './css/root.css'; 
import './css/site.css'; 
import './css/buttons.css'; 
import './css/header.css'; 
import './css/footer.css'; 
import './css/toasts.css'; 
import './css/modal.css'; 
import './css/form.css'; 
import './css/myalgolia.css'; 
import './css/carousel.css'; 
import './css/landing.css';
import './css/pwd.css'; 
import './css/imagemodal.css'; 
import './css/tabs.css'; 
import './css/item.css'; 
import './css/offer.css'; 
import './css/megamenu.css';  
import './css/myprofile.css';  
import './css/cookiebanner.css';  
import './css/progresstracker.css';  
import './css/tables.css';  
import './css/media.css'; 

//JS libs
import './js/utils';
import { initializeLandingPageElements } from './js/initializeLandingPageElements';
import { asyncSearch } from './js/instantsearch'
import smoothscroll from 'smoothscroll-polyfill'
import { createPopper } from '@popperjs/core';
import tippy from 'tippy.js';


import Alpine from 'alpinejs';
import focus from '@alpinejs/focus'
import collapse from '@alpinejs/collapse'
 
// stores
import './js/stores/tabs';
import './js/stores/carousel';
import './js/stores/item';
import './js/stores/itempreview';
import './js/stores/toasts';
import './js/stores/favorites';

//forms
import './js/stores/forms/forms';
import './js/stores/forms/pwd';
import './js/stores/forms/changepassword';
import './js/stores/forms/offer';
import './js/stores/forms/reply';
import './js/stores/forms/contact';
import './js/stores/forms/inquiry';
import './js/stores/forms/register';
import './js/stores/forms/updateaddress';

import './js/stores/forms/combineStores';

//data components 
// import favorites from './js/favorites';
// Alpine.data('favorites', favorites)

// smooth scroll
smoothscroll.polyfill()

// Alpine plugins
Alpine.plugin(focus)
Alpine.plugin(collapse)

// Magic Functions 

// Magic: $clipboard
Alpine.magic('clipboard', () => subject => {
  navigator.clipboard.writeText(subject)
})
// Magic: $tooltip
Alpine.magic('tooltip', el => message => {
  let instance = tippy(el, { content: message, trigger: 'manual' })
  instance.show()
  setTimeout(() => {
      instance.hide()
      setTimeout(() => instance.destroy(), 150)
  }, 2000)
});

    
// dom is loaded
domReady(() => {
  console.log('dom loaded');
  
  Alpine.start();
  console.log('alpine started');
 
  
  (async () => {
    const search = await asyncSearch;
    search.start();
    console.log('search started');

  })();

   
   // wait until dom is completley loaded
    window.addEventListener('load', () => {

      // LANDING PAGE Carousels (when home id is avaiable )
      initializeLandingPageElements();

      // server side item harvests data from HTML to and sets into the stores
      if (document.getElementById('item')) {
        Alpine.store('carousel').slides = Array(parseInt(document.getElementById('item').getAttribute('itemct')));
        Alpine.store('offer').maxqty = document.getElementById('item').getAttribute('qty');
        Alpine.store('offer').itemno = document.getElementById('item').getAttribute('itemno');
        Alpine.store('offer').priceStated.value = document.getElementById('item').getAttribute('price') == 'Best Price' ? '' : document.getElementById('item').getAttribute('price').replace('$', '');
        Alpine.store('offer').qtyStated.value = document.getElementById('item').getAttribute('qty');
      }
      
      console.log('dom loaded')  

    });
    

    //if on a page reload and we have a toast to show
    Alpine.store('toasts').makeToast();
    
});

