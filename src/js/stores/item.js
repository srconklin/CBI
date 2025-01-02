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
       
       return httprequest(`data/${itemno}.json`).then(data =>  {
            this.content = data;
            this.content.URI =  window.buildItemURI(this.content.itemno, data.pagetitle);
            return this.content;
        })
       
    }
    
});