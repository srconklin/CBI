import Alpine from 'alpinejs';
//--------------------
// IMODAL
//--------------------
Alpine.store('imodal', {

    modal: undefined,
    content: false,
    hasLoaded: false,

    closeModal(e) {
        this.modal = false;
        this.hasLoaded = false;
    },

    showItem(itemno) {

        try {
                fetchItemAsJSON(itemno).then(data => {
                this.content = data;
                //this.content.itemses = data.pagetitle.toLowerCase().replace(/\s/g, '+');
                this.content.URI =  window.buildItemURI(this.content.itemno, data.pagetitle) 
                this.modal = true;
                //document.getElementById('priceStated').focus();
            });
        } catch (error) {
            
            console.log(error);
        }
    }
    
});