<div class="offer">
	<form id="offerfrm" method="post" x-data @submit.prevent="$store.forms.submit('offer')">
		<!--- <input type="hidden" name="itemno" :value="$store.forms.itemno"> --->
		<!--- <input type="hidden" name="frmpos" value="0"> --->
		<!--- <input type="hidden" name="ttypeno" value="11"> --->
		<!--- <input type="hidden" name="qtyShown" :value="$store.forms.qtyShown">
		<input type="hidden" name="priceShown" :value="$store.forms.priceShown"> --->

		<div class="form-row">
			<cfoutput>
					<label id="myoffer" for="priceStated" class="form-label">
					My Offer<span>&nbsp;*</span> <cfif rc.userSession.isLoggedIn><a href="/myprofile" class="user">as #rc.userSession.name# <svg xmlns="http://www.w3.org/2000/svg" class="hit-svg" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14"></path></svg></a></cfif> 
				</label>
			</cfoutput>
			<div class="offer-total-row">
					<!--- https://stackoverflow.com/questions/19233415/how-to-make-type-number-to-positive-numbers-only --->
					<div>
						<input 
						id="qtyStated"
						name="qtyStated" 
						type="number"
						class="form-control qty-ele" 
						placeholder="qty"
						maxlength="3"
						title="enter a quantity for your offer"						
						<!--- optional --->
						required
						step="1" min="1" 
						data-msg='["valueMissing:Please enter a valid quantity"]'
						oninput="validity.valid||(value='');" 
						<!--- alpine --->
						:class="{'invalid':$store.forms.toggleError('qtyStated')}" 
						:max="$store.forms.maxqty" 
						:readonly="$store.forms.maxqty==1"  
						x-model="$store.forms.qtyStated.value"
						@blur="$store.forms.validate($event)" 
						  />
					</div>

					<div style="padding: .2rem 0">@</div>
					
					<div>
						<div class="input-group">
							<span class="input-group-icon">
								$
							</span>
							
							<input 
							id="priceStated"
							name="priceStated" 
							type="text"
							class="form-control input-group-ele currency-ele" 
							placeholder="999,999.00"
							maxlength="10"
							title="enter a price for your offer"						
							<!--- optional --->
							required
							<!--- pattern="^\$\d{1,3}(,\d{3})*(\.\d+)?$"  --->
							data-msg='["valueMissing:Please enter a valid price"]'
							oninput="this.value=formatCurrency(this.value);"
							<!--- alpine --->
							:class="{'invalid':$store.forms.toggleError('priceStated')}"  
							x-model="$store.forms.priceStated.value"
							@blur="$store.forms.validate($event)"  />
						</div>
					</div>
					<div>=</div>
					<div 
						class="total" 
						x-text="$store.forms.total">
					</div>
				</div>
			<p 
				class="helper error-message qty-msg" 
				<!--- alpine --->
				x-cloak 
				x-show="$store.forms.toggleError('qtyStated')" 
				x-text="$store.forms.qtyStated.errorMessage" >
			</p>
			<p 
				class="helper error-message price-msg" 
				<!--- alpine --->
				x-cloak 
				x-show="$store.forms.toggleError('priceStated')" 
				x-text="$store.forms.priceStated.errorMessage">
			</p>
		</div>
		<div class="form-row">
			<label for="terms" class="form-label">
				Qualifications or Contingencies
			</label>
			
			<textarea 
				id="terms"
				name="terms"
				class="form-control" 
				maxlength="250" 
				placeholder="enter any optional qualifications or conditions surrounding your offer"
				title="enter any optional qualifications or conditions surrounding your offer"
				<!--- optional --->
				cols="50" 
				rows="3"
				wrap="soft"
				<!--- alpine --->
				x-model="$store.forms.terms.value"
				@blur="$store.forms.validate($event)"
				>
			</textarea>

			<p class="count" x-cloak>
				<span x-text="$store.forms.termsRemain"></span> characters remaining.
			</p>

		</div>
		<div class="form-row">
			<label for="message" class="form-label">
				Additional Notes
			</label>
			<textarea 
				id="message"
				name="message"
				class="form-control"
				maxlength="250"
				placeholder="enter any additional notes or comments regarding the offer"
				title="enter any additional notes or comments regarding the offer"
				<!--- optional --->
				cols="50" 
				rows="3" 
			 	wrap="soft" 
				<!--- alpine --->
				x-model="$store.forms.message.value"
				@blur="$store.forms.validate($event)"
				>
			</textarea>
			<p class="count" x-cloak>
				<span x-text="$store.forms.messageRemain"></span> characters remaining.
		   </p>
		</div>
		<cfoutput>
			#view( 'common/fragment/personal', { phone = 'phone1'})#
		</cfoutput>
		
		<div
			class="form-row" 
			x-cloak 
			x-show="$store.forms.generalError">
				<p 
					class="helper error-message" 
					x-html="$store.forms.generalError">
				</p>
		</div>

		<div class="form-row">
			<button 
				id="makeoffer"
				name="makeoffer"
				type="submit" 
				class="btn btn-primary" 
				title="make your offer"
				<!--- alpine --->
				:class="{'submitting' :$store.forms.submitting}" 
				:disabled="$store.forms.submitting">
					<svg x-show="$store.forms.submitting" class="animate-spin processing"  xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
							<circle style="opacity: .25"  cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
							<path style="opacity: .75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
					</svg>MAKE OFFER
			</button>
		</div>

	  </form>

</div>