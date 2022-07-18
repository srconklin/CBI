<cfparam name="phoneid" default="phone1">
<cfif not rc.userSession.isLoggedIn >
    <div class="form-row">
        <label for="firstName" class="form-label">
            First Name <span>*</span>
        </label>
        <input name="firstName"  type="text" class="form-control" :class="{'invalid':$store.forms.firstName.errorMessage && $store.forms.firstName.blurred}"  placeholder="John" maxlength="20" required  @blur="$store.forms.validate($event)" oninput="this.value=validInput(this.value);" x-model="$store.forms.firstName.value" />
        <p class="helper error-message" x-cloak x-show="$store.forms.firstName.errorMessage && $store.forms.firstName.blurred" x-text="$store.forms.firstName.errorMessage" ></p>
    </div>
    <div class="form-row">
        <label for="lastName" class="form-label">
            Last Name <span>*</span>
        </label>
        <input name="lastName"   type="text" class="form-control" :class="{'invalid':$store.forms.lastName.errorMessage && $store.forms.lastName.blurred}" placeholder="Doe"  maxlength="30" required @blur="$store.forms.validate($event)" oninput="this.value=validInput(this.value);" x-model="$store.forms.lastName.value" />
        <p class="helper error-message" x-cloak x-show="$store.forms.lastName.errorMessage && $store.forms.lastName.blurred" x-text="$store.forms.lastName.errorMessage" class="error-message"></p>
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
            <input name="email"  type="email" class="form-control input-group-ele-svg" :class="{'invalid':$store.forms.email.errorMessage && $store.forms.email.blurred}" placeholder="example@email.com"  maxlength="50" required @blur="$store.forms.validate($event)"/>
        </div>
        <p class="helper error-message" x-cloak x-show="$store.forms.email.errorMessage && $store.forms.email.blurred" x-text="$store.forms.email.errorMessage" class="error-message"></p>
    </div>
    <div class="form-row">
        <label for="coname" class="form-label">
            Company
        </label>
        <input name="coname"  type="text" class="form-control" @blur="$store.forms.validateConame()"  placeholder="Google, Inc"  maxlength="50" x-model="$store.forms.coname" />
        <!--- <p class="helper error-message" x-cloak x-show="$store.forms.coname.errorMessage && $store.forms.coname.blurred" x-text="$store.forms.coname.errorMessage" class="error-message"></p> --->
    </div>
    <div class="form-row ">
       
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
        <cfoutput>
			#view( 'common/fragment/item/phone',  {phone = local.phone})#
		</cfoutput>

    </div>

<cfelse>
    <cfoutput>
        <input type="hidden" name="email" value="#rc.userSession.email#">
    </cfoutput>
</cfif>    



