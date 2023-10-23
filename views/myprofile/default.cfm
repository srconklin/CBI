<div id="myprofile">
<div class="container">
	<div class="panel box-shadow2 mt-8">

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
					<form 
						id="updatecontactinfofrm"
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
						#view( 'common/fragment/item/personal', {store='updatecontactinfo',mode='edit'})#
						</cfoutput>
						
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
					
				</div>
				<!----------------------------------- 
					change password
				 ----------------------------------->
				<div class="fadein" x-show="$store.tabs.openTab === 2">
					<cfoutput>
			            <form 
						id="changepasswordfrm"
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
										autocomplete="new-password"
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
                            #view( 'common/fragment/item/pwd', {label = 'New Password', store='changepassword'})#
						</cfoutput>
						
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

					</form>				 
				</div>
                <!----------------------------------- 
					My Address
				 ----------------------------------->
				<div class="fadein" x-show="$store.tabs.openTab === 3">
                     <cfoutput>
                       
                        <!--- <div class="center-w-flex mt-8">
                        <div style="max-width:1024px;width:100%"> --->
                                <form 
                                id="myaddressfrm"
                                action="/myaddress" 
                                method="post" 
                                autocomplete="off"
                                x-data 
                                x-init="
                                $store.myaddress.address1.value = '#rc.myaddress.street1#';
                                $store.myaddress.address2.value = '#rc.myaddress.street2#';
                                $store.myaddress.postalcode.value = '#rc.myaddress.postalcode#';
                                " 
                                @submit.prevent="$store.forms.submit('myaddress')">

                                                              
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
                                                    :class="{'invalid':$store.myaddress.toggleError('address1')}"  
                                                    x-model="$store.myaddress.address1.value" 
                                                    @blur="$store.myaddress.validate($event)" 
                                                    @focus="$store.myaddress.generalError=''"
                                                >
                                               <p 
                                                    class="helper error-message" 
                                                    x-cloak 
                                                    x-show="$store.myaddress.toggleError('address1')" 
                                                    x-text="$store.myaddress.address1.errorMessage" >
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
                                                    :class="{'invalid':$store.myaddress.toggleError('address2')}"  
                                                    x-model="$store.myaddress.address2.value" 
                                                    @blur="$store.myaddress.validate($event)" 
                                                    @focus="$store.myaddress.generalError=''"
                                                />
                                                <p 
                                                    class="helper error-message" 
                                                    x-cloak 
                                                    x-show="$store.myaddress.toggleError('address2')" 
                                                    x-text="$store.myaddress.address2.errorMessage" >
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
                                                    :class="{'invalid':$store.myaddress.toggleError('postalcode')}"  
                                                    x-model="$store.myaddress.postalcode.value" 
                                                    @blur="$store.myaddress.validate($event)" 
                                                    @focus="$store.myaddress.generalError=''"
                                                 
                                                >
                                                <p 
                                                    class="helper error-message" 
                                                    x-cloak 
                                                    x-show="$store.myaddress.toggleError('postalcode')" 
                                                    x-text="$store.myaddress.postalcode.errorMessage" >
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
                                            >
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
                                        x-show="$store.myaddress.generalError">
                                            <p 
                                                class="helper error-message" 
                                                x-html="$store.myaddress.generalError">
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
                      
                    </cfoutput>
				</div>
				<div class="fadein" x-show="$store.tabs.openTab === 4">
					<div class="shipping">
						<h2>Shipping & Handling</h2>
						<p>
							Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
						</p>
						
					</div>
					<div class="payment">
						<h2>Payment</h2>
						<p>
							Minimum order of $50 required.
							We offer terms of net 30 days to all companies that have established credit with Capovani Brothers Inc. and have paid within terms.
							All federal, state, local governments and their agencies, as well as institutions of higher learning automatically receive terms.
							All other sales, including foreign sales, are prepayment only.
							MasterCard, VISA, Discover and AMEX are accepted at sellers discretion.

						</p>

				</div>
			</div>
		</div>
	</div>
</div>
</div>

<!--- &callback=initService --->

<!--- <script defer 
    src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDkEDHzr6YLw-24a07THqMOFF5t0UGgDqk&libraries=places&language=en">
</script>  --->

<!--- <script>
    (g=>{var h,a,k,p="The Google Maps JavaScript API",c="google",l="importLibrary",q="__ib__",m=document,b=window;b=b[c]||(b[c]={});var d=b.maps||(b.maps={}),r=new Set,e=new URLSearchParams,u=()=>h||(h=new Promise(async(f,n)=>{await (a=m.createElement("script"));e.set("libraries",[...r]+"");for(k in g)e.set(k.replace(/[A-Z]/g,t=>"_"+t[0].toLowerCase()),g[k]);e.set("callback",c+".maps."+q);a.src=`https://maps.${c}apis.com/maps/api/js?`+e;d[q]=f;a.onerror=()=>h=n(Error(p+" could not load."));a.nonce=m.querySelector("script[nonce]")?.nonce||"";m.head.append(a)}));d[l]?console.warn(p+" only loads once. Ignoring:",g):d[l]=(f,...n)=>r.add(f)&&u().then(()=>d[l](f,...n))})({
      key: "AIzaSyDkEDHzr6YLw-24a07THqMOFF5t0UGgDqk",
      v: "weekly",
      language: "en"
      // Use the 'v' parameter to indicate the version to use (weekly, beta, alpha, etc.).
      // Add other bootstrap parameters as needed, using camel case.
    });
  </script> --->
 <script  src="/dist/aac-GESJCR6K.js" type="module"></script>

 <cfif len(rc.myaddress.LocGID)>

    <script>
        document.getElementById("location-panel").style.display = 'block';
    </script>

 </cfif>