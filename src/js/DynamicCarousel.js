export default class DynamicCarousel {
  constructor({ containerSelector, cardWidth = 390, gap = 25 }) {
      this.cardWidth = cardWidth;
      this.gap = gap;

      this.container = document.querySelector(containerSelector);
      if (!this.container) {
          console.error(`Container with selector "${containerSelector}" not found.`);
          return;
      }

      this.inner = this.container.querySelector(`${containerSelector}-container`);
      if (!this.inner) {
          console.error(`Container with selector "${containerSelector}-container" not found.`);
          return;
      }

      this.bulletsContainer = this.container.querySelector('.carousel-bullets');
      if (!this.bulletsContainer) {
          console.error(`.carousel-bullets not found inside ${containerSelector}`);
          return;
      }

      this.currentPage = 0;
      this.isDragging = false;
      this.isMouseDown = false;
      this.startX = 0;
      this.startY = 0;
      this.scrollStart = 0;
      this.totalPages = 0;
      this.dragThreshold = 10; // Pixel threshold to distinguish drag from click
      this.dragDistance = 0; // Track total drag distance
      this.visibleCardsCache = null; // Cache for visible cards calculation

      // Bind methods to ensure correct 'this' context
      this.initialize = this.initialize.bind(this);
      this.handleInteractionStart = this.handleInteractionStart.bind(this);
      this.handleInteractionMove = this.handleInteractionMove.bind(this);
      this.handleInteractionEnd = this.handleInteractionEnd.bind(this);
      this.handleMouseLeave = this.handleMouseLeave.bind(this);
      this.handleClick = this.handleClick.bind(this);
      this.handleTouchEnd = this.handleTouchEnd.bind(this);
      this.handleResize = this.debounce(this.handleResize.bind(this), 100);

      // Use ResizeObserver for more efficient resize handling
      this.resizeObserver = new ResizeObserver(this.handleResize);

      // Bind events
      
      this.container.addEventListener('mousedown', this.handleInteractionStart);
      this.container.addEventListener('mousemove', this.handleInteractionMove);
      this.container.addEventListener('mouseup', this.handleInteractionEnd);
      this.container.addEventListener('mouseleave', this.handleMouseLeave);

      this.container.addEventListener('touchstart', this.handleInteractionStart, { passive: false });
      this.container.addEventListener('touchmove', this.handleInteractionMove, { passive: false });
      // this.container.addEventListener('touchend', this.handleInteractionEnd, { passive: false });
      this.container.addEventListener('touchend', this.handleTouchEnd, { passive: false });
      this.inner.addEventListener('click', this.handleClick);
      
      
      // Start observing container for resize
      this.resizeObserver.observe(this.container);

      // Initial setup
      this.initialize();
  }

  initialize() {
    if (!this.container.clientWidth) return; // Avoid initializing when container width is invalid

    const containerWidth = this.container.clientWidth;
    this.visibleCardsCache = Math.max(1, Math.floor(containerWidth / (this.cardWidth + this.gap))); // At least 1 card
    this.totalPages = Math.max(1, Math.ceil(this.inner.children.length / this.visibleCardsCache)); // At least 1 page

    this.updateBullets();
    this.goToPage(Math.min(this.currentPage, this.totalPages - 1)); // Prevent going out of bounds

    this.container.classList.add('is-visible'); // Optional class for visibility
}

updateBullets() {
  const requiredBullets = this.totalPages;
  const existingBullets = this.bulletsContainer.children.length;

  if (requiredBullets > existingBullets) {
      for (let i = existingBullets; i < requiredBullets; i++) {
          const bullet = document.createElement('div');
          bullet.classList.add('carousel-bullet');

          // Handle both click and touchstart
          const onBulletClick = (event) => {
              event.preventDefault();
              this.goToPage(i);
          };

          bullet.addEventListener('click', onBulletClick);
          bullet.addEventListener('touchstart', onBulletClick);

          this.bulletsContainer.appendChild(bullet);
      }
  } else if (requiredBullets < existingBullets) {
      for (let i = existingBullets - 1; i >= requiredBullets; i--) {
          const bullet = this.bulletsContainer.children[i];
          bullet.removeEventListener('click', () => this.goToPage(i)); // Cleanup
          bullet.removeEventListener('touchstart', () => this.goToPage(i)); // Cleanup
          this.bulletsContainer.removeChild(bullet);
      }
  }

  // Update active bullet
  Array.from(this.bulletsContainer.children).forEach((bullet, index) => {
      bullet.classList.toggle('active', index === this.currentPage);
  });
}


  debounce(func, wait) {
      let timeout;
      return function (...args) {
          clearTimeout(timeout);
          timeout = setTimeout(() => func.apply(this, args), wait);
      };
  }

  handleInteractionStart(e) {
    const isTouch = e.type.startsWith('touch');
    const eventData = isTouch ? e.touches[0] : e;

    // Only prevent default if the event is cancelable
    if (isTouch && e.cancelable) {
        e.preventDefault();  // This can sometimes interfere with touch-based clicks, so you may need to adjust.
    }

    this.dragDistance = 0;
    this.isDragging = false;
    this.isMouseDown = true;

    this.startX = eventData.pageX;
    this.startY = eventData.pageY;

    this.scrollStart = parseInt(this.inner.style.transform.replace('translate3d(', '').replace('px, 0, 0)', '') || 0);

    this.inner.style.transition = 'none';
    this.container.style.cursor = 'grabbing';
}


  handleInteractionMove(e) {
    if (!this.isMouseDown) return; // Ignore if not actively dragging

    const isTouch = e.type.startsWith('touch');
    const eventData = isTouch ? e.touches[0] : e;

    if (isTouch) e.preventDefault();

    const moveX = eventData.pageX - this.startX;

    this.dragDistance += Math.abs(moveX);

    // Start dragging only after threshold is exceeded
    if (!this.isDragging && Math.abs(moveX) > this.dragThreshold) {
        this.isDragging = true;
    }

    if (this.isDragging) {
        const scrollDistance = this.scrollStart + moveX;
        this.inner.style.transform = `translate3d(${scrollDistance}px, 0, 0)`;
    }
}


  handleInteractionEnd(e) {
    // Handle both mouse and touch events
    const isTouch = e.type.startsWith('touch');
    const pageX = isTouch && e.changedTouches ? e.changedTouches[0].pageX : (e.pageX || this.startX);

    // Reset dragging states
    this.isMouseDown = false;

    // Calculate drag distance and direction
    const dragDistance = this.startX - pageX;
    const containerWidth = this.container.clientWidth;
    const visibleCards = Math.max(
        1, // Ensure at least 1 visible card
        containerWidth / (this.cardWidth + this.gap)
    );

    const maxScrollDistance = (this.totalPages - 1) * visibleCards * (this.cardWidth + this.gap);
    const currentScroll = Math.abs(parseInt(this.inner.style.transform.replace('translate3d(', '').replace('px, 0, 0)', '')) || 0);

    const swipeThreshold = this.cardWidth / 4;
    let targetPageIndex = Math.round(currentScroll / (this.cardWidth + this.gap) / visibleCards);

    // Handle directional drag
    if (dragDistance > swipeThreshold) {
        // Swipe left
        targetPageIndex = Math.min(targetPageIndex + 1, this.totalPages - 1);
    } else if (dragDistance < -swipeThreshold) {
        // Swipe right
        targetPageIndex = Math.max(targetPageIndex - 1, 0);
    }

    // Prevent exceeding bounds
    targetPageIndex = Math.max(0, Math.min(targetPageIndex, this.totalPages - 1));

    // Smooth scroll to the target page
    this.inner.style.transition = '';
    this.goToPage(targetPageIndex);

    // Ensure no unintended movement
    this.isDragging = false;
    this.container.style.cursor = 'grab';
}

handleMouseLeave() {
  if (this.isMouseDown) {
      this.handleInteractionEnd(new Event('mouseleave'));
  }
}

handleClick(e) {
  // Check if the dragDistance threshold was exceeded to differentiate from a drag action
  if (this.dragDistance > this.dragThreshold) {
      e.preventDefault();
      e.stopPropagation();
      return;
  }

  // Handle clicks for both mouse and touch events
  const clickedCard = e.target.closest('.mini-item-card');
  if (clickedCard) {
      const itemno = Number(clickedCard.dataset.id);

      const event = new CustomEvent('show-item', {
          detail: { itemno: itemno },
          bubbles: true,
          composed: true,
          cancelable: true
      });

      clickedCard.dispatchEvent(event);
      console.log('Dispatched show-item event for item:', itemno);
  }

  this.dragDistance = 0;
}

handleTouchEnd(e) {
  // First, call the swipe handling method to ensure the carousel can swipe
  this.handleInteractionEnd(e);

  // Now handle the click logic if it's not a swipe action
  if (this.dragDistance <= this.dragThreshold) {
      this.handleClick(e);
  }
}


  goToPage(pageIndex) {
    if (pageIndex < 0) pageIndex = 0;
    if (pageIndex >= this.totalPages) pageIndex = this.totalPages - 1;

    this.currentPage = pageIndex;

    const visibleCards = this.visibleCardsCache || 1; // Fallback to prevent division by zero
    const scrollDistance = pageIndex * visibleCards * (this.cardWidth + this.gap);

    const distance = Math.abs(parseInt(this.inner.style.transform.replace('translate3d(', '').replace('px, 0, 0)', '') || 0) - scrollDistance);
    const transitionDuration = Math.min(1, distance / 500);
    // this.inner.style.transition = 'transform 0.3s ease-in-out';
    this.inner.style.transition = `transform ${transitionDuration}s cubic-bezier(0.165, 0.840, 0.440, 1.000)`;
    this.inner.style.transform = `translate3d(-${scrollDistance}px, 0, 0)`;

    

    this.updateBullets();
}

handleResize() {
  if (this.resizeObserver) {
      // Debounce to avoid rapid successive calls
      this.debounce(() => {
          this.initialize();
      }, 100)();
  }
}

destroy() {
  // Remove mouse and touch event listeners
  this.container.removeEventListener('mousedown', this.handleInteractionStart);
  this.container.removeEventListener('mousemove', this.handleInteractionMove);
  this.container.removeEventListener('mouseup', this.handleInteractionEnd);
  this.container.removeEventListener('mouseleave', this.handleInteractionEnd);

  this.container.removeEventListener('touchstart', this.handleInteractionStart);
  this.container.removeEventListener('touchmove', this.handleInteractionMove);
  this.container.removeEventListener('touchend', this.handleInteractionEnd);

  // Stop ResizeObserver
  if (this.resizeObserver) {
      this.resizeObserver.disconnect();
  }

  // Clear any other DOM modifications, like removing bullets
  if (this.bulletsContainer) {
      this.bulletsContainer.innerHTML = '';
  }

  // Clear any other resources like timers or variables that hold large data
  this.inner.style.transition = '';
  this.inner.style.transform = '';
}



}