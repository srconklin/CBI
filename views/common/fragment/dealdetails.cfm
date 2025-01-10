	<!------------------------------------------ 
		deal details as a modal
	 ------------------------------------------>

	<!--- set config options --->
	<cfset fullsize =  false/>
	<cfset xshow =  'ddopen'/>

	<!--- xdata --->
	<cfsavecontent variable="xdata"><cfoutput>
		x-cloak
		x-data="{
			active: null,
			dealdata : [ {
				qtystated : '',
				pricestated : '',
				refnr: ''
				}],
			itemno: 0,
			ddopen: false,
			mainImage : '',
			get original() {
				return this.dealdata[this.dealdata.length -1];
			},
			get priceFormatted() {
				return formatter.format(this.dealdata[0].pricestated, 'blur');
			},
			get lastlinkrefnr() {
				return this.dealdata[0].refnr;
			},
		    get type() {
				const o = this.original;
				return  `${o.type}&nbsp;##${o.refnr}`;
			},
		    get qty() {
				return  this.dealdata[0].qtystated;
			},
			
			close() {
				
				dealdata = [{
					qtystated : '',
					pricestated : '',
					refnr: ''
				}],
				this.mainImage= '';
				this.ddopen=false; 
				
			},
			async onShowDealDetails($event){
				this.active=null;
		   
				window.httprequest('dealdetails', {
					query: {refnr: $event.detail.refnr}
				}).then(data =>  {
					this.dealdata = data.payload;
					$store.item.showItem(this.original.itemno).then(content =>{
						this.mainImage = `${content.imgbase}${content.imgMain}`;
						this.ddopen = true;

						<!--- set up to use the inquiry form --->
						$store.inquiry.itemno.value = this.original.itemno;
						$store.inquiry.ttypeno.value = 5;
						$store.inquiry.refnr.value = this.lastlinkrefnr;
						
						<!--- set up to use revise my offer   --->
						$store.offer.qtyStated.value = content.qty;
						$store.offer.priceStated.value = content.price == 'Best Price' ? '' : content.price.replace('$', '');
						$store.offer.qtyShown.value = content.qty;
						$store.offer.priceShown.value = content.price == 'Best Price' ? '' : content.price.replace(/[\$,]/g, '');
						$store.offer.maxqty = content.qty;
						$store.offer.itemno.value = content.itemno;
						$store.offer.refnr.value = this.lastlinkrefnr;
				
						
					}).catch(error => {	
						console.log('fetching item failed', error);
					});
				})
				.catch(error => {
					$dispatch('show-dealdetails-error', {error: `Oops! Something is not quite right: ${error.message}`})
					console.log('error getting deal details', error)
				});

			} 
		}" 

		x-show="ddopen"  
		@keydown.escape.window="close();"
		@show-dealdetails.window="onShowDealDetails($event)"
		x-trap.noscroll.inert="ddopen"
		role="dialog"
		aria-modal="true"
		x-id="['dealdata.refnr']"
		:aria-labelledby="$id('dealdata.refnr')" 
	</cfoutput>
	</cfsavecontent>

	<!--- the content --->
	<cfsavecontent variable="content">
		<cfoutput>	

			<h2 class="deal-offer-title" x-text="type"></h2>
				<div class="item">
									
						<!--- deal offer  --->
						<section class="deal-section mb-8">
							<div class="deal-offer-header">
								<h3>Item Info</h3>
							</div>
							<div class="content">
								<div class="deal-item-details">
									<img :src="mainImage" >
									<div class="">
										<h1 :id="$id('headline')" itemprop="name" class="headline" x-text="$store.item.content.headline"></h1> 
										<p itemprop="description" class="description mt-2" x-text="$store.item.content.description"></p> 
										<div class="specs-wrapper mt-4">
											<div class="specs-summary">
												<p itemprop="manufacturer" class="mfr">
													<span>Make:</span>
													<span x-text="$store.item.content.mfr"></span>
												</p>
												<p itemprop="model" class="model">
													<span>Model:</span>
													<span x-text="$store.item.content.model"></span>
												</p>
												<p class="location">
													<span>Location:</span>
													<span x-text="$store.item.content.location"></span>
												</p>
												<p itemprop="productID" class="itemno">
													<span>Item ID:</span>
													<span><a x-bind:href="$store.item.content.URI"  x-text="$store.item.content.itemno"></a></span>
												</p>
											</div>
										</div>
									</div>
								<div>
						   </div>
						</section>

						<!--- deal offer  --->
						<section class="deal-section mb-8 align-center">
							<div class="deal-offer-header">
								<h3>My Offer</h3>
							</div>
							<div class="content"><span x-text="qty"></span> unit @ <span class="price" x-text="priceFormatted"></span></div>
						</section>

						<!--- deal making dialogue --->
						<section class="mt-8">
							<!--- flex justify-between align-center --->
							<div class="deal-offer-header mb-2" >
								<h3>Messages </h3>
							</div>

							<!--- accordion nr 2 --->
							<div 
							x-data="{
								id: 2,
								get expanded() {
									return this.active === this.id
								},
								set expanded(value) {
									this.active = value ? this.id : null
								}
							}"
							role="region" 
							class="deal-responder mb-6 mt-6 ">
									<button
										type="button"
										x-on:click="expanded = !expanded"
										:aria-expanded="expanded"
										class="btn"
									>
										<span>Make a Counter Offer</span>
										<span x-show="expanded" aria-hidden="true" class="ml-4">&minus;</span>
										<span x-show="!expanded" aria-hidden="true" class="ml-4">&plus;</span>
									</button>

								<div x-show="expanded" class="form-responder" x-collapse >
									<div class="px-6 pb-4">
										<cfoutput>
											#view( 'common/fragment/offer')#
										</cfoutput>
									</div>
								</div>

							</div>
														
							<div
								<!--- accordion nr 1 --->
								<div 
								x-data="{
									id: 1,
									get expanded() {
										return this.active === this.id
									},
									set expanded(value) {
										this.active = value ? this.id : null
									}
								}"
								role="region" 
								class="deal-responder mb-6 mt-6">
										<button
											type="button"
											x-on:click="expanded = !expanded"
											:aria-expanded="expanded"
											class="btn"
										>
											<span>Send Message</span>
											<span x-show="expanded" aria-hidden="true" class="ml-4">&minus;</span>
											<span x-show="!expanded" aria-hidden="true" class="ml-4">&plus;</span>
										</button>

									<div x-show="expanded" class="form-responder" x-collapse >
										<div class="px-6 pb-4">
											<cfoutput>
												#view( 'common/fragment/inquiry')#
											</cfoutput>
										</div>
									</div>

								</div>

								
							</div> 
							<div class="mt-2 deal-m-panel">
								<div class="deal-speech-section">
									<template x-for="(deal, index) in dealdata">
										
										<div class="deal-bubble" :class="{'mine' : !deal.transdir }"> 
											<div class="notify-badge pill-green" x-show="deal.status == 'Answered' && index==0">New!</div>
												<div class="deal-head"> 
												<svg x-show='!deal.transdir' xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="64px" height="64px" viewBox="0 0 64 64" version="1.1">
													<circle fill="##FFFFFF" cx="32" width="64" height="64" cy="32" r="32"></circle>
														<text 
															x="50%" 
															y="50%" 
															fill="var(--color-primary)" 
															alignment-baseline="middle" 
															text-anchor="middle" 
															font-size="30" 
															font-weight="600" 
															dy=".1em" 
															dominant-baseline="middle">
															SC
													</text>
												</svg>
												<div x-show='deal.transdir' class="flex align-center">
													<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="size-6">
													<path fill-rule="evenodd" d="M7.5 6a4.5 4.5 0 1 1 9 0 4.5 4.5 0 0 1-9 0ZM3.751 20.105a8.25 8.25 0 0 1 16.498 0 .75.75 0 0 1-.437.695A18.683 18.683 0 0 1 12 22.5c-2.786 0-5.433-.608-7.812-1.7a.75.75 0 0 1-.437-.695Z" clip-rule="evenodd" />
													</svg>
													<span>CBI Staff</span>
												</div> 
												<div>
													<div class="time" x-text="deal.date"></div>
													<div class="refnr">refnr:&nbsp;<span class="text-bold" x-text="deal.refnr"></span></div>
												</div>
												
											</div>
											<div class="deal-message">
												<p class="text-bold mb-1 ">Message:</p>
												<span x-text="deal.message"></span>
												<p class="text-bold mb-1 mt-2" x-show="deal.terms">Terms:</p>
												<span  x-show="deal.terms" x-text="deal.terms"></span>
											</div>
											<div class="deal-stroke" :class="{'mine' : !deal.transdir }" aria-hidden="true"></div>
										</div>
										
									</template>	
								</div>
							
						</section>
						
			</div>
		</cfoutput>
	</cfsavecontent>

<cfinclude template="modal.cfm">
	