import Alpine from 'alpinejs';
//--------------------
// itempreview
//--------------------
Alpine.store('itempreview', {

    content: false,

    close(e) {
        Alpine.store('item').close();

        const reset = {
            blurred: false,
            errorMessage: ''
        }

        Alpine.store('carousel').reset();

        Alpine.store('offer').priceStated = { ...Alpine.store('offer').priceStated, ...reset, ...{ value: '' } };
        Alpine.store('offer').qtyStated = { ...Alpine.store('offer').qtyStated, ...reset };

},
   
    showItem(itemno) {

        Alpine.store('item').showItem(itemno).then(content =>{
            // success; then load dependencies
            if (content) {
             this.loadComponents(content);
            }
        }) .catch(error => {
            console.log('fetching item failed', error);
         });
       
    },

    loadComponents(content) {


        Alpine.store('carousel').loadSlides([`${content.imgbase}${content.imgMain}`, ...content.imagesXtra.map(image => `${content.imgbase}${image}`)]);
            
        Alpine.store('tabs').content.specstable = content.specstable;
        Alpine.store('tabs').content.payterms = content.payterms;
        Alpine.store('tabs').content.shipterms = content.shipterms;
        Alpine.store('tabs').openTab = 1;
        

        Alpine.store('offer').qtyStated.value = content.qty;
        Alpine.store('offer').priceStated.value = content.price == 'Best Price' ? '' : content.price.replace('$', '');
        Alpine.store('offer').qtyShown.value = content.qty;
        Alpine.store('offer').priceShown.value = content.price == 'Best Price' ? '' : content.price.replace(/[\$,]/g, '');
        Alpine.store('offer').maxqty = content.qty;
        Alpine.store('offer').itemno.value = content.itemno;
       // Alpine.store('offer').refnr.value = 0;

       Alpine.store('inquiry').itemno.value = content.itemno;
       
    }
    
});