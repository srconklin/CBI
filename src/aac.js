import { Loader } from '@googlemaps/js-api-loader';

const loader = new Loader({
  apiKey: "AIzaSyDkEDHzr6YLw-24a07THqMOFF5t0UGgDqk",
  version: "weekly",
  language: "en"
});

let autocomplete;

const searchgeo = document.getElementById("searchgeo");
const geoError = document.getElementById("generalError");
const lp =  document.getElementById("location-panel");
const eles = {
    '1' : {
        'txt' : document.getElementById("locality"),
        'gid' : document.getElementById("PLocGID")
    },
    '2' :  {
        'txt' : document.getElementById("stateprov"), 
        'gid' : document.getElementById("PStPGID") 
    },
    '3' : {
        'txt' : document.getElementById("country"), 
        'gid' : document.getElementById("PCyGID") 
    }
}

const options =  {
    fields: ["address_components", "place_id", "geometry", 'formatted_address'],
    types: ['locality', 'sublocality_level_1', 'postal_town', 'administrative_area_level_3']
}

const init  = () => {
    searchgeo.value= '';
    geoError.style.display = 'none';
    lp.style.display = 'none';
    for (let key in eles) {
            eles[key]['txt'].innerHTML = '';
            eles[key]['gid'].value = '';
    }     
}

const onGeoFocused = () =>  init();

const onPlaceChanged = () => {
    init();
    // Get the place details from the autocomplete object.
    const place = autocomplete.getPlace();
    if (!place.hasOwnProperty('address_components'))
        return;

    let formData = new FormData();
        formData.append('placesResponse', JSON.stringify(place));

    fetch('/locationlookup', {
            headers: {
                'X-Requested-With' : 'XMLHttpRequest'
            },
            method: 'POST',
            body:  formData
        })
        .then(response => response.json())
        .then(resObj => {
            /*********************************
            *  server side error  
            *********************************/
            if (!resObj.res) {
                geoError.querySelector("p").innerHTML = resObj.errors;
                geoError.style.display = 'block';
            
            }
            /*********************************
            *  success no validation errors    
            *********************************/
            else {
                    for (const geolvl of resObj.geoChain) {
                        eles[geolvl.TYPE]['txt'].innerHTML = geolvl.LNM;
                        eles[geolvl.TYPE]['gid'].value = geolvl.GID;
                    }
                    lp.style.display = 'block';
            }
            
        });
            
}

const observer = new MutationObserver(function (mutationsList, observer) {
    for (const mutation of mutationsList) {
        if (mutation.attributeName == 'autocomplete' && mutation.target.getAttribute('autocomplete') == 'off') {
            observer.disconnect();
            mutation.target.setAttribute('autocomplete', 'none');

        }
    }
});

observer.observe(searchgeo, { attributes: true });

// Promise for a specific library
loader
.importLibrary('places')
.then(({Map}) => {
    console.log('places loaded')
    autocomplete = new google.maps.places.Autocomplete(searchgeo, options);
    autocomplete.addListener('place_changed', onPlaceChanged);
    searchgeo.addEventListener('focus', onGeoFocused);
    document.getElementById("address1").focus();

})
.catch((e) => {
   console.log(e)
});


   
   