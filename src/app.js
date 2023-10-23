// CSS 

import 'modern-normalize/modern-normalize';
import "./css/customReset.css";
import 'instantsearch.css/themes/algolia';
import 'intl-tel-input/build/css/intlTelInput';
import './css/site.css'; 
import './css/buttons.css'; 
import './css/header.css'; 
import './css/footer.css'; 
import './css/toasts.css'; 
import './css/modal.css'; 
import './css/form.css'; 
import './css/algolia.css'; 
import './css/carousel.css'; 
import './css/register.css'; 
import './css/login.css'; 
import './css/imagemodal.css'; 
import './css/tabs.css'; 
import './css/item.css'; 
import './css/offer.css'; 
import './css/megamenu.css';  
import './css/myprofile.css';  
import './css/media.css'; 
 
//JS libs

import { search } from './js/instantsearch'
import smoothscroll from 'smoothscroll-polyfill'

import Alpine from 'alpinejs';
import focus from '@alpinejs/focus'
// stores

import './js/stores/tabs';
import './js/stores/carousel';
import './js/stores/imodal';
import './js/stores/toasts';
//stores
import './js/stores/forms/forms';
import './js/stores/forms/pwd';
import './js/stores/forms/changepassword';
import './js/stores/forms/offer';
import './js/stores/forms/inquiry';
import './js/stores/forms/register';
import './js/stores/forms/myaddress';

import './js/stores/forms/storewatcher';
import './js/stores/forms/combineStores';

// smooth scroll
smoothscroll.polyfill()

// Instant Search
//if(document.getElementById('algolia'))
 search.start();

// Alpine
Alpine.plugin(focus)

// dom is loaded
domReady(() => {

  Alpine.start();

  setTimeout(() => {
    console.log('dom loaded')

    // PAGE LOADED- KICKOFF
    
    // server side item harvests data from HTML to and sets into some stores
    if (document.getElementById('item')) {
      Alpine.store('carousel').slides = Array(parseInt(document.getElementById('item').getAttribute('itemct')));
      Alpine.store('forms').qtyStated.value = document.getElementById('item').getAttribute('qty');
      Alpine.store('forms').maxqty = document.getElementById('item').getAttribute('qty');
      Alpine.store('forms').itemno = document.getElementById('item').getAttribute('itemno');
      Alpine.store('forms').priceStated.value = document.getElementById('item').getAttribute('price') == 'Best Price' ? '' : document.getElementById('item').getAttribute('price').replace('$', '');
    }

    //if on a page reload and we have a toast to show
    Alpine.store('toasts').makeToast();
    
 }, 200);
});

