<div id="myprofile">

    <!--- <h2>My Profile</h2> --->
    <section class="center-w-flex mt-4">
        <div class="lead-container">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" >
                <path stroke-linecap="round" stroke-linejoin="round" d="M16.862 4.487l1.687-1.688a1.875 1.875 0 112.652 2.652L10.582 16.07a4.5 4.5 0 01-1.897 1.13L6 18l.8-2.685a4.5 4.5 0 011.13-1.897l8.932-8.931zm0 0L19.5 7.125M18 14v4.75A2.25 2.25 0 0115.75 21H5.25A2.25 2.25 0 013 18.75V8.25A2.25 2.25 0 015.25 6H10" />
              </svg>
            <h1 class="lead-title">My Profile</h1>
        </div>
        
        <div class="instruction instruction-enhanced">
            Manage your account details, update your contact info, adjust notifications, and keep your address current.
        </div>

        <cfoutput>
            <div class="mb-4">
                <!--- <p>#rc.userSession.email#</p>  color:##2f855a;" --->
                <cfif rc.userSession.isEmailVerified>
                    <div class="message-box success"> 
                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor"  style="color:##2f855a; width:1.5rem; height: 1.5rem;">
                             <path fill-rule="evenodd" d="M8.603 3.799A4.49 4.49 0 0 1 12 2.25c1.357 0 2.573.6 3.397 1.549a4.49 4.49 0 0 1 3.498 1.307 4.491 4.491 0 0 1 1.307 3.497A4.49 4.49 0 0 1 21.75 12a4.49 4.49 0 0 1-1.549 3.397 4.491 4.491 0 0 1-1.307 3.497 4.491 4.491 0 0 1-3.497 1.307A4.49 4.49 0 0 1 12 21.75a4.49 4.49 0 0 1-3.397-1.549 4.49 4.49 0 0 1-3.498-1.306 4.491 4.491 0 0 1-1.307-3.498A4.49 4.49 0 0 1 2.25 12c0-1.357.6-2.573 1.549-3.397a4.49 4.49 0 0 1 1.307-3.497 4.49 4.49 0 0 1 3.497-1.307Zm7.007 6.387a.75.75 0 1 0-1.22-.872l-3.236 4.53L9.53 12.22a.75.75 0 0 0-1.06 1.06l2.25 2.25a.75.75 0 0 0 1.14-.094l3.75-5.25Z" clip-rule="evenodd" />
                        </svg>
                        <span>
                            <b>#rc.userSession.email#</b>&nbsp;VERIFIED!
                        </span>
                    </div>
    
                <!--- <cfelse>
                    <div class="message-box error">
                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2.5" stroke="currentColor" style="color:##b91c1c;">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M18.364 18.364A9 9 0 005.636 5.636m12.728 12.728A9 9 0 015.636 5.636m12.728 12.728L5.636 5.636" />
                        </svg>
                        <span>
                            <b>#rc.userSession.email#</b> has been not verified yet!<br><a href="/resendlink">Send</a>&nbsp;an email to confirm your account now.
                        </span>
                        
                    </div> --->
                </cfif>
            </div> 

        </cfoutput>

    </section>

 <div class="container">


    <!--- <cfif (rc.userSession.validated eq 2)> --->
	<div class="panel" style="border-top: 1px solid #e5e5e5; border-radius:0">

		<div class="verttabs" x-data>
			<ul>
				<li :class="$store.tabs.showActiveTab(1);"   @click="$store.tabs.openTab = 1">
					<a :class="$store.tabs.showActiveButton(1);"  href="javascript:void(0);">Contact Infomation</a>
				</li>
				<li :class="$store.tabs.showActiveTab(2);"  @click="$store.tabs.openTab = 2">
					<a :class="$store.tabs.showActiveButton(2);"  href="javascript:void(0);">Change Password</a>
				</li>
				<li :class="$store.tabs.showActiveTab(3);"  @click="$store.tabs.openTab = 3">
					<a :class="$store.tabs.showActiveButton(3);"  href="javascript:void(0);">My Address</a>
				</li>
				<li :class="$store.tabs.showActiveTab(4);"  @click="$store.tabs.openTab = 4">
					<a :class="$store.tabs.showActiveButton(4);"  href="javascript:void(0);">Notifications</a>
				</li>
				
			</ul>

			<!----------------------------------- 
				Update contact information
			----------------------------------->
			<div class="tabcontent">
				<div class="fadein" x-show="$store.tabs.openTab === 1" >
					<cfoutput>
                    <cfif (rc.userSession.validated eq 2)>    
                        <form 
                            id="updatecontactinfofrm"
                            name="updatecontactinfofrm"
                            action="/updatecontactinfo" 
                            method="post" 
                            x-data 
                            x-init="
                                $store.updatecontactinfo.firstName.value = '#rc.user.firstName#';
                                $store.updatecontactinfo.lastName.value = '#rc.user.lastName#';
                                $store.updatecontactinfo.email.value = '#rc.user.email#';
                                $store.updatecontactinfo.coname.value = '#rc.user.coname#';
                                $store.updatecontactinfo.phone.value = '#rc.user.phone1#';
                            " 
                            @submit.prevent="$store.forms.submit('updatecontactinfo')">
                            #view( 'common/fragment/personal', {store='updatecontactinfo',mode='edit'})#
                            
                            
                            <div
                            class="form-row" 
                            x-cloak 
                            x-show="$store.updatecontactinfo.generalError">
                                <p 
                                    class="helper error-message-box error-message" 
                                    x-html="$store.updatecontactinfo.generalError">
                                </p>
                            </div>

                            <div class="form-row">
                                <button 
                                    id="updatecontactinfo"
                                    name="updatecontactinfo"
                                    type="submit" 
                                    class="btn btn-red" 
                                    title="save changes"
                                    <!--- alpine --->
                                    :class="{'submitting' :$store.forms.submitting}" 
                                    :disabled="$store.forms.submitting"
                                    >
                                    <svg x-show="$store.forms.submitting" class="animate-spin processing"  xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                                            <circle style="opacity: .25"  cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                                            <path style="opacity: .75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                                    </svg>Save Changes
                                </button>
                            </div>

                        </form>	
                    <cfelse>
                       #view( 'myprofile/unlocksettings')# 
                    </cfif>

				</cfoutput>

				</div>
				<!----------------------------------- 
					change password
				 ----------------------------------->
				<div class="fadein" x-show="$store.tabs.openTab === 2">
					<cfoutput>

                    <cfif (rc.userSession.validated eq 2)>    
			            <form 
						id="changepasswordfrm"
						name="changepasswordfrm"
						action="/changepassword" 
						method="post" 
						x-data 
                        @submit.prevent="$store.forms.submit('changepassword')">
                       
                        <input 
                            type="text" 
                            id="username"
                            name="username"
                            autocomplete="username" 
                           style="display:none"
                         >
					
							<div class="form-row">
								<label for="pwdcurrent" class="form-label">
									Current Password <span>*</span>
								</label>

								<input  id="pwdcurrent" 
										name="pwdcurrent" 
										type="password" 
										class="form-control" 
										maxlength="25"
										placeholder="password"
										title="Must contain at least one number, one uppercase and lowercase letter, and at least 8 or more characters"
										<!--- optional --->
										required
										<!--- pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}"  --->
										<!--- style="min-width: 350px;"  --->
										data-msg='["valueMissing:Please enter a new password"]'
										autocomplete="off"
										<!--- alpine --->
										:class="{'invalid':$store.changepassword.toggleError('pwdcurrent')}"  
										@blur="$store.changepassword.validate($event)" 
										@keyup="$store.changepassword.pwdtests($event)" 
										@focus="$store.changepassword.generalError=''"
										x-model="$store.changepassword.pwdcurrent.value"
										/>
										<p class="helper error-message" 
											x-cloak 
											x-show="$store.changepassword.toggleError('pwdcurrent')" 
											x-text="$store.changepassword.pwdcurrent.errorMessage" >
										</p>
							</div> 
                            #view( 'common/fragment/pwd', {label = 'New Password', store='changepassword'})#
					
						
						<div
						class="form-row" 
						x-cloak 
						x-show="$store.changepassword.generalError">
							<p 
								class="helper error-message-box error-message" 
								x-html="$store.changepassword.generalError">
							</p>
						</div>

						<div class="form-row">
							<button 
								id="changepassword"
								name="changepassword"
								type="submit" 
								class="btn btn-red" 
								title="Change Password"
								<!--- alpine --->
								:class="{'submitting' :$store.forms.submitting}" 
								:disabled="$store.forms.submitting"
								>
								<svg x-show="$store.forms.submitting" class="animate-spin processing"  xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
										<circle style="opacity: .25"  cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
										<path style="opacity: .75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
								</svg>Change Password
							</button>
						</div>

                    <cfelse>
                        #view( 'myprofile/unlocksettings')# 
                     </cfif>
					</form>	

                 </cfoutput>			 
				</div>
                <!----------------------------------- 
					My Address
				 ----------------------------------->
				<div class="fadein" x-show="$store.tabs.openTab === 3">
                     <cfoutput>

                        <cfif (rc.userSession.validated eq 2)>    
                        <!--- <div class="center-w-flex mt-8">
                        <div style="max-width:1024px;width:100%"> --->
                                <form 
                                id="updateaddressfrm"
                                name="updateaddressfrm"
                                action="/updateaddress" 
                                method="post" 
                                autocomplete="off"
                                x-data 
                                x-init="
                                $store.updateaddress.address1.value = '#rc.myaddress.street1#';
                                $store.updateaddress.address2.value = '#rc.myaddress.street2#';
                                $store.updateaddress.postalcode.value = '#rc.myaddress.postalcode#';
                                " 
                                @submit.prevent="$store.forms.submit('updateaddress')">

                                                              
                                <div class="flex flex-direction-column">
                                    <div class="flex-child">
                                            <div class="form-row">
                                                <label for="address1" class="form-label">
                                                Street Address
                                                </label>
                                                
                                                <input 
                                                    id="address1" 
                                                    name="address1" 
                                                    type="text" 
                                                    class="form-control" 
                                                    maxlength="50"
                                                    placeholder="Street or PO Box" 
                                                    title="Street or PO Box" 
                                                    
                                                    <!--- optional --->
                                                    required
                                                    data-msg='["valueMissing:Please enter your street address"]'
                                                    oninput="this.value=stripInvalidChars(this.value, 'ad');" 
                                                    
                                                    <!--- alpine --->
                                                    :class="{'invalid':$store.updateaddress.toggleError('address1')}"  
                                                    x-model="$store.updateaddress.address1.value" 
                                                    @blur="$store.updateaddress.validate($event)" 
                                                    @focus="$store.updateaddress.generalError=''"
                                                >
                                               <p 
                                                    class="helper error-message" 
                                                    x-cloak 
                                                    x-show="$store.updateaddress.toggleError('address1')" 
                                                    x-text="$store.updateaddress.address1.errorMessage" >
                                               </p>    
                                            </div>	
                                            <div class="form-row">
                                                <input 
                                                    id="address2" 
                                                    name="address2" 
                                                    type="text" 
                                                    class="form-control" 
                                                    placeholder="Apartment, unit, suite, or floor ##" 
                                                    title="Apartment, unit, suite, or floor ##" 
                                                    maxlength="50"
                                                    
                                                    <!--- optional --->
                                                    oninput="this.value=stripInvalidChars(this.value, 'ad');"
                                                    
                                                    <!--- alpine --->
                                                    :class="{'invalid':$store.updateaddress.toggleError('address2')}"  
                                                    x-model="$store.updateaddress.address2.value" 
                                                    @blur="$store.updateaddress.validate($event)" 
                                                    @focus="$store.updateaddress.generalError=''"
                                                />
                                                <p 
                                                    class="helper error-message" 
                                                    x-cloak 
                                                    x-show="$store.updateaddress.toggleError('address2')" 
                                                    x-text="$store.updateaddress.address2.errorMessage" >
                                                </p>    
                                                        
                                            </div>	

                                            <div class="form-row" >
                                                <label for="postalcode" class="form-label">
                                                    Postal Code
                                                </label>
                                                <input
                                                    id="postalcode" 
                                                    name="postalcode" 
                                                    type="text"
                                                    class="form-control" 
                                                    placeholder="Postal Code" 
                                                    title="Postal Code" 
                                                    maxlength="25"

                                                    <!--- optional --->
                                                    required
                                                    data-msg='["valueMissing:Please enter your postal code"]'
                                                    oninput="this.value=stripInvalidChars(this.value, 'pc');"
                                                    style="max-width:117px;"
                                                
                                                    <!--- alpine --->
                                                    :class="{'invalid':$store.updateaddress.toggleError('postalcode')}"  
                                                    x-model="$store.updateaddress.postalcode.value" 
                                                    @blur="$store.updateaddress.validate($event)" 
                                                    @focus="$store.updateaddress.generalError=''"
                                                 
                                                >
                                                <p 
                                                    class="helper error-message" 
                                                    x-cloak 
                                                    x-show="$store.updateaddress.toggleError('postalcode')" 
                                                    x-text="$store.updateaddress.postalcode.errorMessage" >
                                                 </p>    
                                            </div>	
                                          
                                            
                                        </div>
                                    <div class="flex-child">
                                        <div class="form-row">
                                            <label for="searchgeo" class="form-label">
                                                Type your c&##8204;ity to select your location<span>*</span>
                                                
                                            </label>
                                            <input
                                                id="searchgeo" 
                                                name="searchgeo" 
                                                type="text"
                                                value = ""
                                                class="form-control input-gray box-shadow2 " 
                                                placeholder="C&##8204;ity" 
                                                title="Type your c&##8204;ity to select your location " 
                                                autocomplete="off"
                                                autocorrect="off"
                                                autocapitalize="off"
                                                spellcheck="false"
                                                oninput="this.value=romanAlphaOnly(this.value);" 
                                            >
                                            <div class="note">Note: Only English or Latin-based language input is supported.</div>
                                        </div>	

                                        <!--- [CityTxt], [StateTxt], [CountryTxt], [LocGID], [StPGID], [CyGID] --->
                                        <div class="location-panel" id="location-panel">
                                            <div class="flex flex-direction-column" >
                                                <div class="form-row">
                                                    <label for="location" class="form-label">
                                                        City:
                                                    </label>
                                                    <div class="loc-value" id="locality">#rc.myaddress.cityTxt#</div>
                                                </div>	
                                                <div class="form-row">
                                                    <label for="stateprov" class="form-label">
                                                        State/Province:
                                                    </label>
                                                    <div class="loc-value" id="stateprov">#rc.myaddress.stateTxt#</div>
                                                </div>	

                                                <div class="form-row">
                                                    <label for="postalcode" class="form-label">
                                                        Country/Region:
                                                    </label>
                                                    <div class="loc-value" id="country">#rc.myaddress.countryTxt#</div>
                                                </div>	
                                            </div>
                                        </div>
                                 
                                        <div
                                        id="generalError"
                                        class="form-row" 
                                        x-cloak 
                                        x-show="$store.updateaddress.generalError">
                                            <p 
                                                class="helper error-message" 
                                                x-html="$store.updateaddress.generalError">
                                            </p>
                                        </div> 

                                    </div>
                                </div>
                               
                                <div class="form-row">
                                                 
                                    <button 
                                        id="savemyaddress"
                                        name="savemyaddress"
                                        type="submit" 
                                        class="btn btn-red" 
                                        title="Save Address"
                                        <!--- alpine --->
                                        :class="{'submitting' :$store.forms.submitting}" 
                                        :disabled="$store.forms.submitting"
                                        >
                                        <svg x-show="$store.forms.submitting" class="animate-spin processing"  xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                                                <circle style="opacity: .25"  cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                                                <path style="opacity: .75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                                        </svg>Save Address
                                     </button>
                                    
                                </div>	

                                <input
                                    type="hidden" 
                                    name="PLocGID" 
                                    id="PLocGID"
                                    value="#rc.myaddress.LocGID#"
                                    data-msg='["valueMissing:City not found"]' 
                                >
                                <input 
                                    type="hidden" 
                                    name="PStPGID" 
                                    id="PStPGID" 
                                    value="#rc.myaddress.StPGID#"
                                >
                                <input 
                                    type="hidden" 
                                    name="PCyGID" 
                                    id="PCyGID" 
                                    value="#rc.myaddress.cyGID#"
                                    data-msg='["valueMissing:Country not found]' 
                                >
                            </form>	 
                        <cfelse>
                            #view( 'myprofile/unlocksettings')# 
                         </cfif>

                    </cfoutput>
				</div>
				<div class="fadein" x-show="$store.tabs.openTab === 4">
						

                        <cfif (rc.userSession.validated eq 2)>    
                            <h2 class="mb-8">Communication Preferences</h2>
						<form 
						id="updateCommPreffrm"
						name="updateCommPreffrm"
						action="/updateCommPref" 
						method="post" 
						x-data 
                        @submit.prevent="$store.forms.submit('updateCommPref')">
                       
                        <div
                            id="generalError"
                            class="form-row" 
                            x-cloak 
                            x-show="$store.updateCommPref.generalError">
                                <p 
                                    class="helper error-message" 
                                    x-html="$store.updateCommPref.generalError">
                                </p>
                        </div> 

                        <div class="form-row checkbox-container">
                            <label for="bcast">
                                <input 
                                    id="bcast"
                                    name="bcast"
                                    type="checkbox" 
                                    class="checkbox" 
                                    value="1" 
                                    <cfif rc.user.bcast eq 1>checked</cfif>
                                    title="allow us to send you occasional email offers" 
                                    >
                                <span>Send me occasional email offers about new listings and featured items.
                            </label>
                        </div>	
                        <button 
                        id="updatecommprefs"
                        name="updatecommprefs"
                        type="submit" 
                        class="btn btn-red" 
                        title="Save Changes"
                        <!--- alpine --->
                        :class="{'submitting' :$store.forms.submitting}" 
                        :disabled="$store.forms.submitting"
                        >
                        <svg x-show="$store.forms.submitting" class="animate-spin processing"  xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                                <circle style="opacity: .25"  cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                                <path style="opacity: .75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                        </svg>Save Changes
                     </button>
                    
                    </form>

                <cfelse>
                   <cfoutput> #view( 'myprofile/unlocksettings')# </cfoutput>
                 </cfif>

			</div>
		</div>
	</div>
    
</div>
</div>

 <script  src="/dist/aac-EU2IF47H.js" type="module"></script>

 <cfif len(rc.myaddress.LocGID)>

    <script>
        document.getElementById("location-panel").style.display = 'block';
    </script>

 </cfif>