<!--- 
	x-data="{openTab :1, 
	activeBtnClasses : 'sm:-mb-px',  
	inactiveBtnClasses : 'sm:-mb-1', 
	activeBtnClasses : 'border-b sm:border-b-0 border-l border-t border-r rounded-t rounded-b sm:rounded-none text-yellow-700',
	inactiveBtnClasses : 'text-gray-600 hover:text-gray-600' }"
 --->

	<!--- <div class="tabs" x-data= "{
		openTab :1,
		specstable : '',
		showActiveTab (tab) {
		   return this.openTab === tab ? 'activeTab' : 'inActiveTab'
		},
		showActiveButton (tab) {
		  return this.openTab === tab ? 'activeBtn' : 'inActiveBtn'
		}
	}">
	<ul>
		<li :class="showActiveTab(1);"  @click="openTab = 1">
			<a :class="showActiveButton(1);"  href="javascript:void(0);">SPECS</a>
		</li>
		<li :class="showActiveTab(2);"   @click="openTab = 2">
			<a :class="showActiveButton(2);"  href="javascript:void(0);">MAKE OFFER</a>
		</li>
		<li :class="showActiveTab(3);"  @click="openTab = 3">
			<a :class="showActiveButton(3);"  href="javascript:void(0);">REQUEST INFO</a>
		</li>
		<li :class="showActiveTab(4);"  @click="openTab = 4">
			<a :class="showActiveButton(4);"  href="javascript:void(0);">S&H/PAYMENT</a>
		</li>
		
	</ul>

	<div class="tabcontent">
		<div x-show="openTab === 1">
			<div class="specs" x-html="specstable" ></div> 
		</div>
		<div x-show="openTab === 2">
			<cfoutput>
				#view( 'common/fragment/item/offer')#
			</cfoutput>
		</div>
		<div x-show="openTab === 3">
			<p>Coming Soon.</p>
		</div>
		<div x-show="openTab === 4">

			<div class="shipping">
				<h2>Shipping & Handling</h2>
				<p>
					Unless otherwise stated, all items will be fully tested and sold with our standard ninety day warranty, which is described in our terms and conditions. 
					Our standard procedure is to service the equipment as orders are placed. Lead times can vary depending on the item.
					Domestic and International shipments: Ex Works, Scotia, NY. All freight cost estimates are for dock to dock service only.
					Any additional services, i.e. lift-gate, inside or residential delivery, must be requested at the time of sale and will be billed accordingly.
					CBI is not responsible for any damage incurred during shipment. It is the buyer's responsibility to inspect packages for damage and to note any damage on bill of lading.
					Please feel free to call us with any questions. (Phone: 518.346.8347, Fax: 518.381.9578).

				</p>
				
			</div>
			<div class="payment">
				<h2>Payment</h2>
				<p>
					Minimum order of $50 required.
					We offer terms of net 30 days to all companies that have established credit with Capovani Brothers Inc. and have paid within terms.
					All federal, state, local governments and their agencies, as well as institutions of higher learning automatically receive terms.
					All other sales, including foreign sales, are prepayment only.
					MasterCard, VISA, Discover and AMEX are accepted at sellers discretion.

				</p>

			</div>
		</div>
	</div>

</div> --->

 

<div class="tabs" x-data>
	<ul>
		<li :class="$store.tabs.showActiveTab(1);"  @click="$store.tabs.openTab = 1">
			<a :class="$store.tabs.showActiveButton(1);"  href="javascript:void(0);">SPECS</a>
		</li>
		<li :class="$store.tabs.showActiveTab(2);"   @click="$store.tabs.openTab = 2">
			<a :class="$store.tabs.showActiveButton(2);"  href="javascript:void(0);">MAKE OFFER</a>
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
			<div class="specs" x-html="$store.tabs.content.specstable" ></div> 
		</div>
		<div x-show="$store.tabs.openTab === 2">
			<cfoutput>
				#view( 'common/fragment/item/offer')#
			</cfoutput>
			
		</div>
		<div x-show="$store.tabs.openTab === 3">
			<cfoutput>
				#view( 'common/fragment/item/inquiry')#
			</cfoutput>
		</div>
		<div x-show="$store.tabs.openTab === 4">

			<div class="shipping">
				<h2>Shipping & Handling</h2>
				<p>
					Unless otherwise stated, all items will be fully tested and sold with our standard ninety day warranty, which is described in our terms and conditions. 
					Our standard procedure is to service the equipment as orders are placed. Lead times can vary depending on the item.
					Domestic and International shipments: Ex Works, Scotia, NY. All freight cost estimates are for dock to dock service only.
					Any additional services, i.e. lift-gate, inside or residential delivery, must be requested at the time of sale and will be billed accordingly.
					CBI is not responsible for any damage incurred during shipment. It is the buyer's responsibility to inspect packages for damage and to note any damage on bill of lading.
					Please feel free to call us with any questions. (Phone: 518.346.8347, Fax: 518.381.9578).

				</p>
				
			</div>
			<div class="payment">
				<h2>Payment</h2>
				<p>
					Minimum order of $50 required.
					We offer terms of net 30 days to all companies that have established credit with Capovani Brothers Inc. and have paid within terms.
					All federal, state, local governments and their agencies, as well as institutions of higher learning automatically receive terms.
					All other sales, including foreign sales, are prepayment only.
					MasterCard, VISA, Discover and AMEX are accepted at sellers discretion.

				</p>

			</div>
		</div>
	</div>

</div> 