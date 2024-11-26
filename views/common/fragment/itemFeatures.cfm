<!------------------------------------------ 
item features common template
---------------------------------------->
<cfparam name="local.server" default="false">

<cfoutput>
	<div class="userprefs">
		<div>
			<cfif rc.userSession.isLoggedIn >
				<a href="##" @click.prevent="$store.favorites.toggle(itemno)">
					<svg xmlns="http://www.w3.org/2000/svg"
						:class="{ 'favorite': $store.favorites.isFavorite(itemno) }" 
						:fill="$store.favorites.isFavorite(itemno) ? '##fa0114' : 'none'"
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
			<cfif local.server>
				<a href="##" x-on:click.prevent="$clipboard('#rc.URI#');$tooltip('Copied to clipboard!')"><svg  fill=none xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" stroke="currentColor">
			<cfelse>
				<a href="##" x-on:click.prevent="$clipboard($store.item.content.URI);$tooltip('Copied to clipboard!')"><svg  fill=none xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" stroke="currentColor">
			</cfif>
			<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8.684 13.342C8.886 12.938 9 12.482 9 12c0-.482-.114-.938-.316-1.342m0 2.684a3 3 0 110-2.684m0 2.684l6.632 3.316m-6.632-6l6.632-3.316m0 0a3 3 0 105.367-2.684 3 3 0 00-5.367 2.684zm0 9.316a3 3 0 105.368 2.684 3 3 0 00-5.368-2.684z" />
				</svg>Share</a>
		</div>
	</div>
	
	<div class="detail">
		<!--- left column: headline, class, description --->
		<div>
			<cfif local.server>
				<h1 itemprop="name" class="headline">#rc.content.headline#</h1> 
				<p itemprop="category" class="category">#rc.content.category#</p> 
				<p itemprop="description" class="description">#rc.content.description#</p> 
				<p itemprop="offers" class="offers" itemscope itemtype="http://schema.org/Offer">
					<span class="qty">#rc.content.qty#</span> unit <cfif rc.content.qty gt 1><span>s</span></cfif> @ <span itemprop="price" class="price">#rc.content.price#</span>
				</p>
			<cfelse>
				<h1 :id="$id('headline')" itemprop="name" class="headline" x-text="$store.item.content.headline"></h1> 
				<p itemprop="category" class="category" x-text="$store.item.content.category"></p> 
				<p itemprop="description" class="description" x-text="$store.item.content.description"></p> 
				<p itemprop="offers" class="offers" itemscope itemtype="http://schema.org/Offer">
					<span class="qty" x-text="$store.item.content.qty"></span> unit<span x-show="$store.item.content.qty > 1">s</span> @ <span itemprop="price" content=x-bind:content="$store.item.content.price" class="price" x-text="$store.item.content.price"></span>
				</p>
			</cfif>
		</div>
		<!--- right column: mfr, model, location and itemno --->
		<div class="specs-wrapper">
			<div class="specs-summary">
				<p itemprop="manufacturer" class="mfr">
					<span>Make:</span>
					<cfif local.server>
						<span>#rc.content.mfr#</span>
					<cfelse>
						<span x-text="$store.item.content.mfr"></span>
					</cfif>
				</p>
				<p itemprop="model" class="model">
					<span>Model:</span>
					<cfif local.server>
						<span>#rc.content.model#</span>
					<cfelse>
						<span x-text="$store.item.content.model"></span>
					</cfif>
				</p>
				<p class="location">
					<span>Location:</span>
					<cfif local.server>
						<span>#rc.content.location#</span>
					<cfelse>
						<span x-text="$store.item.content.location"></span>
					</cfif>
				</p>
				<p itemprop="productID" class="itemno">
					<span>Item ID:</span>
					<cfif local.server>
						<span>#rc.content.itemno#</span>
					<cfelse>
						<span><a x-bind:href="$store.item.content.URI"  x-text="$store.item.content.itemno"></a></span>
					</cfif>
				</p>
			</div>
		</div>
	</div>

</cfoutput>
