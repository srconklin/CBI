<div class="offer">
	<form id="inquiryfrm" method="post" x-data  @submit.prevent="$store.forms.form='inquiry';$store.forms.submit()">
		<input type="hidden" name="itemno" :value="$store.forms.itemno">
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
			<textarea cols="50" rows="3" name="message"  wrap="soft" class="form-control"  @blur="$store.forms.validateMessage()" x-model="$store.forms.message" maxlength="250" required></textarea>
			<p class="count" x-cloak>
				<span x-text="$store.forms.messageRemain"></span> characters remaining.
		   </p>
		</div>
		
		<cfoutput>
			#view( 'common/fragment/item/personal', { phone = 'phone2'})#
		</cfoutput>

		<!--- <div class="helper success-message" x-cloak x-show="$store.forms.submitted">
			<div class="flex">
				<svg xmlns="http://www.w3.org/2000/svg" width="100%" height="100%" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-check-circle w-5 h-5 mx-2">
                    <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                    <polyline points="22 4 12 14.01 9 11.01"></polyline>
                </svg>
				<div>
				  <p class="font-bold">Message Sent! </p>
				  <p class="text-sm">Someone will contact you soon</p>
				</div>
			</div>
		</div> --->

		<div class="form-row" x-cloak x-show="$store.forms.captcha.errorMessage && $store.forms.captcha.blurred">
			<p class="helper error-message"  x-text="$store.forms.captcha.errorMessage" class="error-message"></p>
		</div>

		<div class="form-row">
			<button type="submit" class="btn btn-red " :class="{'submitting' :$store.forms.submitting}" :disabled="$store.forms.submitting">
				<svg x-show="$store.forms.submitting" class="animate-spin processing"  xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
						<circle style="opacity: .25"  cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
						<path style="opacity: .75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
				</svg>SEND
			</button>
		</div>

	  </form>

</div>