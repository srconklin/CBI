<div class="offer">
	<form id="inquiryfrm" method="post" x-data  @submit.prevent="$store.forms.form='inquiry';$store.forms.submit()">
		<input type="hidden" name="itemno" :value="$store.forms.itemno">
		<input type="hidden" name="frmpos" value="1">
		<input type="hidden" name="ttypeno" value="10">
		<input type="hidden" name="qtyShown" :value="$store.forms.qtyShown">
		<input type="hidden" name="priceShown" :value="$store.forms.priceShown">

		<div class="form-row">
			<cfoutput>
				<label for="message" class="form-label">
					Message <cfif rc.userSession.isLoggedIn><a href="/myprofile" class="user">as #rc.userSession.name# <svg xmlns="http://www.w3.org/2000/svg" class="hit-svg" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14"></path></svg></a></cfif> 
				</label>
			</cfoutput>
			<!---  @blur="$store.forms.message = stripHTML($store.forms.message);"  --->
			<textarea 
				id="message"
				name="message"
				maxlength="250" 
				class="form-control" 
				placeholder="ask a question or send a message to the asset manager"
				title="ask a question or send a message to the asset manager"
				<!--- optional --->
				required
				cols="50" 
				rows="3"
				wrap="soft" 
				<!--- alpine --->
				@blur="$store.forms.validateMessage()" 
				x-model="$store.forms.message" 
				>
			</textarea>
			<p class="count" x-cloak>
				<span x-text="$store.forms.messageRemain"></span> characters remaining.
		   </p>
		</div>
		
		<cfoutput>
			#view( 'common/fragment/item/personal', { phone = 'phone2'})#
		</cfoutput>

		<div class="form-row">
			<button 
				id="sendInquiry"
				name="sendInquiry"
				type="submit" 
				class="btn btn-red" 
				title="send your inquiry"
				<!--- alpinie --->
				:class="{'submitting' :$store.forms.submitting}" 
				:disabled="$store.forms.submitting">
				<svg x-show="$store.forms.submitting" class="animate-spin processing"  xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
						<circle style="opacity: .25"  cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
						<path style="opacity: .75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
				</svg>SEND
			</button>
		</div>

	  </form>

</div>