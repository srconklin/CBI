import Alpine from 'alpinejs';
//--------------------
// CAROUSEL
//--------------------
Alpine.store('carousel', {

    slides : [],
    skip : 1, // amounty of slides to skip in one click
    active : 0,

    reset() {
        this.slides = [];
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
        console.log(goto);
        slider.scrollTo({ left: goto, behavior: 'smooth' })
    }

});
