<!--- <div class="container">

	<div class="login-title">
		<h1>My Account</h1>
	</div>
	
</div> --->
<cfoutput>
    
	<div class="center-w-flex mt-8">
	<div style="max-width:1024px;width:100%">
		<form id="myForm" autocomplete="off" x-data >
            <div class="flex flex-direction-column">
                <div class="flex-child">
                        <div class="form-row">
                            <label for="qtyStated" class="form-label">
                                First Name <span>*</span>
                            </label>
                          
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
                                step="1" 
                                min="1" 
                                data-msg='["valueMissing:Please enter a valid quantity"]'
                                oninput="validity.valid||(value='');" 
                                <!--- alpine --->
                                <!--- :class="{'invalid':$store.offer.toggleError('qtyStated')}" 
                                :max="$store.offer.maxqty" 
                                :readonly="$store.offer.maxqty==1"   --->
                                x-model="$store.offers.qtyStated.value"
                                @blur="$store.offers.validate" 
                                />
                            <!--- <p 
                                class="helper error-message" 
                                x-cloak 
                                x-show="$store.forms.toggleError('qtyStated')" 
                                x-text="$store.forms.qtyStated.errorMessage" >
                            </p> --->
                        </div>	
                    </div>
                
                      </div>
            </div>
           
		</form>	
	</div>				
	</div>				

</cfoutput>
