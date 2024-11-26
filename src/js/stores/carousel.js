import Alpine from 'alpinejs';
//--------------------
// CAROUSEL
//--------------------
Alpine.store('carousel', {

    slides : [],
    skip : 1,
    active : 0,

    reset() {
        this.slides = [];
        this.skip= 1;
        this.active= 0;
        document.getElementById('slider').scrollLeft = 0;
       
    },
    loadSlides(images) {
        this.slides = images;
    },
    next() {
        this.to((current, offset) => current + (offset * this.skip))
    },

    prev() {
        this.to((current, offset) => current - (offset * this.skip))
    },

    to(strategy) {
        let slider = document.getElementById('slider');

        let current = slider.scrollLeft
        let offset = slider.lastElementChild.getBoundingClientRect().width
        let goto = strategy(current, offset);
        slider.scrollTo({ left: goto, behavior: 'smooth' })
    }

});
