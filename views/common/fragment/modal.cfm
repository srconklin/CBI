<!--- modal alpine wrapper --->

<cfparam name="xdata" default="">
<cfparam name="xshow" default="open">
<cfparam name="content" default="Please set me!">
<cfparam name="fullsize" default="false">

<cfoutput>

	<div class="modal-container2" 
	#xdata#
	>

		<!--- overlay  x-show="$store.imodal.modal" --->
		<div class="overlay"  x-show="#xshow#" x-transition.opacity.duration.500ms></div>	

		<!--- positioning --->
		<div class="positioner" x-show="#xshow#" x-transition:enter.duration.500ms>

			<!--- frame for modal contents --->
			<div 
			class="frame <cfif fullsize>fullsize</cfif>"
			x-show="#xshow#"
			@click.away="close"
			>
				<div class="head">
					<button @click.prevent="close" > 
						<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
							<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
						</svg> 
					</button>
				</div> 

				<div class="scroller">
					<div class="flex mb-4">

						<!--- content row --->
						<div class="margin"></div>
						<!--- content to be injected here --->
						<div style="width:100%">
							#content#
						</div>
						<div class="margin"></div>

					</div> 
				</div>
			</div>
		</div>	
	</div>	
</cfoutput>