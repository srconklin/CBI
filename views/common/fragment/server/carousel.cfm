<cfoutput>

    <div class="carousel-sizer" x-data>
        <div id="carousel"  class="carousel" >
            <!--- @keydown.right="$store.carousel.next"
                @keydown.left="$store.carousel.prev" --->
            <div class="carousel-widget">
    
                <button 
                  @click="$store.carousel.prev()"
                  class="carousel-button" tabindex="-1">
                    <svg tabindex="0" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1" d="M11 15l-3-3m0 0l3-3m-3 3h8M3 12a9 9 0 1118 0 9 9 0 01-18 0z" />
                    </svg>
                </button>
                  
                <ul
                    id="slider"
                    x-ref="slider"
                    tabindex="0"
                    class="carousel-slider">
                    <cfloop array="#rc.content.imagesXtra#" item="image">
                       <li class="carousel-slide" >
                            <img src="#rc.content.imgbase##image#"  alt="#rc.content.imgbase##image#" 
                            @click="$dispatch('img-modal', {  imgModalSrc: '#rc.content.imgbase##image#'})"
                            <!--- @mouseenter="if (window.largeSOnly()) $dispatch('img-modal', {  imgModalSrc: slide})" 
                            @mouseleave="if (window.largeSOnly()) $dispatch('img-modal', {  imgModalSrc: ''})"> --->
                            >
                            
                        </li>
                    </cfloop>
                </ul>
        
                <button 
                    @click="$store.carousel.next()"
                    class="carousel-button" tabindex="-1">
                    <svg tabindex="0" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1" d="M13 9l3 3m0 0l-3 3m3-3H8m13 0a9 9 0 11-18 0 9 9 0 0118 0z" />
                    </svg>
                 </button>
            </div>
        </div>
       
      </div>  


</cfoutput>
