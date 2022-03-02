<!--- x-data="{ $store.carousel.direction: 'leftoright', $store.carousel.activeSlide: 0, $store.carousel.slides: [ ] }" --->
<div id="carousel" class="carousel" x-data >
						
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
		<!--- $store.carousel.active = Math.round($event.target.scrollLeft / ($event.target.scrollWidth / $store.carousel.slides.length)) --->
		<!---  x-on:scroll="$store.carousel.scroll($event)"	 --->
		<div class="snap carousel-slider" id="slider" x-ref="slider" x-on:scroll="$store.carousel.scroll($event)">
			<template x-for="(slide, index) in $store.carousel.slides" :key="index">
				<!--- <div style="overflow:hidden;"> --->
					<div
					:id="'img_container' + index"
					class="carousel-slide" 
					x-on:mousedown="$store.carousel.mousedown($event)"
					x-on:mouseup="$store.carousel.mouseup($event)"
					x-on:mousemove="$store.carousel.mousemove($event)">
					<a @click="$dispatch('img-modal', {  imgModalSrc: slide, imgModalDesc: 'This is a description' })" class="cursor-pointer">  
						<img :id="'img_' + index" class="panner object-cover" :src="slide" > 
					 </a>
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
	<div id="img-result" class="carousel-img-zoom-result"></div>
</div>

