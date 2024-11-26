<cfoutput>
	<!--- set config options --->
	
	<cfset fullsize =  false/>
	<cfset xshow =  'open'/> 

	<!--- xdata --->
	<cfsavecontent variable="xdata">
		x-cloak
		x-data="{
			title: '',
			open: false,
		    close() {this.open=false; },
			onShowLogin($event){
				title=$event.detail.title;
				this.open=true;
				document.getElementById('destination').value = window.location.pathname;
			} 
		}" 

		x-show="open"  
		@keydown.escape.prevent.stop="title='';close();"
		@show-login.window="onShowLogin($event)"
		x-trap.noscroll.inert="open"
		role="dialog"
		aria-modal="true"
		x-id="['title']"
		:aria-labelledby="$id('title')" 
	</cfsavecontent>

	<!--- the content --->
	<cfsavecontent variable="content"><cfoutput>
		<cfset rc.showlogin = true />
		#view('/register/default', {concise = true})#
	</cfoutput></cfsavecontent>

<cfinclude template="modal.cfm">
	
</cfoutput>	