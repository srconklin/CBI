<cfoutput>
    <label for="#local.phone#" class="form-label">
        Phone <span>*</span>
    </label>
    <input 
        id="#local.phone#" 
        name="#local.phone#" 
        <!--- value="#local.value#"  --->
        type="tel" 
        class="form-control input-group-ele-svg" 
        maxlength="28"
        placeholder="(555) 555-5555"
        title="enter a valid phone number"
        <!--- optional --->
        required 
        data-msg='["valueMissing:Please enter a valid phone number"]'
        oninput="this.value=validTelNumber(this.value)"
        autocomplete="tel"
        <!--- alpine --->
        :class="{'invalid':$store.forms.toggleError('#local.phone#')}" 
        x-model="$store.forms.#local.phone#.value" 
        @blur="$store.forms.validate($event)" />
    <p 
        class="helper error-message"
        x-cloak 
        x-show="$store.forms.toggleError('#local.phone#')" 
        x-text="$store.forms.#local.phone#.errorMessage">
    </p>
</cfoutput>