import Alpine from 'alpinejs';
//--------------------
// item
//--------------------
Alpine.store('item', {

    content: false,

    close(e) {
      this.content=false;
    },
   
    showItem(itemno) {

        // return fetchItemAsJSON(itemno).then(data => {
        //     this.content = data;
        //     this.content.URI =  window.buildItemURI(this.content.itemno, data.pagetitle);
        //     return this.content;
        // })
        //  .catch(error => {
        //     console.log(error);
        //     throw error; 
        //  });

       return httprequest(`data/${itemno}.json`).then(data =>  {
            this.content = data;
            this.content.URI =  window.buildItemURI(this.content.itemno, data.pagetitle);
            return this.content;
        })
       
    }
    
});