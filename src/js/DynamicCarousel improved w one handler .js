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
      this.handleClick = this.handleClick.bind(this);
      this.handleResize = this.handleResize.bind(this);

      // Use ResizeObserver for more efficient resize handling
      this.resizeObserver = new ResizeObserver(this.handleResize);
      
      // Bind events
      this.container.addEventListener('mousedown', this.handleInteractionStart);
      this.container.addEventListener('mousemove', this.handleInteractionMove);
      this.container.addEventListener('mouseup', this.handleInteractionEnd);
      this.container.addEventListener('mouseleave', this.handleInteractionEnd);
      
      this.container.addEventListener('touchstart', this.handleInteractionStart, { passive: false });
      this.container.addEventListener('touchmove', this.handleInteractionMove, { passive: false });
      this.container.addEventListener('touchend', this.handleInteractionEnd, { passive: false });

      // Start observing container for resize
      this.resizeObserver.observe(this.container);

      // Initial setup
      this.initialize();
  }

  initialize() {
      this.bulletsContainer.innerHTML = '';

      // Memoize visible cards calculation
      const containerWidth = this.container.clientWidth;
      this.visibleCardsCache = Math.floor(containerWidth / (this.cardWidth + this.gap));
      this.totalPages = Math.ceil(this.inner.children.length / this.visibleCardsCache);

      // Create bullets
      for (let i = 0; i < this.totalPages; i++) {
          const bullet = document.createElement('div');
          bullet.classList.add('carousel-bullet');
          bullet.addEventListener('click', () => this.goToPage(i));
          this.bulletsContainer.appendChild(bullet);
      }

      this.bulletsContainer.children[0]?.classList.add('active');

      this.goToPage(0);

      // Delegate click to children to handle individual card clicks
      this.inner.addEventListener('click', this.handleClick);

      // Prevent image dragging with CSS approach
      const styleElement = document.createElement('style');
      styleElement.textContent = `
          .carousel img {
              user-drag: none;
              -webkit-user-drag: none;
              user-select: none;
              -moz-user-select: none;
              -webkit-user-select: none;
              -ms-user-select: none;
          }
      `;
      document.head.appendChild(styleElement);

      this.container.style.userSelect = 'none';
      this.container.style.cursor = 'grab';

      this.container.classList.add('is-visible');
  }

  handleInteractionStart(e) {
      // Determine if it's a mouse or touch event
      const isTouch = e.type.startsWith('touch');
      const eventData = isTouch ? e.touches[0] : e;

      // Prevent default for touch events
      if (isTouch) {
          e.preventDefault();
      }

      // Reset drag-related states
      this.dragDistance = 0;
      this.isDragging = false;
      this.isMouseDown = true;
      
      this.startX = isTouch ? eventData.pageX : eventData.pageX;
      this.startY = isTouch ? eventData.pageY : eventData.pageY;
      
      this.scrollStart = parseInt(this.inner.style.transform.replace('translate3d(', '').replace('px, 0, 0)', '') || 0);
      
      this.inner.style.transition = 'none';
      this.container.style.cursor = 'grabbing';
  }

  handleInteractionMove(e) {
      if (!this.isMouseDown) return;

      const isTouch = e.type.startsWith('touch');
      const eventData = isTouch ? e.touches[0] : e;

      // Prevent default for touch events
      if (isTouch) {
          e.preventDefault();
      }

      const moveX = eventData.pageX - this.startX;
      const moveY = eventData.pageY - this.startY;

      // Accumulate total drag distance
      this.dragDistance += Math.abs(moveX);

      // Check if movement exceeds drag threshold
      if (Math.abs(moveX) > this.dragThreshold || Math.abs(moveY) > this.dragThreshold) {
          this.isDragging = true;
      }

      if (this.isDragging) {
          const scrollDistance = this.scrollStart + moveX;
          this.inner.style.transform = `translate3d(${scrollDistance}px, 0, 0)`;
      }
  }

  handleInteractionEnd(e) {
      // Determine the final page X coordinate
      const isTouch = e.type.startsWith('touch');
      const pageX = isTouch && e.changedTouches 
          ? e.changedTouches[0].pageX 
          : e.pageX;

      this.isMouseDown = false;

      // Calculate total drag distance
      const dragDistance = Math.abs(this.startX - pageX);

      if (dragDistance > this.dragThreshold) {
          const containerWidth = this.container.clientWidth;
          const visibleCards = Math.floor(containerWidth / (this.cardWidth + this.gap));
          const currentPosition = -parseInt(this.inner.style.transform.replace('translate3d(', '').replace('px, 0, 0)', ''));
          const swipeThreshold = this.cardWidth / 4;

          let targetPageIndex = Math.round(currentPosition / (this.cardWidth + this.gap) / visibleCards);
          const directionalDragDistance = this.startX - pageX;

          if (directionalDragDistance > swipeThreshold) {
              targetPageIndex = Math.min(targetPageIndex + 1, this.totalPages - 1);
          } else if (directionalDragDistance < -swipeThreshold) {
              targetPageIndex = Math.max(targetPageIndex - 1, 0);
          }

          this.inner.style.transition = '';
          this.goToPage(targetPageIndex);
          
          this.isDragging = true;
      } else {
          this.isDragging = false;
      }

      this.container.style.cursor = 'grab';
  }

  handleClick(e) {
      // Prevent click if drag distance exceeded threshold
      if (this.dragDistance > this.dragThreshold) {
          e.preventDefault();
          e.stopPropagation();
          return;
      }

      // Find the clicked card
      const clickedCard = e.target.closest('.mini-item-card');
      if (clickedCard) {
          // Extract the item number from the data-id attribute
          const itemno = Number(clickedCard.dataset.id);

          // Create and dispatch a custom event similar to AlpineJS $dispatch
          const event = new CustomEvent('show-item', {
              detail: { itemno: itemno },
              bubbles: true,
              composed: true,
              cancelable: true
          });
          
          // Dispatch the event from the clicked card
          clickedCard.dispatchEvent(event);

          // Optional: log the dispatch (you can remove this in production)
          console.log('Dispatched show-item event for item:', itemno);
      }

      // Reset drag distance after click handling
      this.dragDistance = 0;
  }

  goToPage(pageIndex) {
      if (pageIndex < 0) pageIndex = 0;
      if (pageIndex >= this.totalPages) pageIndex = this.totalPages - 1;

      this.currentPage = pageIndex;

      const containerWidth = this.container.clientWidth;
      const visibleCards = Math.floor(containerWidth / (this.cardWidth + this.gap));
      const scrollDistance = pageIndex * visibleCards * (this.cardWidth + this.gap);

      const distance = Math.abs(parseInt(this.inner.style.transform.replace('translate3d(', '').replace('px, 0, 0)', '') || 0) - scrollDistance);
      const transitionDuration = Math.min(1, distance / 500);
      this.inner.style.transition = `transform ${transitionDuration}s cubic-bezier(0.165, 0.840, 0.440, 1.000)`;
      this.inner.style.transform = `translate3d(-${scrollDistance}px, 0, 0)`;

      Array.from(this.bulletsContainer.children).forEach((bullet, index) => {
          bullet.classList.toggle('active', index === pageIndex);
      });
  }

  handleResize() {
      this.initialize();
  }

  // Cleanup method to remove all event listeners and observers
  destroy() {
      // Remove event listeners
      this.container.removeEventListener('mousedown', this.handleInteractionStart);
      this.container.removeEventListener('mousemove', this.handleInteractionMove);
      this.container.removeEventListener('mouseup', this.handleInteractionEnd);
      this.container.removeEventListener('mouseleave', this.handleInteractionEnd);
      
      this.container.removeEventListener('touchstart', this.handleInteractionStart);
      this.container.removeEventListener('touchmove', this.handleInteractionMove);
      this.container.removeEventListener('touchend', this.handleInteractionEnd);

      // Stop resize observation
      this.resizeObserver.unobserve(this.container);

      // Remove click event listener
      this.inner.removeEventListener('click', this.handleClick);
  }
}