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

// Import of the Dropdown.js file
import { createDropdown } from './js/dropdown';
import searchRouting from './js/search-routing';

/************************ 
algolia instantsearch
**********************/
let rootpath;
const algoliaClient = algoliasearch(
  'S16PTK744D',
  'de0e3624732a96eacb0ed095dd52339c'
);

// a custom client search proxy to prevent
// https://www.algolia.com/doc/guides/building-search-ui/going-further/conditional-requests/js/
const searchClient = {
  ...algoliaClient,
  search(requests) {
    
   // console.log('requests', requests);
    // multiple request can come in at once. test every one
    requests.every(({ params }) => {
     
      // a search, refinement or url that goes straight to results
      // show the algolia element 
      if(requests.length > 1 || params.query) {
        
        document.getElementById('home').style.display = 'none'
        document.getElementById('algolia').classList.add('show');
      // prevent results (save $$$) and show landing page
      } else {

        document.getElementById('algolia').classList.remove('show');
        document.getElementById('home').style.display = 'block'

        return Promise.resolve({
            results: requests.map(() => ({
              hits: [],
              nbHits: 0,
              nbPages: 0,
              page: 0,
              processingTimeMS: 0,
            })),
          });
      }
    });
     return algoliaClient.search(requests);
  },
};



const search = instantsearch({
  indexName: 'cbi',
  searchClient,
  routing: searchRouting,

  // searchFunction(helper) {
  //  // console.log('helper', helper);
  //   const state= helper.state;
  //   // rootpath = state.hierarchicalFacetsRefinements['categories.lvl0'][0];
  //   //console.log(rootpath);
  //   // if (helper.state.query) {
  //   //   helper.search();
  //   // }
  //   helper.search();
  // }
  // onStateChange({ uiState, setUiState }) {
  //    // uiState.cbi.hasOwnProperty('hierarchicalMenu') ? document.getElementById('togglebc').style.visibility = 'visible' : document.getElementById('togglebc').style.visibility = 'hidden';
  //   console.log('uiState', uiState);
  //    setUiState(uiState);
  // }

});


function middleware({ instantSearchInstance }) {
  return {
    
    // subscribe() {
    //  //  console.log('subscribe', instantSearchInstance);
    //   const rootpath = instantSearchInstance.helper.state.hierarchicalFacetsRefinements.hasOwnProperty('categories.lvl0') ? instantSearchInstance.helper.state.hierarchicalFacetsRefinements['categories.lvl0'][0] : '';

    //  //instantSearchInstance.removeWidgets([HMWithPanel]);
    //   instantSearchInstance.addWidgets([

    //     HMWithPanel({
    //       container: '#categories',
    //       attributes: [
    //         'categories.lvl0',
    //         'categories.lvl1',
    //         'categories.lvl2'
    //       ],
    //       rootPath: rootpath,
    //       showParentLevel: false,
    //       limit:15,
    //               // sortBy: ['count:desc'],
    //     })

    //   ])
    // }
  }
}

// widgets
const refinementListWithPanel =  instantsearch.widgets.panel({
  collapsed: true,
   templates: {
   header: 'Manufacturer',
  },
})(instantsearch.widgets.refinementList);

const HMWithPanel =  instantsearch.widgets.panel({
  collapsed: true,
  //dispose(){},
  templates: {
    header: `Categories`,
  },
})(instantsearch.widgets.hierarchicalMenu);

// Creation of the refinementListDropdown widget
const categoriesDropdown = createDropdown(
  instantsearch.widgets.hierarchicalMenu,
  {
    closeOnChange: true,
    buttonText: 'Categories'
  }
)

const searchbox =  instantsearch.widgets.searchBox({
  container: '#searchbox',
  placeholder: 'keyword, category, make, model...',
  searchAsYouType: (document.getElementById('breadcrumb')) ? true : false,
  queryHook(query, search) {
    if(document.getElementById('breadcrumb')) 
      search(query);
     else 
      location.href = `/search/?query=${query}`
  
  },
  
  templates: {
    submit: `
      <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 18 18">
        <g fill="none" fill-rule="evenodd" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.67" transform="translate(1 1)">
          <circle cx="7.11" cy="7.11" r="7.11"/>
          <path d="M16 16l-3.87-3.87"/>
        </g>
      </svg>
          `,
  }
})

search.addWidgets([searchbox]);

