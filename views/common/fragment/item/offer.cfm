<div class="offer">
	<form id="offerfrm" action="/offer" method="post" x-data  @submit.prevent="$store.offer.submit()">
		<input type="hidden" name="itemno" :value="$store.offer.itemno">
		
		<div class="form-row">
			<label id="myoffer" for="priceStated" class="form-label">
				My Offer <span>*</span>
			</label>
			
			<div class="offer-total-row">
				<!--- https://stackoverflow.com/questions/19233415/how-to-make-type-number-to-positive-numbers-only --->
				<div>
					<input name="qtyStated" id="qtyStated" oninput="validity.valid||(value='');" class="form-control qty-ele" :class="{'invalid':$store.offer.qtyStated.errorMessage && $store.offer.qtyStated.blurred}" type="number" placeholder="qty" step="1" min="1" :max="$store.offer.maxqty" maxlength="3" :readonly="$store.offer.maxqty==1"  @blur="$store.offer.validate($event)" x-model="$store.offer.qtyStated.value" required data-msg='["valueMissing:Please enter a valid quantity"]'/>
				</div>

				<div style="padding: .2rem 0">@</div>
				
				<div>
					<div class="input-group">
						<span class="input-group-icon">
							$
						</span>
						<!--- pattern="^\$\d{1,3}(,\d{3})*(\.\d+)?$"  --->
						<input name="priceStated" id="priceStated" type="text" class="form-control input-group-ele currency-ele" :class="{'invalid':$store.offer.priceStated.errorMessage && $store.offer.priceStated.blurred}"  placeholder="999,999.00" oninput="this.value=formatCurrency(this.value);"  @blur="$store.offer.validate($event)" maxlength="10"  x-model="$store.offer.priceStated.value" data-msg='["valueMissing:Please enter a valid price"]' required/>
					</div>
					<!--- <p class="helper error-message" x-cloak x-show="$store.offer.priceStated.errorMessage && $store.offer.priceStated.blurred" x-text="$store.offer.priceStated.errorMessage" class="error-message"></p> --->
				</div>
				<div>=</div>
				<div class="total" x-text="$store.offer.total"></div>
			</div>
			<p class="helper error-message qty-msg" x-cloak x-show="$store.offer.qtyStated.errorMessage && $store.offer.qtyStated.blurred" x-text="$store.offer.qtyStated.errorMessage" ></p>
			<p class="helper error-message price-msg" x-cloak x-show="$store.offer.priceStated.errorMessage && $store.offer.priceStated.blurred" x-text="$store.offer.priceStated.errorMessage" class="error-message"></p>
		</div>
		<div class="form-row">
			<label for="terms" class="form-label">
				Qualifications or Contingencies
			</label>
			<!--- @blur="$store.offer.terms = stripHTML($store.offer.terms);"  --->
			<textarea cols="50" rows="3" name="terms" id="terms" wrap="soft" class="form-control"  @blur="$store.offer.validateTerms()"  x-model="$store.offer.terms" maxlength="250" ></textarea>
			<p class="count" x-cloak>
				 <span x-text="$store.offer.termsRemain"></span> characters remaining.
			</p>
		</div>
		<div class="form-row">
			<label for="message" class="form-label">
				Additional Notes
			</label>
			<!---  @blur="$store.offer.message = stripHTML($store.offer.message);"  --->
			<textarea cols="50" rows="3" name="message" id="message" wrap="soft" class="form-control" @blur="$store.offer.validateMessage()" x-model="$store.offer.message" maxlength="250"></textarea>
			<p class="count" x-cloak>
				<span x-text="$store.offer.messageRemain"></span> characters remaining.
		   </p>
		</div>
		<div class="form-row">
			<label for="firstName" class="form-label">
				First Name <span>*</span>
			</label>
			<input name="firstName" id="firstName" type="text" class="form-control" :class="{'invalid':$store.offer.firstName.errorMessage && $store.offer.firstName.blurred}"  placeholder="John" maxlength="25" required  @blur="$store.offer.validate($event)"/>
			<p class="helper error-message" x-cloak x-show="$store.offer.firstName.errorMessage && $store.offer.firstName.blurred" x-text="$store.offer.firstName.errorMessage" ></p>
		</div>
		<div class="form-row">
			<label for="lastName" class="form-label">
				Last Name <span>*</span>
			</label>
			<input name="lastName" id="lastName"  type="text" class="form-control" :class="{'invalid':$store.offer.lastName.errorMessage && $store.offer.lastName.blurred}" placeholder="Doe"  maxlength="25" required @blur="$store.offer.validate($event)"  />
			<p class="helper error-message" x-cloak x-show="$store.offer.lastName.errorMessage && $store.offer.lastName.blurred" x-text="$store.offer.lastName.errorMessage" class="error-message"></p>
		</div>
		<div class="form-row">
			<label for="email" class="form-label">
				Email <span>*</span>
			</label>
			<div class="input-group">
				<span class="input-group-icon">
					<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
						<path fill-rule="evenodd" d="M14.243 5.757a6 6 0 10-.986 9.284 1 1 0 111.087 1.678A8 8 0 1118 10a3 3 0 01-4.8 2.401A4 4 0 1114 10a1 1 0 102 0c0-1.537-.586-3.07-1.757-4.243zM12 10a2 2 0 10-4 0 2 2 0 004 0z" clip-rule="evenodd" />
					</svg>
				</span>
				<input name="email" id="email" type="email" class="form-control input-group-ele-svg" :class="{'invalid':$store.offer.email.errorMessage && $store.offer.email.blurred}" placeholder="example@email.com"  maxlength="50" required @blur="$store.offer.validate($event)"/>
			</div>
			<p class="helper error-message" x-cloak x-show="$store.offer.email.errorMessage && $store.offer.email.blurred" x-text="$store.offer.email.errorMessage" class="error-message"></p>
		</div>
		<div class="form-row">
			<label for="company" class="form-label">
				Company
			</label>
			<input name="company" id="company" type="text" class="form-control"  placeholder="Google, Inc"  maxlength="50" />
		</div>
		<div class="form-row ">
			<label for="phone1" class="form-label">
				Phone <span>*</span>
			</label>
			<!--- <div class="input-group">
				<span class="input-group-icon">
					<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
						<path d="M2 3a1 1 0 011-1h2.153a1 1 0 01.986.836l.74 4.435a1 1 0 01-.54 1.06l-1.548.773a11.037 11.037 0 006.105 6.105l.774-1.548a1 1 0 011.059-.54l4.435.74a1 1 0 01.836.986V17a1 1 0 01-1 1h-2C7.82 18 2 12.18 2 5V3z" />
					  </svg>
				</span>
				<!--- data-msg='["patternMismatch:Phone number is invalid"]' 
				  placeholder="(999) 999-9999"  pattern="\+?[0-9-\s\.\+()]{5,25}"
				--->
	
			</div> --->
			<input name="phone1" id="phone1" type="tel" class="form-control input-group-ele-svg" :class="{'invalid':$store.offer.phone1.errorMessage && $store.offer.phone1.blurred}" maxlength="25" required oninput="this.value=validTelNumber(this.value)" @blur="$store.offer.validate($event)"   />
			<p class="helper error-message" x-cloak x-show="$store.offer.phone1.errorMessage && $store.offer.phone1.blurred" x-text="$store.offer.phone1.errorMessage" class="error-message"></p>
		</div>
		
		<div class="helper success-message" x-cloak x-show="$store.offer.submitted">
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
		</div>

		<div class="form-row">
			<button type="submit" class="btn btn-red " :class="{'submitting' :$store.offer.submitting}" :disabled="$store.offer.submitting">
				<svg x-show="$store.offer.submitting" class="animate-spin processing"  xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
						<circle style="opacity: .25"  cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
						<path style="opacity: .75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
				</svg>MAKE OFFER
			</button>
		</div>

	  </form>

</div>