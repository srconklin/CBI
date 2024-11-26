import Alpine from 'alpinejs';
//--------------------
// favorites    
//--------------------
Alpine.store('favorites', {

    favs : [],
    
    IsloggedIn : false,

    async init() {
        // console.log('favorites store initialized')
         await window.httprequest('getfavorites').then(data => this.favs = data.payload);
         await window.httprequest('IsLoggedIn').then(data => this.IsloggedIn = data.payload);
    },

    // async load() {
    //     // this.favs = await window.getUserFavs();
    //    await window.httprequest('getfavorites').then(data => this.favs = data.payload);
    // },

    get favorites() { return this.favs },

    isFavorite(itemno=0)  {
       return this.favs.includes(itemno);
    },
   
    toggle(itemno) {
     //toggle it from current setting 
      const isFavorite = !this.isFavorite(itemno);
      // add to favs
       if(isFavorite) 
            this.favs.push(itemno);    
        //remove from favs
        else {
            this.favs = this.favs.filter(function(item) {
                return item !== itemno
            })
        }

        //sync with backened
       let formData = new FormData();
       formData.append('itemno', itemno);
       formData.append('isFavorite', isFavorite);

        // get a capatcha token 
        window.getCaptchaToken('/togglefavorite')
        // append token to form object
        .then(token => formData.append('g-recaptcha-response', token))
        // post to backened
        .then(() => window.submitForm('/togglefavorite', formData).then(resObj => console.log(resObj)));
    
    }
   

});
