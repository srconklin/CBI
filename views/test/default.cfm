
<!DOCTYPE html>
<html lang="en" >

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no maximum-scale=1, user-scalable=0">
  <link rel="shortcut icon" href="/images/favicon.ico">
  <title>CBI</title>
  <script src="https://cdn.tailwindcss.com"></script>

  <script src="https://cdn.jsdelivr.net/npm/alpinejs@3.7.0/dist/cdn.min.js" defer></script>
  <script>

  </script>
  <style>


    
/***********
 scrollbar
 ***********/

* {
  scrollbar-width: thin;
  scrollbar-color: #f1f1f1 orange;
}

/* Let's get this party started */
::-webkit-scrollbar {
  width: 10px;
  height: 10px;
}

/* Track */
*::-webkit-scrollbar-track {
  background: #f1f1f1;
  /* border: 4px solid transparent; */
  background-clip: content-box;
  /* THIS IS IMPORTANT */
}

/* Handle */
*::-webkit-scrollbar-thumb {
  background: rgb(204 207 218 / 90%);
  border: 1px solid #f1f1f1;
  border-radius: 15px;
  opacity: .7;

}
  


</style>
</head>

<body>

  <script src="https://unpkg.com/smoothscroll-polyfill@0.4.4/dist/smoothscroll.js"></script>
  <!--- m-auto --->
  <div class=" max-w-3xl">
  <div
      x-data="{
          skip: 1,
          next() {
              this.to((current, offset) => current + (offset * this.skip))
          },
          prev() {
              this.to((current, offset) => current - (offset * this.skip))
          },
          to(strategy) {
              let slider = this.$refs.slider
              let current = slider.scrollLeft
              let offset = slider.firstElementChild.getBoundingClientRect().width
  
              slider.scrollTo({ left: strategy(current, offset), behavior: 'smooth' })
          }
      }"
      class="flex flex-col w-full"
  >
      <div
          @keydown.right="next"
          @keydown.left="prev"
          tabindex="0"
          role="region"
          aria-labelledby="carousel-label"
          class="flex space-x-6"
      >
          <button @click="prev" class="text-6xl ">
              <span aria-hidden="true">❮</span>
          </button>
            
          <ul
              x-ref="slider"
              tabindex="0"
              role="listbox"
              aria-labelledby="carousel-content-label"
              class="flex w-full overflow-x-scroll"
              style="scroll-snap-type: x mandatory;"
          >
              <li id="img_container0" style="scroll-snap-align: start;" class="w-full flex-shrink-0 flex flex-col items-center justify-center p-2" role="option">
                  <img id="img_0" class="mt-2 w-full" src="/images/photos/1.jpg" alt="placeholder image">
  
                  <span class="px-4 py-2 text-sm">this is a description</span>
              </li>
              <li style="scroll-snap-align: start;" class="w-full flex-shrink-0 flex flex-col items-center justify-center p-2" role="option">
                  <img class="mt-2 w-full" src="/images/photos/2.jpg" alt="placeholder image">
  
                  <span class="px-4 py-2 text-sm">this is a description</span>
              </li>
  
              <li style="scroll-snap-align: start;" class="w-full flex-shrink-0 flex flex-col items-center justify-center p-2" role="option">
                  <img class="mt-2 w-full" src="/images/photos/3.jpg" alt="placeholder image">
  
                  <span class="px-4 py-2 text-sm">this is a description</span>
              </li>
  
              <li style="scroll-snap-align: start;" class="w-full flex-shrink-0 flex flex-col items-center justify-center p-2" role="option">
                  <img class="mt-2 w-full" src="/images/photos/4.jpg" alt="placeholder image">
  
                  <span class="px-4 py-2 text-sm">this is a description</span>
              </li>
              
              <li style="scroll-snap-align: start;" class="w-full flex-shrink-0 flex flex-col items-center justify-center p-2" role="option">
                  <img class="mt-2 w-full" src="/images/photos/5.jpg" alt="placeholder image">
  
                  <span class="px-4 py-2 text-sm">Do Something</span>
              </li>
  
              <li style="scroll-snap-align: start;" class="w-full flex-shrink-0 flex flex-col items-center justify-center p-2" role="option">
                  <img class="mt-2 w-full" src="/images/photos/6.jpg" alt="placeholder image">
  
                  <span class="px-4 py-2 text-sm">this is a description</span>
              </li>
          </ul>
  
          <button @click="next" class="text-6xl">
              <span aria-hidden="true">❯</span>
          </button>
      </div>
  </div>
</div>  




</body>

</html>
