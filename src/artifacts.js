
domReady(() => {

    setTimeout(() => {
      //  document.querySelector('.ais-Breadcrumb-item--selected') ? document.getElementById('togglebc').style.visibility = 'visible' : '';
      //  let toggles = document.querySelectorAll('.togglebc');
      //  toggles.forEach(function(item) {
      //   item.style.visibility = 'visible';
      // });
      // document.getElementById('home').style.display = 'block'
      
      //  if (document.getElementById('item')) {
      //   const itemno = document.getElementById('item').getAttribute('itemno');
      //     try {
      //       fetchItemAsJSON(itemno).then(data => {
      //         Spruce.store('carousel').slides = [ `${data.imgbase}${data.imgMain}`, ... data.imagesXtra.map( image => `${data.imgbase}${image}`)]
      //       });
      //     } catch (error) {
      //       console.log(error);
      //     }
      //  }

      loadImageCount();


     }, 200);

});



Spruce.store('carousel', () => {
    var e = document.getElementById("slider");
   
    return {
      slides: [],
      active: 0,
      pageX: 0,
      scrolling: false,
      scroll: function(e) {
        this.active = Math.round(e.target.scrollLeft / (e.target.scrollWidth / this.slides.length))
        // window.clearTimeout( this.scrolling );
        // this.scrolling = setTimeout(() => {
        //     window.imageZoom('img_'+this.active, 'img_container'+this.active, 'img-result'); 
        // },100);
  
        },
      mousedown: function(e) {
          e.stopPropagation(),
          this.pageX = e.pageX
      },
    
      mouseup: function(t) {
          t.stopPropagation();
          var r = t.pageX - this.pageX;
          r < -3 ? e.scrollLeft = e.scrollLeft + e.scrollWidth / this.slides.length : r > 3 && (e.scrollLeft = e.scrollLeft - e.scrollWidth / this.slides.length)
      },
      mousemove: function(e) {
          e.preventDefault()
      }
  }
  })



window.imageZoom = (imgID, neighbor, resultID) => {
    let img, lens, result;
    const cx = 3;
    const cy = 3;
  
    img = document.getElementById(imgID);
    const carousel = document.getElementById(neighbor);
    carousel.removeEventListener("mouseenter", neighborEnter);
    carousel.removeEventListener("mouseleave", neighborLeave);
    img.removeEventListener("mousemove", moveLens);
  
    if (! window.matchMedia( "(min-width: 1150px)" ).matches) 
      return;
  
    result = document.getElementById(resultID);
    const targetRect = carousel.getBoundingClientRect();
  
    // place viewer next to carousel
    result.style.left = `${targetRect.right+50}px`;
    result.style.top = `${targetRect.top}px`;
    /* Set background properties for the result DIV */
    result.style.backgroundImage = "url('" + img.src + "')";
    result.style.backgroundSize = (img.width * cx) + "px " + (img.height * cy) + "px";
  
    img.addEventListener("mousemove", moveLens);
    carousel.addEventListener("mouseenter", neighborEnter);
    carousel.addEventListener("mouseleave", neighborLeave);
    window.addEventListener('resize',  checkSize);
  
    /* And also for touch screens: */
    // lens.addEventListener("touchmove", moveLens);
    // img.addEventListener("touchmove", moveLens);
    function checkSize(e) {
      
      if (! window.matchMedia( "(min-width: 1150px)" ).matches)  {
        carousel.removeEventListener("mouseenter", neighborEnter);
        carousel.removeEventListener("mouseleave", neighborLeave);
        img.removeEventListener("mousemove", moveLens);
         
      } else {
        carousel.addEventListener("mouseenter", neighborEnter);
        carousel.addEventListener("mouseleave", neighborLeave);
        img.addEventListener("mousemove", moveLens);
        
      }
    }
    function neighborEnter(e) {
      result.style.display = 'block'
    }
    function neighborLeave(e) {
      result.style.display = 'none'
    }
    function moveLens(e) {
      var pos, x, y;
      /* Prevent any other actions that may occur when moving over the image */
      e.preventDefault();
      /* Get the cursor's x and y positions: */
      pos = getCursorPos(e);
      /* Calculate the position of the lens: */
      const tolerance = 80;
      x = pos.x - (tolerance / 2);
      y = pos.y - (tolerance / 2);
      /* Prevent the lens from being positioned outside the image: */
      if (x > img.width - tolerance)
         {x = img.width - tolerance;}
      if (x < 0) 
        {x = 0;}
      if (y > img.height - tolerance)
         {y = img.height - tolerance;}
      if (y < 0) 
        {y = 0;}
      /* Set the position of the lens: */
     // lens.style.left = x + "px";
     // lens.style.top = y + "px";
      /* Display what the lens "sees": */
      result.style.backgroundPosition = "-" + (x * cx) + "px -" + (y * cy) + "px";
    }
    function getCursorPos(e) {
      var a, x = 0, y = 0;
      e = e || window.event;
      /* Get the x and y positions of the image: */
      a = img.getBoundingClientRect();
      /* Calculate the cursor's x and y coordinates, relative to the image: */
      x = e.pageX - a.left;
      y = e.pageY - a.top;
      /* Consider any page scrolling: */
      x = x - window.pageXOffset;
      y = y - window.pageYOffset;
      return {x : x, y : y};
    }
  }
  