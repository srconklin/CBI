<cfoutput>
	  <div id="item" itemno="#rc.content.itemno#" itemct="#arraylen(rc.content.imagesXtra)+1#">
  
		  <!--- cookie crumb --->
		  <div class="breadcrumb">
			   #rc.bc#
		  </div>
	
		  <article class="item">
			  <!--- left column image carousel --->
			  <aside>
				  <cfoutput>
					  #view( 'common/fragment/item/server/carousel')#
				  </cfoutput>
				  <cfoutput>
					#view( 'common/fragment/item/imageModal')#
				</cfoutput>
			  </aside>
			  <!--- right column item detail --->
			  <main> 
				  <div class="detail">
						<!--- left column: headline, class, description --->
						<div>
							<h1 itemprop="name" class="headline">#rc.content.headline#</h1> 
							<p itemprop="category" class="category">#rc.content.category#</p> 
							<p itemprop="description" class="description">#rc.content.description#</p> 
							<p itemprop="offers" class="offers" itemscope itemtype="http://schema.org/Offer">
								<span class="qty">#rc.content.qty#</span> unit <cfif rc.content.qty gt 1><span>s</span></cfif> @ <span itemprop="price" class="price">#rc.content.price#</span>
							</p>
						</div>
						<div class="specs-wrapper">
							<div class="specs-summary">
								<p itemprop="manufacturer" class="mfr">
									<span>Make:</span>
									<span>#rc.content.mfr#</span>
								</p>
								<p itemprop="model" class="model">
									<span>Model:</span>
									<span>#rc.content.model#</span>
								</p>
								<p class="location">
									<span>Location:</span>
									<span >#rc.content.location#</span>
								</p>
							</div>
						</div>
				  </div>
				  <div class="userprefs">
					  <div>
						  <a href="##"><svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
						  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z" />
							</svg>Favorite</a></div>
					  <div>
						  <a href="##"><svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
						  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8.684 13.342C8.886 12.938 9 12.482 9 12c0-.482-.114-.938-.316-1.342m0 2.684a3 3 0 110-2.684m0 2.684l6.632 3.316m-6.632-6l6.632-3.316m0 0a3 3 0 105.367-2.684 3 3 0 00-5.367 2.684zm0 9.316a3 3 0 105.368 2.684 3 3 0 00-5.368-2.684z" />
							</svg>Share</a>
					  </div>
				  </div>


				  <div class="item-nav-wrapper" >
					<div class="item-nav-sizer">
					  <ul class="item-nav">
							<li class="item-nav-item">
								<a href="##offer" class="nav-link" data-title="Make Offer">
									<button class="btn btn-red-hollow">Make Offer</button>
								</a>
							</li>
						
							<li class="item-nav-item">
								<a class="nav-link" href="##specs" data-title="Specifications">
									<button class="btn btn-red-hollow">Specifications</button>
								</a>	
							</li>
	
							<li class="item-nav-item">
								<a class="nav-link" href="##shippinghandling" data-title="Shipping and Handling">
									<button class="btn btn-red-hollow">Shipping & Handling</button>
								</a>	
							</li>
	
							<li class="item-nav-item">
								<a class="nav-link" href="##payment" data-title="Payment">
									<button class="btn btn-red-hollow">Payment</button>
								</a>	
							</li>
					  </ul>
					</div>
				  </div>
				  
			  </main>

			

			  <section id="offer">
				<div class="section">
					<a name="offer">
						<svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
							<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 9V7a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2m2 4h10a2 2 0 002-2v-6a2 2 0 00-2-2H9a2 2 0 00-2 2v6a2 2 0 002 2zm7-5a2 2 0 11-4 0 2 2 0 014 0z" />
						</svg>
						<h2 class="section-header">Make Offer</h2> 
					</a>
				
				</div>
				<!--- <div class="tabcontent"> --->
				 #view( 'common/fragment/item/offer')#
				<!--- </div> --->
			</section> 

			  <section id="specs">
					<div class="section">
						<a name="specs">
							<svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
								<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01" />
							</svg>
							<h2 class="section-header">Specifications</h2> 
						</a>	
				</div>
				<div class="tabcontent">
					<div class="specs">#rc.content.specstable#</div>
				</div>
			 </section>

			  <section id="shippinghandling">
					<div class="section">
						<a name="shippinghandling">
							<svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
								<path d="M9 17a2 2 0 11-4 0 2 2 0 014 0zM19 17a2 2 0 11-4 0 2 2 0 014 0z" />
								<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16V6a1 1 0 00-1-1H4a1 1 0 00-1 1v10a1 1 0 001 1h1m8-1a1 1 0 01-1 1H9m4-1V8a1 1 0 011-1h2.586a1 1 0 01.707.293l3.414 3.414a1 1 0 01.293.707V16a1 1 0 01-1 1h-1m-6-1a1 1 0 001 1h1M5 17a2 2 0 104 0m-4 0a2 2 0 114 0m6 0a2 2 0 104 0m-4 0a2 2 0 114 0" />
							  </svg>
							  <h2 class="section-header">Shipping &amp; Handling</h2> 
						</a>
							
				</div>
				<div class="">
					<div class="shippinghandling">
						Unless otherwise stated, all items will be fully tested and sold with our standard ninety day warranty, which is described in our terms and conditions. 
						Our standard procedure is to service the equipment as orders are placed. Lead times can vary depending on the item.
						Domestic and International shipments: Ex Works, Scotia, NY. All freight cost estimates are for dock to dock service only.
						Any additional services, i.e. lift-gate, inside or residential delivery, must be requested at the time of sale and will be billed accordingly.
						CBI is not responsible for any damage incurred during shipment. It is the buyer's responsibility to inspect packages for damage and to note any damage on bill of lading.
						Please feel free to call us with any questions. (Phone: 518.346.8347, Fax: 518.381.9578).
					</div>
				</div>
			 </section>
			  <section id="payment">
					<div class="section">
						<a name="payment">
							<svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
								<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
							  </svg>
							  <h2 class="section-header">Payment</h2> 
						</a>
							
				</div>
				<div class="">
					<div class="payment">
						Minimum order of $50 required. We offer terms of net 30 days to all companies that have established credit with Capovani Brothers Inc. and have paid within terms. All federal, state, local governments and their agencies, as well as institutions of higher learning automatically receive terms. All other sales, including foreign sales, are prepayment only. MasterCard, VISA, Discover and AMEX are accepted at sellers discretion.
					</div>
				</div>
			 </section>

		  </article> 					
  
	  </div>
  </cfoutput>
  