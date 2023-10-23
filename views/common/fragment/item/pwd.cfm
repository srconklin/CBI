<cfparam name="local.label" default="Password">
<cfparam name="local.store" default="">

<cfif !len(local.store)>
    <p>STORE NOT SET</p>
    <cfabort>
</cfif>


<cfoutput>
<div class="form-row">
    <label for="pwd1" class="form-label">
        #local.label# <span>*</span>
    </label>
    <input  id="pwd1" 
            name="pwd1" 
            type="password" 
            class="form-control" 
            maxlength="25"
            placeholder="password"
            title="Must contain at least one number, one uppercase and lowercase letter, and at least 8 or more characters"
            <!--- optional --->
            required
            <!--- pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}"  --->
            <!--- style="min-width: 350px;"  --->
            data-msg='["valueMissing:Please enter a new password]'
            autocomplete="new-password"
            <!--- alpine --->
            :class="{'invalid':$store.#local.store#.toggleError('pwd1')}"  
            @blur="$store.#local.store#.validate($event)" 
            @keyup="$store.#local.store#.pwdtests($event)" 
            @focus="$store.#local.store#.generalError=''"
            x-model="$store.#local.store#.pwd1.value"
            />
            <p class="helper error-message" 
                x-cloak 
                x-show="$store.#local.store#.toggleError('pwd1')" 
                x-text="$store.#local.store#.pwd1.errorMessage" >
            </p>
</div>    

<div class="form-row">
        <div class="pwdrequirements">
            <p 
                id="upper" 
                :class="$store.#local.store#.upper ? 'success-message' : 'error-message'">
                <svg x-show="!$store.#local.store#.upper" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M9.75 9.75l4.5 4.5m0-4.5l-4.5 4.5M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
                <svg x-show="$store.#local.store#.upper" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M9 12.75L11.25 15 15 9.75M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
                <span>Contains at least one <b>capital</b> letter</span>
            </p>
            <p 
                id="lower" 
                :class="$store.#local.store#.lower ? 'success-message' : 'error-message'" >
                <svg x-show="!$store.#local.store#.lower" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M9.75 9.75l4.5 4.5m0-4.5l-4.5 4.5M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
                <svg x-show="$store.#local.store#.lower" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M9 12.75L11.25 15 15 9.75M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
                 <span>Contains at least one <b>lowercase</b> character</span>
            </p>
            <p 
                id="number" 
                :class="$store.#local.store#.number ? 'success-message' : 'error-message'" >
                <svg x-show="!$store.#local.store#.number" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M9.75 9.75l4.5 4.5m0-4.5l-4.5 4.5M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
                <svg x-show="$store.#local.store#.number" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M9 12.75L11.25 15 15 9.75M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
                <span>Contains at least one <b>number</b></span>
            </p>
            <p 
                id="minlength" 
                :class="$store.#local.store#.minlength ? 'success-message' : 'error-message'">
                <svg x-show="!$store.#local.store#.minlength" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M9.75 9.75l4.5 4.5m0-4.5l-4.5 4.5M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
                <svg x-show="$store.#local.store#.minlength" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M9 12.75L11.25 15 15 9.75M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
                <span>Has a minimum of <b>8 characters</b></span>
            </p>
      </div>
</div>
<div class="form-row">
    <label for="pwd2" class="form-label">
        Confirm Password <span>*</span>
    </label>
    <input  id="pwd2" 
            name="pwd2" 
            type="password" 
            class="form-control" 
            maxlength="25"
            placeholder="password"
            title="Must contain at least one number and one uppercase and lowercase letter, and at least 8 or more characters"
            <!--- optional --->
            required
            <!--- pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}"  --->
            <!--- style="min-width: 350px;"  --->
            data-msg='["valueMissing:Please confirm your pasword", "mustMatch:Passwords must match"]'
            autocomplete="new-password"
            <!--- alpine --->
            :class="{'invalid':$store.#local.store#.toggleError('pwd2')}"  
            @blur="$store.#local.store#.validate($event)" 
            @keyup="$store.#local.store#.validate($event)"
            @focus="$store.#local.store#.generalError=''"
            x-model="$store.#local.store#.pwd2.value"
            />
            <p class="helper error-message" 
                x-cloak 
                x-show="$store.#local.store#.toggleError('pwd2')" 
                x-text="$store.#local.store#.pwd2.errorMessage" >
            </p>

</div>  
</cfoutput>