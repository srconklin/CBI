<div class="offer">
	<form id="inquiryfrm" method="post" x-data  @submit.prevent="$store.offer.ttypeno=10;$store.offer.submit()">
		<input type="hidden" name="itemno" :value="$store.offer.itemno">
		<input type="hidden" name="ttypeno" value="10">
		<input type="hidden" name="qtyShown" :value="$store.offer.qtyShown">
		<input type="hidden" name="priceShown" :value="$store.offer.priceShown">


		<div class="form-row">
			<cfoutput>
				<label for="message" class="form-label">
					Message <cfif structKeyExists(session, 'auth') and session.auth.isLoggedIn><a href="##" class="user">(as #session.auth.fullname#)</a></cfif>
				</label>
			</cfoutput>
			<!---  @blur="$store.offer.message = stripHTML($store.offer.message);"  --->
			<textarea cols="50" rows="3" name="message" id="message" wrap="soft" class="form-control" @blur="$store.offer.validateMessage()" x-model="$store.offer.message" maxlength="250"></textarea>
			<p class="count" x-cloak>
				<span x-text="$store.offer.messageRemain"></span> characters remaining.
		   </p>
		</div>
		
		<cfoutput>
			#view( 'common/fragment/item/personal')#
		</cfoutput>

		<div class="helper success-message" x-cloak x-show="$store.offer.submitted">
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
		</div>

		<div class="form-row">
			<button type="submit" class="btn btn-red " :class="{'submitting' :$store.offer.submitting}" :disabled="$store.offer.submitting">
				<svg x-show="$store.offer.submitting" class="animate-spin processing"  xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
						<circle style="opacity: .25"  cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
						<path style="opacity: .75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
				</svg>SEND
			</button>
		</div>

	  </form>

</div>