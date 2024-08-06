<cfoutput>
  <!--- <div>
	<p itemprop="category" class="category">#rc.content.category#</p> 
	<h1 itemprop="name">#rc.content.headline#</h1> 
	<p itemprop="description" class="description">#rc.content.description#</p> 
</div> --->

    <div id="item" itemno="#rc.content.itemno#" itemct="#arraylen(rc.content.imagesXtra)+1#">

		<!--- cookie crumb --->
		<!--- breadcrumb --->
		<div class="breadcrumb">
			<div id="breadcrumb">
			 #rc.bc#
			</div>
		</div>
  
		<article class="item">
			<!--- left column image carousel --->
			<aside>
				<cfoutput>
					#view( 'common/fragment/server/carousel')#
				</cfoutput>
			</aside>
			<!--- right column item detail --->
			<main> 
				<div class="detail">
					<!--- left column: headline, class, description --->
					<div>
						<h1 itemprop="name" class="headline">#rc.content.headline#</h1> 
						<p itemprop="category" class="category">#rc.content.category#</p> 
						<p itemprop="description" class="description">#rc.content.description#"></p> 
						<p itemprop="offers" class="offers" itemscope itemtype="http://schema.org/Offer">
							<span class="qty">#rc.content.qty#</span> unit <cfif rc.content.qty gt 1><span>s</span></cfif> @ <span itemprop="price" class="price">#rc.content.price#</span>
						</p>
					</div>
					<!--- right column: mfr, model, location and itemno --->
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
				
			</main>
		</article> 					

    </div>

</cfoutput>
