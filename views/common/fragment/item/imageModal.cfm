

<!--- 
// rightBoundary =  document.getElementById('slider').getBoundingClientRect().right;
--->
<div x-data="{ imgModalSrc : '', zoom: false, rightBoundary : 0}" >
    <template @img-modal.window="{
            imgModalSrc = $event.detail.imgModalSrc;
          }" x-if="imgModalSrc">
        <div x-ref="imageModal" id="imageModal" class="image-modal"
            x-transition:enter="transition ease-out duration-300" x-transition:enter-start="opacity-0 transform scale-90" 
            x-transition:enter-end="opacity-100 transform scale-100" x-transition:leave="transition ease-in duration-300" x-transition:leave-start="opacity-100 transform scale-100" 
            x-transition:leave-end="opacity-0 transform scale-90" 
            @click.away="imgModalSrc = ''" >
            <div id="img-container" @click.away="imgModalSrc = ''" class="image-modal-main">
                <img id="largeImage"  @click="imgModalSrc = ''" :alt="imgModalSrc"  :src="imgModalSrc">
            </div>
            <!--- <svg x-show="!zoom"
                @mouseenter="zoom= !zoom;document.getElementById('theimg').style.objectFit= 'cover'" 
                xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0zM10 7v3m0 0v3m0-3h3m-3 0H7" />
                
            </svg>

            <svg
                x-show="zoom" 
                @mouseleave="zoom= !zoom;document.getElementById('theimg').style.objectFit= 'contain'" 
                xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0zM13 10H7" />
             </svg> --->

             <svg
                xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" >
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
            </svg>
      </div>
    </template>
</div> 





<!--- 

<div x-data="{ imgModal : false, imgModalSrc : '', imgModalDesc : '', zoomin : false }" >
    <template @img-modal.window="imgModal = true; imgModalSrc = $event.detail.imgModalSrc; imgModalDesc = $event.detail.imgModalDesc; " x-if="imgModal">
      
        <div class="carousel-modal"
            x-transition:enter="transition ease-out duration-300" x-transition:enter-start="opacity-0 transform scale-90" 
            x-transition:enter-end="opacity-100 transform scale-100" x-transition:leave="transition ease-in duration-300" x-transition:leave-start="opacity-100 transform scale-100" 
            x-transition:leave-end="opacity-0 transform scale-90" x-on:click.away="imgModalSrc = ''" >
        
            <div id="img-container" @click.away="imgModal = ''" class="carousel-modal-main">
            <!--- <div style="z-index: 50;">
                <button @click="zoomin = !zoomin" class="zoom" :class="{ 
                    'zoomed': zoomin
                }">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor"  class=" h-6"  >
                        <path d="M5 8a1 1 0 011-1h1V6a1 1 0 012 0v1h1a1 1 0 110 2H9v1a1 1 0 11-2 0V9H6a1 1 0 01-1-1z" />
                        <path fill-rule="evenodd" d="M2 8a6 6 0 1110.89 3.476l4.817 4.817a1 1 0 01-1.414 1.414l-4.816-4.816A6 6 0 012 8zm6-4a4 4 0 100 8 4 4 0 000-8z" clip-rule="evenodd" />
                    </svg>
                </button>
                <button @click="imgModal = ''" class="close" :class="{ 
                    'zoomed': zoomin
                }">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="h-6">
                        <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd" />
                    </svg>
                </button>	  
            </div> --->
            <!-- <div class="p-2 overflow-hidden"> -->
                <!---  id="img-main" class="transform"  --->
                <img @click="imgModal = ''" :alt="imgModalSrc"  :src="imgModalSrc">
                <!--- <img @click="zoomin = !zoomin" :alt="imgModalSrc" class="transform"
                :class="{ 
                    'scale-200': zoomin
                }" 
                :src="imgModalSrc"> --->
                <!--- <p x-text="imgModalDesc" class="text-center text-white "></p> --->
            <!-- </div> -->
            </div>
            <!--- <div id="img-result" class="carousel-img-zoom-result"></div> --->
      </div>
    </template>
    </div>  --->