// only add other widgets when the placeholders are present on the page
if(document.getElementById('breadcrumb')) {
    search.addWidgets([
      
      instantsearch.widgets.breadcrumb({
        container: '#breadcrumb',
        templates: {
          home: `All Categories`,
        },
        cssClasses: {
          noRefinementRoot: 'noCrumbs' 
        },  
        attributes: [
          'categories.lvl0',
          'categories.lvl1',
          'categories.lvl2',
        ],
      
      }),

      instantsearch.widgets.clearRefinements({
        container: '#clear-refinements',
        templates: {
          resetLabel: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
          <path fill-rule="evenodd" d="M4 2a1 1 0 011 1v2.101a7.002 7.002 0 0111.601 2.566 1 1 0 11-1.885.666A5.002 5.002 0 005.999 7H9a1 1 0 010 2H4a1 1 0 01-1-1V3a1 1 0 011-1zm.008 9.057a1 1 0 011.276.61A5.002 5.002 0 0014.001 13H11a1 1 0 110-2h5a1 1 0 011 1v5a1 1 0 11-2 0v-2.101a7.002 7.002 0 01-11.601-2.566 1 1 0 01.61-1.276z" clip-rule="evenodd" />
        </svg>clear filters`,
        },
        cssClasses: {
          
          button: [
            'btn-small',
            'btn-gray'
          ],
        }
      }),


      instantsearch.widgets.sortBy({
        container: '#sort-by',
        items: [
          { label: 'Most relevant', value: 'cbi' },
          { label: 'Recently added', value: 'recently_added' },
        ]
      }),

      refinementListWithPanel({
        container: '#mfr',
        attribute: 'mfr',
        showMore: true,
        showMoreLimit: 20,
        searchable: true,
        searchablePlaceholder: 'search a mfr...',
        sortBy: ['name:asc'],

      }),
      
      HMWithPanel({
        container: '#categories',
        attributes: [
          'categories.lvl0',
          'categories.lvl1',
          'categories.lvl2'
        ],
        showParentLevel: false,
        limit:15,
                // sortBy: ['count:desc'],
      }),

      categoriesDropdown({
        container: '#thecat',
        attributes: [
          'categories.lvl0',
          'categories.lvl1',
          'categories.lvl2'
        ]

      })

      instantsearch.widgets.stats({
        container: '#stats',
        templates: {
          text: `
            {{#hasNoResults}}No results{{/hasNoResults}}
            {{#hasOneResult}}1 result{{/hasOneResult}}
            {{#hasManyResults}}{{#helpers.formatNumber}}{{nbHits}}{{/helpers.formatNumber}} results{{/hasManyResults}}
          `
        }
      }),

      instantsearch.widgets.stats({
        container: '#statsfilter',
        templates: {
          text: `
            {{#hasNoResults}}No results{{/hasNoResults}}
            {{#hasOneResult}}View 1 result{{/hasOneResult}}
            {{#hasManyResults}}<button class="btn-small btn-gray"  @click.prevent="$dispatch('blur-bg', !showFilter);showFilter = !showFilter"> View {{#helpers.formatNumber}}{{nbHits}}{{/helpers.formatNumber}} results</button>{{/hasManyResults}}
          `
        }
      }),

      instantsearch.widgets.hits({
        container: '#hits',
        templates: {
          item (hit) { 
          const plural = hit.qty > 1 ? 's' : '';
          return `
            <article class="hit" itemscope itemtype="http://schema.org/Product">
              <header>
                <a href="#" @click.prevent="$dispatch('show-modal', { itemno: '${hit.itemno}' })" >
                  <svg xmlns="http://www.w3.org/2000/svg" class="hit-svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14" />
                  </svg>
                     
                  <div class="hit-image">
                        <img itemprop="image"src="${hit.imgbase}${hit.imgMain}" alt="{{headline}}" />
                  </div>
                </a> 
                <link itemprop="url" href="${hit.imgbase}${hit.imgMain}" />
              </header>

              <main>
                <div class="hit-detail">
                  <p itemprop="category" class="category">${instantsearch.highlight({ attribute: 'category', hit })}</p> 
                  <h1 itemprop="name"  class="headline">${instantsearch.highlight({ attribute: 'headline', hit })}</h1> 
                  <p itemprop="description" class="description">${instantsearch.highlight({ attribute: 'description', hit })}</p> 
                </div>
              </main>
            
              <footer>
                <p itemprop="manufacturer" class="hit-mfr">Make: <span>${instantsearch.highlight({ attribute: 'mfr', hit })}</span></p>
                <p itemprop="model" class="hit-model">Model: <span>${instantsearch.highlight({ attribute: 'model', hit })}</span></p>
                <p itemprop="offers" itemscope itemtype="http://schema.org/Offer">
                  <span class="hit-qty">${hit.qty} unit${plural} @</span> <span itemprop="price" content="${hit.price}" class="hit-price">${hit.price}</span>
                </p>
                <div class="hit-footer">
                  <p><span  class="location">${hit.location}</span></p>
                  <p>Item &bull; <a href="/items/${hit.itemno}"><span itemprop="productID" class="itemno">${hit.itemno}</span></a></p>
              </div>
              </footer>
            </article>

          `;
        }
       },
      }),
      instantsearch.widgets.pagination({
        container: '#pagination',
      }),


      instantsearch.widgets.configure({
        hitsPerPage: 16
      })

    ])
}

search.start();

// Use your middleware function
//search.use(middleware);

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
  var e = document.getElementById("slider");
  // return {
  //   direction: 'leftoright', 
  //   activeSlide: 0, 
  //   slides: [], 

  // }
  return {
    slides: [],
    active: 0,
    pageX: 0,
    pageEndX: 0,
    mousedown: function(e) {
        e.stopPropagation(),
        this.pageX = e.pageX
    },
    mouseup: function(t) {
        t.stopPropagation();
        var r = t.pageX - this.pageX;
        r < -3 ? e.scrollLeft = e.scrollLeft + e.scrollWidth / this.slides.length : r > 3 && (e.scrollLeft = e.scrollLeft - e.scrollWidth / this.slides.length)
    },
    mousemove: function(e) {
        e.preventDefault()
    }
}
})
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
             fetch(`/data/${itemno}.json`, {method: 'GET' })
              .then(response => response.json())
              .then(data => {
                this.content = data;
               // Spruce.store('carousel').slides = [ `${data.imgbase}${data.imgMain}`, ... data.imagesXtra.map( image => `${data.imgbase}${image}`)]
               // Spruce.store('tabs').content.specstable =  data.specstable;
                // setTimeout(() => {
                //     this.modal = true;
                // }, 200);
                // if(/Android/.test(navigator.appVersion)){
                //   // $('input[type="text"]').attr('autocomplete', "off");
                //   document.querySelector('input[type="text"]').setAttribute("autocomplete", "off");
                //  }
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
    qtyStated :  {blurred: false, errorMessage: '', value:1},
    priceStated: {blurred: false, errorMessage: '', value:''},
    firstName : {blurred: false, errorMessage: ''},
    lastName : {blurred: false, errorMessage: ''},
    email : {blurred: false, errorMessage: ''},
    phone1: {blurred: false, errorMessage: ''},
    terms: '',
    message: '',
    maxqty: 1,
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

        const data = new FormData(document.getElementById("offerfrm"))
        let error  
       // get the inputs that are to be validated (they have a blurred property)
       const inputs = Object.entries(this).filter((ele) => ele[1].hasOwnProperty('blurred'));
       // for those inputs, call any custom methods for validation otherwise call standard validateele
       inputs.forEach(ele => {
          this.toTarget(document.getElementById(ele[0]));
       }); 
       const errors = inputs.find((ele) => ele[1].errorMessage);
       if (!errors ) {
         this.submitting = true;
         let success =false;
            try {
              fetch('/offer', {
                  method: 'POST',
                  body: data 
                })
              .then(response => response.json())
              .then(data => {
                if (!data.res) {
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
      Spruce.store('carousel').direction ='leftoright';
      Spruce.store('carousel').activeSlide = 0;
      Spruce.store('offer').priceStated.value = '';
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
    
     Spruce.store('offer').maxqty =  content.qty;
     Spruce.store('offer').itemno =  content.itemno;
     content = {... content, specstable:undefined, imagesXtra:undefined, imgMain:undefined };
    
    }
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
    //      document.querySelector('.ais-Breadcrumb-item--selected') ? document.getElementById('togglebc').style.visibility = 'visible' : '';
        //  let toggles = document.querySelectorAll('.togglebc');
        //  toggles.forEach(function(item) {
        //   item.style.visibility = 'visible';
        // });
       // document.getElementById('home').style.display = 'block'
     }, 200);

});
