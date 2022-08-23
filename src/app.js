
import {alpine} from './js/alpine'
import focus from '@alpinejs/focus'
import { search } from './js/instantsearch'
import smoothscroll from 'smoothscroll-polyfill'

// smooth scroll
smoothscroll.polyfill()

// Instant Search
search.start();

// Alpine
alpine.plugin(focus)
alpine.start()

// dom is loaded
domReady(() => {
  setTimeout(() => {
    console.log('dom loaded')

    // PAGE LOADED- KICKOFF

    // server side item harvests data from HTML to and sets into some stores
    if (document.getElementById('item')) {
      alpine.store('carousel').slides = Array(parseInt(document.getElementById('item').getAttribute('itemct')));
      alpine.store('forms').qtyStated.value = document.getElementById('item').getAttribute('qty');
      alpine.store('forms').maxqty = document.getElementById('item').getAttribute('qty');
      alpine.store('forms').itemno = document.getElementById('item').getAttribute('itemno');
      alpine.store('forms').priceStated.value = document.getElementById('item').getAttribute('price') == 'Best Price' ? '' : document.getElementById('item').getAttribute('price').replace('$', '');
    }

    //if on a page reload and we have a toast to show
    alpine.store('toasts').makeToast();
    
 }, 200);
});

