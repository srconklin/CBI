<cfoutput>
    <label for="#local.phone#" class="form-label">
        Phone <span>*</span>
    </label>
    <input name="#local.phone#" id="#local.phone#" type="tel" class="form-control input-group-ele-svg" :class="{'invalid':$store.forms.#local.phone#.errorMessage && $store.forms.#local.phone#.blurred}" maxlength="25" required oninput="this.value=validTelNumber(this.value)" @blur="$store.forms.validate($event)" />
    <p class="helper error-message" x-cloak x-show="$store.forms.#local.phone#.errorMessage && $store.forms.#local.phone#.blurred" x-text="$store.forms.#local.phone#.errorMessage" class="error-message"></p>
</cfoutput>