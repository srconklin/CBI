<div class="offer">
<form id="offerfrm" action="/offer" method="post" x-data x-init="$store.offer.init()" @focusout="$store.offer.change($event)"  @input="$store.offer.change($event)"  @submit.prevent="$store.offer.submit()">
		<input type="hidden" name="itemno" :value="$store.offer.itemno">
		
		<div class="form-row">
			<label for="priceStated" class="form-label">
				My Offer <span>*</span>
			</label>
			
			<div class="offer-total-row">
				<div>
					<input name="qtystated" oninput="validity.valid||(value=1);" class="form-control qty-ele" type="number" placeholder="qty" step="1" min="1" :max="$store.offer.maxqty" maxlength="3" :disabled="$store.offer.maxqty==1" x-model="$store.offer.qtystated" required/>
				</div>

				<div style="padding: .2rem 0">@</div>
				
				<div>
					<div class="input-group">
						<span class="input-group-icon">
							<!--- <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
								<path d="M8.433 7.418c.155-.103.346-.196.567-.267v1.698a2.305 2.305 0 01-.567-.267C8.07 8.34 8 8.114 8 8c0-.114.07-.34.433-.582zM11 12.849v-1.698c.22.071.412.164.567.267.364.243.433.468.433.582 0 .114-.07.34-.433.582a2.305 2.305 0 01-.567.267z" />
								<path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm1-13a1 1 0 10-2 0v.092a4.535 4.535 0 00-1.676.662C6.602 6.234 6 7.009 6 8c0 .99.602 1.765 1.324 2.246.48.32 1.054.545 1.676.662v1.941c-.391-.127-.68-.317-.843-.504a1 1 0 10-1.51 1.31c.562.649 1.413 1.076 2.353 1.253V15a1 1 0 102 0v-.092a4.535 4.535 0 001.676-.662C13.398 13.766 14 12.991 14 12c0-.99-.602-1.765-1.324-2.246A4.535 4.535 0 0011 9.092V7.151c.391.127.68.317.843.504a1 1 0 101.511-1.31c-.563-.649-1.413-1.076-2.354-1.253V5z" clip-rule="evenodd" />
							</svg> --->
							$
							<!--- <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" class="feather feather-dollar-sign"><line x1="12" y1="1" x2="12" y2="23"></line><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"></path></svg> --->
						</span>
						<!--- @input="$store.offer.validatePrice()" @blur="$store.offer.validatePrice('blur')"  pattern="^\$\d{1,3}(,\d{3})*(\.\d+)?$"  @blur="$store.offer.validatePrice($event, 'blur')"  
						oninput="this.value=formatCurrency(this.value);"  @blur="$store.offer.validatePrice($event, 'blur')"
						--->
						<input name="pricestated" type="text" class="form-control input-group-ele currency-ele" :class="{'invalid':$store.offer.pricestated.errorMessage && $store.offer.pricestated.blurred}"  placeholder="999,999.00"  maxlength="10"  x-model="$store.offer.pricestated.value" required/>
					</div>
					<p class="helper error-message" x-cloak x-show="$store.offer.pricestated.errorMessage && $store.offer.pricestated.blurred" x-text="$store.offer.pricestated.errorMessage" class="error-message"></p>
				</div>
				<div>=</div>
				<div class="total" x-text="$store.offer.total"></div>
				<!--- <div class="total" x-text="$store.offer.thetotal"></div> --->
			</div>
		</div>
		<div class="form-row">
			<label for="terms" class="form-label">
				Qualifications or Contingencies
			</label>
			<!--- 
				 @blur="$store.offer.validate($event, 'blur')" data-rules='["stripHTML"]'
				onblur="this.value = stripHTML(this.value);"
		 --->
			<textarea cols="50" rows="3" name="terms" wrap="soft" class="form-control" x-model="$store.offer.terms.value" maxlength="250"  ></textarea>
			<p class="count" x-cloak>
				<span x-text="$store.offer.termsRemain"></span> characters remaining.
			</p>
		</div>
		<div class="form-row">
			<label for="message" class="form-label">
				Additional Notes
			</label>
			<!--- @blur="$store.offer.validateMessage()"  --->
			<textarea cols="50" rows="3" name="message" wrap="soft" class="form-control" onblur="this.value = stripHTML(this.value);" x-model="$store.offer.message.value" maxlength="250"></textarea>
			<p class="count" x-cloak>
				<span x-text="$store.offer.messageRemain"></span> characters remaining.
		   </p>
		</div>
		<div class="form-row">
			<label for="firstName" class="form-label">
				First Name <span>*</span>
			</label>
			<input name="firstName" type="text" class="form-control" :class="{'invalid':$store.offer.firstName.errorMessage && $store.offer.firstName.blurred}"  placeholder="John" maxlength="25" required  @blur="$store.offer.validate($event, 'blur')"/>
			<p class="helper error-message" x-cloak x-show="$store.offer.firstName.errorMessage && $store.offer.firstName.blurred" x-text="$store.offer.firstName.errorMessage" ></p>
		</div>
		<div class="form-row">
			<label for="lastName" class="form-label">
				Last Name <span>*</span>
			</label>
			<input name="lastName" type="text" class="form-control" :class="{'invalid':$store.offer.lastName.errorMessage && $store.offer.lastName.blurred}" placeholder="Doe"  maxlength="25" required @blur="$store.offer.validate($event, 'blur')"  />
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
				<input name="email" type="email" class="form-control input-group-ele-svg" :class="{'invalid':$store.offer.email.errorMessage && $store.offer.email.blurred}" placeholder="example@email.com"  maxlength="50" required @blur="$store.offer.validate($event, 'blur')"/>
			</div>
			<p class="helper error-message" x-cloak x-show="$store.offer.email.errorMessage && $store.offer.email.blurred" x-text="$store.offer.email.errorMessage" class="error-message"></p>
		</div>
		<div class="form-row">
			<label for="company" class="form-label">
				Company
			</label>
			<input name="company" type="text" class="form-control"  placeholder="Google, Inc"  maxlength="50" />
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
			<!--- x-model="$store.offer.phone1.value"  --->
			<input id="phone1" name="phone1" type="tel" class="form-control input-group-ele-svg" :class="{'invalid':$store.offer.phone1.errorMessage && $store.offer.phone1.blurred}" maxlength="25" required oninput="this.value=validTelNumber(this.value)" @blur="$store.offer.validatePhone($event, 'blur')"   />
			<p class="helper error-message" x-cloak x-show="$store.offer.phone1.errorMessage && $store.offer.phone1.blurred" x-text="$store.offer.phone1.errorMessage" class="error-message"></p>
		</div>

		<div class="form-row">
			<button type="submit" class="btn btn-red login-submit">SEND</button>
		</div>

		<!--- <button type="submit" class="btn btn-red">Make Offer</button> --->
	  </form>

</div>