	<!------------------------------------------ 
		item quick view as a modal
	 ---------------------------------------->

	<!--- set config options --->
	<cfset fullsize =  true/>
	<cfset xshow =  '$store.imodal.modal'/>

	<!--- xdata --->
	<cfsavecontent variable="xdata">
		x-cloak
		x-data="{
			 itemno: 0,
			 close() {
				$store.imodal.closeModal()
			 }
		}" 
		x-show="$store.imodal.modal"  
		@keydown.escape.prevent.stop="itemno=0;close();"
		@show-item.window="itemno=$event.detail.itemno;$store.imodal.showItem($event.detail.itemno);"
		x-trap.noscroll.inert="$store.imodal.modal"
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
			#view('common/fragment/itemFeatures' , {server=false})#
		</article> 
	</cfoutput>
	</cfsavecontent>

<cfinclude template="modal.cfm">
	