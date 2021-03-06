<div class="carousel-sizer" x-data>
	<div id="carousel"  class="carousel" >
		<!--- @keydown.right="$store.carousel.next"
			@keydown.left="$store.carousel.prev" --->
		<div tabindex="0"class="carousel-widget">

			<button 
			  @click="$store.carousel.prev()"
			  class="carousel-button">
				<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
					<path stroke-linecap="round" stroke-linejoin="round" stroke-width="1" d="M11 15l-3-3m0 0l3-3m-3 3h8M3 12a9 9 0 1118 0 9 9 0 01-18 0z" />
				</svg>
			</button>
			  
			<ul
				id="slider"
				x-ref="slider"
				tabindex="0"
				class="carousel-slider">
				<template x-for="(slide, index) in $store.carousel.slides" :key="index">
					<li class="carousel-slide" >
							<img :src="slide"  :alt="slide" 
							@click="$dispatch('img-modal', {  imgModalSrc: slide})" 
							<!--- @mouseenter="if (window.largeSOnly()) $dispatch('img-modal', {  imgModalSrc: slide})" 
							@mouseleave="if (window.largeSOnly()) $dispatch('img-modal', {  imgModalSrc: ''})"> --->
							>
						<span >this is a description</span>
					</li>
				</template>
			</ul>
	
			<button 
				@click="$store.carousel.next()"
				class="carousel-button">
				<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
					<path stroke-linecap="round" stroke-linejoin="round" stroke-width="1" d="M13 9l3 3m0 0l-3 3m3-3H8m13 0a9 9 0 11-18 0 9 9 0 0118 0z" />
				</svg>
		 	</button>
		</div>
	</div>
	<!--- navigator --->
	<!--- <div class="carousel-navbar">
		<span x-text="$store.carousel.active"></span>/<span x-text="$store.carousel.slides.length"></span>
	</div>  --->
  </div>  
  
  



<!--- 
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
		<div class="snap carousel-slider" id="slider" x-ref="slider" x-on:scroll="$store.carousel.scroll($event)">
			<template x-for="(slide, index) in $store.carousel.slides" :key="index">

					<div
					:id="'img_container' + index"
					class="carousel-slide" 
					x-on:mousedown="$store.carousel.mousedown($event)"
					x-on:mouseup="$store.carousel.mouseup($event)"
					x-on:mousemove="$store.carousel.mousemove($event)">
					<!--- <a @click="$dispatch('img-modal', {  imgModalSrc: slide, imgModalDesc: 'This is a description' })" class="cursor-pointer">   --->
						<img :id="'img_' + index" class="panner object-cover" :src="slide" > 
					 <!--- </a> --->
					</div>
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
			<div x-show="$store.carousel.active === index" class="carousel-pager">
				<span x-text="++index"></span>/<span x-text="$store.carousel.slides.length"></span>
			</div> 
		</template>
	</div> 
	<div id="img-result" class="carousel-img-zoom-result"></div>
</div>
 --->
