// glider.js (ESM Module)
import '@glidejs/glide/dist/css/glide.core.min.css'; // Import the Glide core CSS
import Glide, { Autoplay, Controls, Swipe, Breakpoints} from '@glidejs/glide/dist/glide.modular.esm.js'; // Import only the required modules

/**
 * Initializes and mounts the Glide carousel.
 * @param {string} selector - The CSS selector for the carousel container.
 * @param {Object} options - Configuration options for the Glide instance.
 */
export function initializeGlide(selector, options = {}) {
  // Use requestAnimationFrame to ensure DOM is ready before mounting
  //requestAnimationFrame(() => {

  // Check if the element is visible before initializing Glide
  // if (window.isElementVisible('#home')) {
    // Initialize Glide with the given selector and options
    const glider = new Glide(selector, {
      type: 'carousel',
      ...options, // Spread the user-provided options here
     
    });
    
      glider.mount({Autoplay, Controls, Swipe, Breakpoints}); // Mount the Glide instance
      document.querySelector('.glide').classList.add('is-visible'); // Optional class for visibility

      // move handler to make sure button is active before the animation completes
      glider.on('move', () => {
        const activeBullet = document.querySelector('.glide__bullet--active');
        if (activeBullet) {
          activeBullet.classList.remove('glide__bullet--active');
        }
        const currentBullet = document.querySelectorAll('.glide__bullet')[glider.index];
        currentBullet.classList.add('glide__bullet--active');
      });

      glider.play(); // Start the autoplay
     // console.log(`Glider for ${selector} started`);

    //  }
   // });
}

