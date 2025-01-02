import { initializeGlide } from './glider.js'; 
import DynamicCarousel from './DynamicCarousel.js';

// Function to initialize landing page elements
export function initializeLandingPageElements() {
    // Check if the home element exists
    if (document.getElementById('home')) {
  
      // Call initializeGlide with the appropriate selector and options
      initializeGlide('#cta-glider', {
        animationDuration: 1800,  
        swipeThreshold: 80,
        autoplay: 6000,
        //focusAt: '1',
        startAt: 0,
        perView: 1, 
        gap: 0,
        breakpoints: { 
            800: { 
              animationDuration: 400, 
              swipeThreshold: 30
            }
        }
      });
  
      // Instantiate featured carousel
      const carousel1 = new DynamicCarousel({
        containerSelector: '.featureds',  
        cardWidth: 340,
        gap: 25
      });
  
      // Instantiate new ones carousel
      const carousel2 = new DynamicCarousel({
        containerSelector: '.newones',  
        cardWidth: 340,
        gap: 25
      });
  
      // Instantiate recently viewed carousel
      const carousel3 = new DynamicCarousel({
        containerSelector: '.recentlyviewed',  
        cardWidth: 340,
        gap: 25
      });
  
      // Add beforeunload listener to ensure cleanup when navigating away
      window.addEventListener('beforeunload', () => {
        carousel1.destroy(); // Ensure cleanup when the page is unloaded
        carousel2.destroy(); // Ensure cleanup when the page is unloaded
        carousel3.destroy(); // Ensure cleanup when the page is unloaded
      });
  
      console.log('carousels created');
    }
  }
  