<!--- <cfparam name="local.phone" default="phone1"> --->
<cfparam name="local.mode" default="new">
<cfparam name="local.store" default="">

<cfif !len(local.store)>
    <p>STORE NOT SET</p>
    <cfabort>
</cfif>

<cfoutput>
<!--- don't show form fields on inquiry and offer screens when logged in --->
<cfif  local.mode eq 'edit' or not rc.userSession.isLoggedIn >
    <div class="form-row"  x-id="['firstname']">
        <label :for="$id('firstname')" class="form-label">
            First Name <span>*</span>
        </label>
      
        <input 
            name="firstName" 
            type="text" 
            class="form-control" 
            placeholder="John" 
            maxlength="20"
            title="enter your first name"
            <!--- optional --->
            required
            data-msg='["valueMissing:Please enter your first name"]'
            oninput="this.value=stripInvalidChars(this.value);"
            
            <!--- alpine --->
            :id="$id('firstname')"
            :class="{'invalid':$store.#local.store#.toggleError('firstName')}"  
            x-model="$store.#local.store#.firstName.value" 
            @blur="$store.#local.store#.validate($event)" 
            @focus="$store.#local.store#.generalError=''"
            />
        <p 
            class="helper error-message" 
            x-cloak 
            x-show="$store.#local.store#.toggleError('firstName')" 
            x-text="$store.#local.store#.firstName.errorMessage" >
        </p>
    </div>
    <div class="form-row" x-id="['lastname']">
        <label :for="$id('lastname')"  class="form-label">
            Last Name <span>*</span>
        </label>
        <input 
            name="lastName" 
            type="text" 
            class="form-control" 
            placeholder="Doe"
            maxlength="30"
            title="enter your last name"
            <!--- optional --->
            required
            data-msg='["valueMissing:Please enter your last name"]'
            oninput="this.value=stripInvalidChars(this.value);"
            <!--- alpine --->
            :id="$id('lastname')"
            :class="{'invalid':$store.#local.store#.toggleError('lastName')}" 
            x-model="$store.#local.store#.lastName.value"
            @blur="$store.#local.store#.validate($event)" 
            @focus="$store.#local.store#.generalError=''"
            />
        <p 
            class="helper error-message" 
            x-cloak 
            x-show="$store.#local.store#.toggleError('lastName')" 
            x-text="$store.#local.store#.lastName.errorMessage">
        </p>
    </div>
    <div class="form-row" x-id="['email']">
        <label :for="$id('email')" class="form-label">
            Email <span>*</span>
        </label>
        <div class="input-group">
            <span class="input-group-icon">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                    <path fill-rule="evenodd" d="M14.243 5.757a6 6 0 10-.986 9.284 1 1 0 111.087 1.678A8 8 0 1118 10a3 3 0 01-4.8 2.401A4 4 0 1114 10a1 1 0 102 0c0-1.537-.586-3.07-1.757-4.243zM12 10a2 2 0 10-4 0 2 2 0 004 0z" clip-rule="evenodd" />
                </svg>
            </span>
            <input 
                name="email" 
                type="email" 
                class="form-control input-group-ele-svg" 
                maxlength="50"
                placeholder="example@email.com"  
                title="enter your email address"
                <!--- optional --->
                required
                data-msg='["valueMissing:Please enter your email"]'
                <!--- alpine --->
                :id="$id('email')"
                :class="{'invalid':$store.#local.store#.toggleError('email')}" 
                x-model="$store.#local.store#.email.value"
                @blur="$store.#local.store#.validate($event)"
                @focus="$store.#local.store#.generalError=''"
                />
        </div>
        <p 
            class="helper error-message" 
            x-cloak 
            x-show="$store.#local.store#.toggleError('email')" 
            x-text="$store.#local.store#.email.errorMessage">
        </p>
    </div>
    <div class="form-row" x-id="['coname']">
        <label :for="$id('coname')" class="form-label">
            Company
        </label>
        <input 
            name="coname" 
            type="text" 
            class="form-control" 
            placeholder="Google, Inc"
            maxlength="50"
            title="enter your optional company name"
            <!--- alpine --->
            :id="$id('coname')"
            x-model="$store.#local.store#.coname.value" 
            @blur="$store.#local.store#.validate($event)" 
            @focus="$store.#local.store#.generalError=''"/>
    </div>
    <div class="form-row"  x-id="['phone']">
        <label :for="$id('phone')" class="form-label">
            Phone <span>*</span>
        </label>
        <input      
            name="phone" 
            type="tel" 
            class="form-control input-group-ele-svg" 
            maxlength="28"
            placeholder="(555) 555-5555"
            title="enter a valid phone number"
            <!--- optional --->
            required 
            data-msg='["valueMissing:Please enter a valid phone number"]'
            data-id=''
            oninput="this.value=validTelNumber(this.value)"
            autocomplete="tel"
            <!--- alpine --->
            x-init="$store.#local.store#.phoneHandler = window.iti($id('phone'))"
            :id="$id('phone')"
            :class="{'invalid':$store.#local.store#.toggleError('phone')}" 
            x-model="$store.#local.store#.phone.value" 
            @blur="$store.#local.store#.validate($event)" 
            @focus="$store.#local.store#.generalError=''"/>
        <p 
            class="helper error-message"
            x-cloak 
            x-show="$store.#local.store#.toggleError('phone')" 
            x-text="$store.#local.store#.phone.errorMessage">
        </p>
    </div>

<cfelse>
        <input type="hidden" name="email" value="#rc.userSession.email#">
    </cfif>    
    
</cfoutput>


