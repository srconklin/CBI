import Alpine from 'alpinejs';

// WATCHERS
Alpine.effect(() => {
    const modal = Alpine.store('imodal').modal;
    const content = Alpine.store('imodal').content;
    const hasLoaded = Alpine.store('imodal').hasLoaded;
    
    // when the modal closes, then reset the caroursel and forms back to some defaults       
    if (modal === false) {

       console.log('modal closed');
        const reset = {
            blurred: false,
            errorMessage: ''
        }

        Alpine.store('carousel').slides = [];
        Alpine.store('carousel').scrolling = false;
        Alpine.store('carousel').active = 0;
        Alpine.store('offer').priceStated = { ...Alpine.store('offer').priceStated, ...reset, ...{ value: '' } };
        Alpine.store('offer').qtyStated = { ...Alpine.store('offer').qtyStated, ...reset };
        Alpine.store('imodal').content = false;

    } else if (modal && !hasLoaded) {

        Alpine.store('imodal').hasLoaded =true;

        // if the modal has received some new content from a new item fetch
        // reset the commponents with data fetched from the item 
        if (content) {
            Alpine.store('carousel').slides = [`${content.imgbase}${content.imgMain}`, ...content.imagesXtra.map(image => `${content.imgbase}${image}`)]
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
            Alpine.store('inquiry').itemno.value = content.itemno;
            //Alpine.store('imodal').content = { ...content, specstable: undefined, imagesXtra: undefined, imgMain: undefined };

            // reset the slider to the first scroll position
            setTimeout(() => {
                document.getElementById('slider').scrollLeft = 0;
                //document.getElementById('priceStated').focus();
            }, 100);
          
        }
    }

})