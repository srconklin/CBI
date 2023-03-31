<cfsavecontent variable="init"><cfoutput>
	$store.forms.firstName.value = '#rc.user.firstName#';
	$store.forms.lastName.value = '#rc.user.lastName#';
	$store.forms.email.value = '#rc.user.email#';
	$store.forms.coname = '#rc.user.coname#';
	$store.forms.phone1.value = '#rc.user.phone1#'; 
</cfoutput></cfsavecontent>

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

			<div class="tabcontent">
				<div class="tabelement" x-show="$store.tabs.openTab === 1" >
					<cfoutput>
					<form 
						id="updatecontactinfofrm"
						action="/updatecontactinfo" 
						method="post" 
						x-data 
						x-init="#init#" 
						@submit.prevent="$store.forms.form='updatecontactinfo';$store.forms.submit()">

						<input 
							type="hidden"		
							name="pno"
							value="#rc.user.pno#">
						<input 
							type="hidden"		
							name="pwd1"
							value="">

						
						#view( 'common/fragment/item/personal', {phone = 'phone1', mode='edit'})#
						</cfoutput>
						
						<div
						class="form-row" 
						x-cloak 
						x-show="$store.forms.generalError">
							<p 
								class="helper error-message-box error-message" 
								x-html="$store.forms.generalError">
							</p>
						</div>

						<div class="form-row">
							<button 
								id="updatecontactinfo"
								name="updatecontactinfo"
								type="submit" 
								class="btn btn-red login-submit" 
								title="save changes"
								<!--- alpine --->
								:class="{'submitting' :$store.forms.submitting}" 
								:disabled="$store.forms.submitting">
								<svg x-show="$store.forms.submitting" class="animate-spin processing"  xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
										<circle style="opacity: .25"  cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
										<path style="opacity: .75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
								</svg>Save Changes
							</button>
						</div>

					</form>	
					
				</div>
				<div class="tabelement" x-show="$store.tabs.openTab === 2">
			
						Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
				</div>
				<div class="tabelement" x-show="$store.tabs.openTab === 3">
						Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
				</div>
				<div class="tabelement" x-show="$store.tabs.openTab === 4">
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
