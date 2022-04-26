
<cfif not structKeyExists(session, 'auth') or not session.auth.isLoggedIn >
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
        <label for="coname" class="form-label">
            Company
        </label>
        <input name="coname" id="coname" type="text" class="form-control"  placeholder="Google, Inc"  maxlength="50" />
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

<cfelse>
    <cfoutput>
        <input type="hidden" name="FirstName" value="#session.auth.user.firstname#">
        <input type="hidden" name="LastName" value="#session.auth.user.lastname#">
        <input type="hidden" name="email" value="#session.auth.user.email#">
        <input type="hidden" name="coname" value="#session.auth.user.coname#">
        <input type="hidden" name="phone1" value="#session.auth.user.phone1#">
        
    </cfoutput>
</cfif>    



