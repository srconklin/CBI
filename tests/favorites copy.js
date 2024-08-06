import Alpine from 'alpinejs';
//--------------------
// favorites    
//--------------------
Alpine.store('favorites', {
    
    isFavorite : false,
    itemno : '',

    toggle() {
        this.isFavorite = !this.isFavorite;
        const data = {
            itemno : this.itemno,
            pno : this.pno,
            isFavorite : this.isFavorite
        }
      
       let formData = new FormData();
       formData.append('itemno', this.itemno);
       formData.append('pno', this.pno);
       formData.append('isFavorite', this.isFavorite);

        // get a capatcha token 
        window.getCaptchaToken('/togglefavorite')
        // append token to form object
        .then(token => formData.append('g-recaptcha-response', token))
        // post to backened
        .then(() => window.submitForm('/togglefavorite', formData).then(resObj => console.log(resObj)));
    
    },
   async load(itemno, pno) {
        //  this.isFavorite = loadFavoriteSetting(itemno, this.isFavorite).then(result => result);
        //   const response = await fetch("/loadfavorite?" + new URLSearchParams({itemno:itemno, pno:pno}));
        //   const data = await response.json();
        //   this.isFavorite = await data.payload;
        this.itemno =Number(itemno);
        this.pno =Number(pno);
        const favs = await window.getUserFavs();
        this.isFavorite = await favs.includes(this.itemno);
    	

    }
  

});
