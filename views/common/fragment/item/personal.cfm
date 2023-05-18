<cfparam name="local.phone" default="phone1">
<cfparam name="local.mode" default="new">

<!--- don't show form fields on inquiry and offer screens when logged in --->
<cfif  local.mode eq 'edit' or not rc.userSession.isLoggedIn >
    <div class="form-row">
        <label for="firstName" class="form-label">
            First Name <span>*</span>
        </label>
      
        <input 
            id="firstName" 
            name="firstName" 
            type="text" 
            class="form-control" 
            placeholder="John" 
            maxlength="20"
            title="enter your first name"
            <!--- optional --->
            required
            data-msg='["valueMissing:Please enter your first name"]'
            oninput="this.value=validInput(this.value);"
            
            <!--- alpine --->
            :class="{'invalid':$store.forms.toggleError('firstName')}"  
            x-model="$store.forms.firstName.value" 
            @blur="$store.forms.validate($event)" 
            @focus="$store.forms.generalError=''"
            />
        <p 
            class="helper error-message" 
            x-cloak 
            x-show="$store.forms.toggleError('firstName')" 
            x-text="$store.forms.firstName.errorMessage" >
        </p>
    </div>
    <div class="form-row">
        <label for="lastName" class="form-label">
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
            oninput="this.value=validInput(this.value);"
            <!--- alpine --->
            :class="{'invalid':$store.forms.toggleError('lastName')}" 
            x-model="$store.forms.lastName.value"
            @blur="$store.forms.validate($event)" 
            @focus="$store.forms.generalError=''"
            />
        <p 
            class="helper error-message" 
            x-cloak 
            x-show="$store.forms.toggleError('lastName')" 
            x-text="$store.forms.lastName.errorMessage">
        </p>
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
                :class="{'invalid':$store.forms.toggleError('email')}" 
                x-model="$store.forms.email.value"
                @blur="$store.forms.validate($event)"
                @focus="$store.forms.generalError=''"
                />
        </div>
        <p 
            class="helper error-message" 
            x-cloak 
            x-show="$store.forms.toggleError('email')" 
            x-text="$store.forms.email.errorMessage">
        </p>
    </div>
    <div class="form-row">
        <label for="coname" class="form-label">
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
            x-model="$store.forms.coname" 
            @blur="$store.forms.validateConame()" 
            @focus="$store.forms.generalError=''"/>
    </div>
    <div class="form-row ">
        <cfoutput>
			#view( 'common/fragment/item/phone',  {phone = local.phone })#
		</cfoutput>
    </div>
<cfelse>
    <cfoutput>
        <input type="hidden" name="email" value="#rc.userSession.email#">
    </cfoutput>
</cfif>    



