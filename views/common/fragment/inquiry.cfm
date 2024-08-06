<div class="offer">
	<form 
		id="inquiryfrm" 
		method="post" 
		x-data  
		@submit.prevent="$store.forms.submit('inquiry')">

		<div class="form-row" x-id="['message']">
			<cfoutput>
				<label :for="$id('message')" class="form-label">
					Message <cfif rc.userSession.isLoggedIn><a href="/myprofile" class="user">as #rc.userSession.name# <svg xmlns="http://www.w3.org/2000/svg" class="hit-svg" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14"></path></svg></a></cfif> 
				</label>
			</cfoutput>
			<textarea 
				name="message"
				maxlength="250" 
				class="form-control" 
				placeholder="ask a question or send a message to the asset manager"
				title="ask a question or send a message to the asset manager"
				<!--- optional --->
				required
				data-msg='["valueMissing:Please enter a message"]'
				cols="50" 
				rows="3"
				wrap="soft" 
				<!--- alpine --->
				:id="$id('message')"
				@blur="$store.inquiry.validate($event)"
				x-model="$store.inquiry.message.value" 
				></textarea>
			<p class="count" x-cloak>
				<span x-text="$store.inquiry.messageRemain"></span> characters remaining.
		   </p>
		   <p 
		   class="helper error-message" 
		   x-cloak 
		   x-show="$store.inquiry.toggleError('message')" 
		   x-text="$store.inquiry.message.errorMessage" >
	   </p>
		</div>
		
		<cfoutput>
			#view( 'common/fragment/personal', {store='inquiry'})#
		</cfoutput>

		<div
			class="form-row" 
			x-cloak 
			x-show="$store.inquiry.generalError">
				<p 
					class="helper error-message" 
					x-html="$store.inquiry.generalError">
				</p>
		</div>

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