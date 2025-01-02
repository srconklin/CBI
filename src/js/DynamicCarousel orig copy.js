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

      this.initialize = this.initialize.bind(this);
      this.handleResize = this.handleResize.bind(this);
      this.handleMouseDown = this.handleMouseDown.bind(this);
      this.handleClick = this.handleClick.bind(this);
      this.handleMouseMove = this.handleMouseMove.bind(this);
      this.handleMouseUp = this.handleMouseUp.bind(this);
      this.handleTouchStart = this.handleTouchStart.bind(this);
      this.handleTouchMove = this.handleTouchMove.bind(this);
      this.handleTouchEnd = this.handleTouchEnd.bind(this);
       
      let resizeTimer;
      window.addEventListener('resize', () => {
          clearTimeout(resizeTimer);
          resizeTimer = setTimeout(this.handleResize, 250);
      });

      this.initialize();
  }

  initialize() {
      this.bulletsContainer.innerHTML = '';

      const containerWidth = this.container.clientWidth;
      const visibleCards = Math.floor(containerWidth / (this.cardWidth + this.gap));
      this.totalPages = Math.ceil(this.inner.children.length / visibleCards);

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
      
      this.container.addEventListener('mousedown', this.handleMouseDown);
      this.container.addEventListener('mousemove', this.handleMouseMove);
      this.container.addEventListener('mouseup', this.handleMouseUp);
      this.container.addEventListener('mouseleave', this.handleMouseUp);
      this.container.addEventListener('touchstart', this.handleTouchStart);
      this.container.addEventListener('touchmove', this.handleTouchMove);
      this.container.addEventListener('touchend', this.handleTouchEnd);

      
      // Prevent image dragging
      const images = this.inner.querySelectorAll('img');
      images.forEach(img => {
          img.addEventListener('dragstart', (e) =>
          {
            e.preventDefault();
            return false;
          });
      });
      

      this.container.style.userSelect = 'none';
      this.container.style.cursor = 'grab';

      this.container.classList.add('is-visible'); // Optional class for visibility
  }

 handleMouseDown(e) {
      // Reset drag-related states
      this.dragDistance = 0;
      this.isDragging = false;

      // For mouse events
      if (e.type === 'mousedown') {
          this.isMouseDown = true;
          this.startX = e.pageX;
          this.startY = e.pageY;
      } 
      // For touch events
      else if (e.type === 'touchstart') {
          this.isMouseDown = true;
          this.startX = e.touches[0].pageX;
          this.startY = e.touches[0].pageY;
      }
      
      this.scrollStart = parseInt(this.inner.style.transform.replace('translate3d(', '').replace('px, 0, 0)', '') || 0);
      
      this.inner.style.transition = 'none'; // Disable transition during potential drag
      this.container.style.cursor = 'grabbing';
  }

  handleMouseMove(e) {
    if (!this.isMouseDown) return;

    let moveX, moveY;
    
    // For mouse events
    if (e.type === 'mousemove') {
        moveX = e.pageX - this.startX;
        moveY = e.pageY - this.startY;
    } 
    // For touch events
    else if (e.type === 'touchmove') {
        moveX = e.touches[0].pageX - this.startX;
        moveY = e.touches[0].pageY - this.startY;
    }

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

handleMouseUp(e) {
  // Capture the final page position based on event type
  const pageX = e.type === 'mouseup' ? e.pageX : 
                e.type === 'touchend' && e.changedTouches ? e.changedTouches[0].pageX : 
                this.startX;

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

      this.inner.style.transition = ''; // Re-enable transition
      this.goToPage(targetPageIndex);
      
      // Explicitly mark as drag to prevent click
      this.isDragging = true;
  } else {
      // If drag distance is small, reset dragging state
      this.isDragging = false;
  }

  this.container.style.cursor = 'grab';
}

  handleTouchStart(e) {
      // Prevent default touch behavior to stop scrolling while dragging
      e.preventDefault();
      this.handleMouseDown(e);
  }

  handleTouchMove(e) {
      // Prevent default touch behavior to stop scrolling while dragging
      e.preventDefault();
      this.handleMouseMove(e);
  }

  handleTouchEnd(e) {
      // Prevent default touch behavior
      e.preventDefault();
      this.handleMouseUp(e);
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
            bubbles: true,  // Allow the event to bubble up the DOM tree
            composed: true,
            cancelable: true // Allow the event to be cancelable
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
}