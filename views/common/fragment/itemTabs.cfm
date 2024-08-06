 <div class="tabs" x-data>
	<ul>
		<li :class="$store.tabs.showActiveTab(1);"   @click="$store.tabs.openTab = 1">
			<a :class="$store.tabs.showActiveButton(1);"  href="javascript:void(0);">MAKE OFFER</a>
		</li>
		<li :class="$store.tabs.showActiveTab(2);"  @click="$store.tabs.openTab = 2">
			<a :class="$store.tabs.showActiveButton(2);"  href="javascript:void(0);">SPECS</a>
		</li>
		<li :class="$store.tabs.showActiveTab(3);"  @click="$store.tabs.openTab = 3">
			<a :class="$store.tabs.showActiveButton(3);"  href="javascript:void(0);">REQUEST INFO</a>
		</li>
		<li :class="$store.tabs.showActiveTab(4);"  @click="$store.tabs.openTab = 4">
			<a :class="$store.tabs.showActiveButton(4);"  href="javascript:void(0);">S&H/PAYMENT</a>
		</li>
		
	</ul>

	<div class="tabcontent">
		<div x-show="$store.tabs.openTab === 1">
			<cfoutput>
				#view( 'common/fragment/offer')#
			</cfoutput>
			
		</div>
		<div x-show="$store.tabs.openTab === 2">
			<cfoutput>
				<div class="specs" x-html="$store.tabs.content.specstable"></div> 
				<div class="specs">#rc.content.specstable#</div> 
			</cfoutput>
		</div>
		<div x-show="$store.tabs.openTab === 3">
			<cfoutput>
				#view( 'common/fragment/inquiry')#
			</cfoutput>
		</div>
		<div x-show="$store.tabs.openTab === 4">

			<div class="shipping">
				<h2>Shipping & Handling</h2>
					<cfoutput>
						<div x-html="$store.tabs.content.shipterms"></div> 
						<div>#rc.content.shipterms#</div> 
					</cfoutput>
				
			</div>
			<div class="payment">
				<h2>Payment</h2>
				<cfoutput>
					<div x-html="$store.tabs.content.payterms"></div> 
					<div>#rc.content.payterms#</div> 
				</cfoutput>

			</div>
		</div>
	</div>

</div> 