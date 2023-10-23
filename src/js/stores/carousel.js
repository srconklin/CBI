import Alpine from 'alpinejs';
//--------------------
// CAROUSEL
//--------------------
Alpine.store('carousel', {
    slides: [],
    skip: 1,

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
        //this.active = Math.min(Math.max(Math.round(goto / offset)+1, 1), this.slides.length);
    }

});
