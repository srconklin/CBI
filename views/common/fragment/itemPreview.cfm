	<!------------------------------------------ 
		item preview as a modal
	 ---------------------------------------->

	<!--- set config options --->
	<cfset fullsize =  true/>
	<cfset xshow =  'ipOpen'/>

	<!--- xdata --->
	<cfsavecontent variable="xdata">
		x-cloak
		x-data="{
			itemno: 0,
			ipOpen: false,
		    close() {
				this.ipOpen=false;
				$store.itempreview.close();
				
			},
			onShowItem($event) {
				this.itemno=$event.detail.itemno;
				$store.itempreview.showItem(this.itemno);
				this.ipOpen = true;
				
			}
		}" 
		x-show="ipOpen"  
		@keydown.escape.prevent.stop="itemno=0;close();"
		@show-item.window="onShowItem($event)"
		x-trap.noscroll.inert="ipOpen"
		role="dialog"
		aria-modal="true"
		x-id="['headline']"
		:aria-labelledby="$id('headline')"
	</cfsavecontent>

	<!--- the content --->
	<cfsavecontent variable="content">
		<cfoutput>
		<article class="item">
			<!--- left column image carousel --->
			<aside>
				#view('common/fragment/carousel')#
				#view('common/fragment/imageModal')#
			</aside>
			<!--- right column item detail --->
			<main> 
				#view('common/fragment/itemFeatures' , {server=false})#

				<!--- tabs for specs  --->
				#view('common/fragment/itemTabs')#
			</main>

		</article> 
	</cfoutput>
	</cfsavecontent>

<cfinclude template="modal.cfm">
	