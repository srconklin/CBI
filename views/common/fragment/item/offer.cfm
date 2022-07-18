<div class="offer">
	<form id="offerfrm" method="post" x-data  @submit.prevent="$store.forms.form='offer';$store.forms.submit()">
		<input type="hidden" name="itemno" :value="$store.forms.itemno">
		<input type="hidden" name="ttypeno" value="11">
		<input type="hidden" name="qtyShown" :value="$store.forms.qtyShown">
		<input type="hidden" name="priceShown" :value="$store.forms.priceShown">

		<div class="form-row">
			<cfoutput>

				
				<label id="myoffer" for="priceStated" class="form-label">
					My Offer <cfif rc.userSession.isLoggedIn><a href="##" class="user">(as #rc.userSession.name#)</a></cfif> <span>*</span>
					<!--- My Offer <cfif structKeyExists(session, 'auth') and session.auth.isLoggedIn><a href="##" class="user">(as #session.auth.fullname#)</a></cfif> <span>*</span> --->
				</label>
			</cfoutput>
			<div class="offer-total-row">
				<!--- https://stackoverflow.com/questions/19233415/how-to-make-type-number-to-positive-numbers-only --->
				<div>
					<input name="qtyStated" id="qtyStated" oninput="validity.valid||(value='');" class="form-control qty-ele" :class="{'invalid':$store.forms.qtyStated.errorMessage && $store.forms.qtyStated.blurred}" type="number" placeholder="qty" step="1" min="1" :max="$store.forms.maxqty" maxlength="3" :readonly="$store.forms.maxqty==1"  @blur="$store.forms.validate($event)" x-model="$store.forms.qtyStated.value" required data-msg='["valueMissing:Please enter a valid quantity"]'/>
				</div>

				<div style="padding: .2rem 0">@</div>
				
				<div>
					<div class="input-group">
						<span class="input-group-icon">
							$
						</span>
						<!--- pattern="^\$\d{1,3}(,\d{3})*(\.\d+)?$"  --->
						<input name="priceStated" id="priceStated" type="text" class="form-control input-group-ele currency-ele" :class="{'invalid':$store.forms.priceStated.errorMessage && $store.forms.priceStated.blurred}"  placeholder="999,999.00" oninput="this.value=formatCurrency(this.value);"  @blur="$store.forms.validate($event)" maxlength="10"  x-model="$store.forms.priceStated.value" data-msg='["valueMissing:Please enter a valid price"]' required/>
					</div>
					<!--- <p class="helper error-message" x-cloak x-show="$store.forms.priceStated.errorMessage && $store.forms.priceStated.blurred" x-text="$store.forms.priceStated.errorMessage" class="error-message"></p> --->
				</div>
				<div>=</div>
				<div class="total" x-text="$store.forms.total"></div>
			</div>
			<p class="helper error-message qty-msg" x-cloak x-show="$store.forms.qtyStated.errorMessage && $store.forms.qtyStated.blurred" x-text="$store.forms.qtyStated.errorMessage" ></p>
			<p class="helper error-message price-msg" x-cloak x-show="$store.forms.priceStated.errorMessage && $store.forms.priceStated.blurred" x-text="$store.forms.priceStated.errorMessage" class="error-message"></p>
		</div>
		<div class="form-row">
			<label for="terms" class="form-label">
				Qualifications or Contingencies
			</label>
			<!--- @blur="$store.forms.terms = stripHTML($store.forms.terms);"  --->
			<textarea cols="50" rows="3" name="terms" id="terms" wrap="soft" class="form-control"  @blur="$store.forms.validateTerms()"  x-model="$store.forms.terms" maxlength="250" ></textarea>
			<p class="count" x-cloak>
				 <span x-text="$store.forms.termsRemain"></span> characters remaining.
			</p>
		</div>
		<div class="form-row">
			<label for="message" class="form-label">
				Additional Notes
			</label>
			<!---  @blur="$store.forms.message = stripHTML($store.forms.message);"  --->
			<textarea cols="50" rows="3" name="message" wrap="soft" class="form-control" @blur="$store.forms.validateMessage()" x-model="$store.forms.message" maxlength="250"></textarea>
			<p class="count" x-cloak>
				<span x-text="$store.forms.messageRemain"></span> characters remaining.
		   </p>
		</div>
		<cfoutput>
			#view( 'common/fragment/item/personal', { phone = 'phone1'})#
		</cfoutput>
		
		<!--- <div class="helper success-message" x-cloak x-show="$store.forms.submitted">
			<div class="flex">
				<svg xmlns="http://www.w3.org/2000/svg" width="100%" height="100%" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-check-circle w-5 h-5 mx-2">
                    <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                    <polyline points="22 4 12 14.01 9 11.01"></polyline>
                </svg>
				<div>
				  <p class="font-bold">Success! Your offer was recieved</p>
				  <p class="text-sm">Someone will contact you soon</p>
				</div>
			</div>
		</div>  --->
		<div class="form-row" x-cloak x-show="$store.forms.captcha.errorMessage && $store.forms.captcha.blurred">
			<p class="helper error-message"  x-text="$store.forms.captcha.errorMessage" class="error-message"></p>
		</div>

		<div class="form-row">
			<button type="submit" class="btn btn-red " :class="{'submitting' :$store.forms.submitting}" :disabled="$store.forms.submitting">
				<svg x-show="$store.forms.submitting" class="animate-spin processing"  xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
						<circle style="opacity: .25"  cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
						<path style="opacity: .75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
				</svg>MAKE OFFER
			</button>
		</div>

	  </form>

</div>