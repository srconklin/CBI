<!--- x-data="{ $store.carousel.direction: 'leftoright', $store.carousel.activeSlide: 0, $store.carousel.slides: [ ] }" --->
<div class="carousel" x-data >
						
	<div class="carousel-sizer"  >
	
		<!-- previous arrow -->
		<div class="carousel-prev">
			<button 
			  class="carousel-button"
			  x-on:click="$refs.slider.scrollLeft = $refs.slider.scrollLeft - ($refs.slider.scrollWidth / $store.carousel.slides.length)">
			  <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
				<path stroke-linecap="round" stroke-linejoin="round" stroke-width="1" d="M11 15l-3-3m0 0l3-3m-3 3h8M3 12a9 9 0 1118 0 9 9 0 01-18 0z" />
			  </svg>
			 </button>
		</div>
	
		<!--the images -->
		<div class="snap carousel-slider" id="slider" x-ref="slider" x-on:scroll="$store.carousel.active = Math.round($event.target.scrollLeft / ($event.target.scrollWidth / $store.carousel.slides.length))">
			<template x-for="(slide, index) in $store.carousel.slides" :key="index">
				<!--- <div style="overflow:hidden;"> --->
					<div
					class="carousel-slide" 
					x-on:mousedown="$store.carousel.mousedown($event)"
					x-on:mouseup="$store.carousel.mouseup($event)"
					x-on:mousemove="$store.carousel.mousemove($event)">
					<!--- <a @click="$dispatch('img-modal', {  imgModalSrc: slide, imgModalDesc: 'This is a description' })" class="cursor-pointer">  --->
						<img class="panner object-cover" :src="slide"> 
					<!--- </a>  --->
					</div>
				<!--- </div> --->
			</template>
	</div>
		  <!-- Next Arrow -->
		<div class="carousel-next">
		  <button 
			class="carousel-button"
			x-on:click="$refs.slider.scrollLeft = $refs.slider.scrollLeft + ($refs.slider.scrollWidth / $store.carousel.slides.length)">
			<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
				<path stroke-linecap="round" stroke-linejoin="round" stroke-width="1" d="M13 9l3 3m0 0l-3 3m3-3H8m13 0a9 9 0 11-18 0 9 9 0 0118 0z" />
			  </svg>
		  </button>
		</div>        
	 
	</div>
	<!--- navigator --->
	<div class="carousel-navbar">
		<template x-for="(slide, index) in $store.carousel.slides" :key="index">
			<!--- <button
			class="carousel-nav-btn"
			:class="{ 
				'carousel-nav-btn-active': $store.carousel.activeSlide === index
			}" 
			x-on:click="$store.carousel.activeSlide = index"></button> --->
			<div x-show="$store.carousel.active === index" class="carousel-pager">
				<span x-text="++index"></span>/<span x-text="$store.carousel.slides.length"></span>
			</div> 
		</template>
	</div> 
	
</div>


<div x-data="{ imgModal : false, imgModalSrc : '', imgModalDesc : '', zoomin : false }">
<template @img-modal.window="imgModal = true; imgModalSrc = $event.detail.imgModalSrc; imgModalDesc = $event.detail.imgModalDesc;" x-if="imgModal">
  
	<div class="carousel-modal"
		x-transition:enter="transition ease-out duration-300" x-transition:enter-start="opacity-0 transform scale-90" 
		x-transition:enter-end="opacity-100 transform scale-100" x-transition:leave="transition ease-in duration-300" x-transition:leave-start="opacity-100 transform scale-100" 
		x-transition:leave-end="opacity-0 transform scale-90" x-on:click.away="imgModalSrc = ''" >
	
	<div @click.away="imgModal = ''" class="carousel-modal-main">
	  <div style="z-index: 50;">
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
	  </div>
	  <!-- <div class="p-2 overflow-hidden"> -->
		<img @click="zoomin = !zoomin" :alt="imgModalSrc" class="transform"
		:class="{ 
			'scale-200': zoomin
		}" 
		:src="imgModalSrc">
		<p x-text="imgModalDesc" class="text-center text-white "></p>
	  <!-- </div> -->
	</div>
  </div>
</template>
</div> 