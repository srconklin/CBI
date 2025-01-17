	<!--- item quick view as a modal --->
	<cfoutput>
	<div class="modal-container"  
		x-cloak
		x-data="{ itemno: 0}" 
		x-show="$store.imodal.modal"  
		@keydown.escape.prevent.stop="itemno =0;$store.imodal.closeModal($event)"
		@show-modal.window="itemno=$event.detail.itemno;$store.imodal.showItem($event.detail.itemno);"
		x-trap.noscroll.inert="$store.imodal.modal"
		role="dialog"
		aria-modal="true"
		x-id="['headline']"
		:aria-labelledby="$id('headline') ">

		<!--- A basic modal dialog with title, body and one button to close --->
		<div class="modal" @click.away="$store.imodal.closeModal();">

			<!--- modal header --->
			<div class="modal-header">
				<button @click.prevent="$store.imodal.closeModal($event)" class="carousel-button">
					<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
						<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
					</svg>
				 </button>
			</div>

			<!--- modal body --->
			<!--- <template x-if="true"> --->
				<article class="item">
					<!--- left column image carousel --->
					<aside>
							#view('common/fragment/carousel')#
							#view('common/fragment/imageModal')#
					</aside>
					<!--- right column item detail --->
					<main> 

						<div class="userprefs">
							<div>
								<cfif rc.userSession.isLoggedIn >
									<a href="##" @click.prevent="$store.favorites.toggle(itemno)">
										<svg xmlns="http://www.w3.org/2000/svg"
											fill="none"
											viewBox="0 0 24 24" stroke="currentColor" 
											>
											<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z" />
										</svg>Favorite</a>
								<cfelse>
									<a href="##" x-on:click.prevent="$dispatch('show-login', { title: 'You must login to continue' })">
										<svg xmlns="http://www.w3.org/2000/svg"
											:class="{ 'favorite': $store.favorites.isFavorite(itemno) }" 
											:fill="$store.favorites.isFavorite(itemno) ? '##fa0114' : 'none'"
											 viewBox="0 0 24 24" stroke="currentColor" 
											 >
											<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z" />
										</svg>Favorite</a>

								</cfif>
									
							</div>
							
							<div>
								<a href="##"><svg  fill=none xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" stroke="currentColor">
								<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8.684 13.342C8.886 12.938 9 12.482 9 12c0-.482-.114-.938-.316-1.342m0 2.684a3 3 0 110-2.684m0 2.684l6.632 3.316m-6.632-6l6.632-3.316m0 0a3 3 0 105.367-2.684 3 3 0 00-5.367 2.684zm0 9.316a3 3 0 105.368 2.684 3 3 0 00-5.368-2.684z" />
							  	</svg>Share</a>
							</div>
						</div>
						
						<div class="detail">
							<!--- left column: headline, class, description --->
							<div>
								<h1 :id="$id('headline')" itemprop="name" class="headline" x-text="$store.imodal.content.headline"></h1> 
								<p itemprop="category" class="category" x-text="$store.imodal.content.category"></p> 
								<p itemprop="description" class="description" x-text="$store.imodal.content.description"></p> 
								<p itemprop="offers" class="offers" itemscope itemtype="http://schema.org/Offer">
									<span class="qty" x-text="$store.imodal.content.qty"></span> unit<span x-show="$store.imodal.content.qty > 1">s</span> @ <span itemprop="price" content=x-bind:content="$store.imodal.content.price" class="price" x-text="$store.imodal.content.price"></span>
								</p>
							</div>
							<!--- right column: mfr, model, location and itemno --->
							<div class="specs-wrapper">
								<div class="specs-summary">
									<p itemprop="manufacturer" class="mfr">
										<span>Make:</span>
										<span x-text="$store.imodal.content.mfr"></span>
									</p>
									<p itemprop="model" class="model">
										<span>Model:</span>
										<span x-text="$store.imodal.content.model"></span>
									</p>
									<p class="location">
										<span>Location:</span>
										<span x-text="$store.imodal.content.location"></span>
									</p>
									<p itemprop="productID" class="itemno">
										<span>Item ID:</span>
										<span><a x-bind:href="'/items/' + $store.imodal.content.itemno + '/' + $store.imodal.content.itemses"  x-text="$store.imodal.content.itemno"></a></span>
									</p>
								</div>
							</div>
						</div>
						
						
							#view( 'common/fragment/tabs')#

						<!--- <div class="footer">
							<p><span class="location" x-text="content.location"></span></p> 
							<p>Item &bull; <a href="/items/36660"><span itemprop="productID" class="itemno" x-text="content.itemno"></span></a></p> 
						</div>
						<p itemprop="description" class="description" x-text="content.description"></p>  --->
					</main>
				</article> 
			<!--- </template> --->

			<!--- <div class="modal-footer">
			<button @click="modal = false" class="btn btn-primary">
				Close this modal!
				</button> 
			</div> --->

		</div>
	</div>
</cfoutput>