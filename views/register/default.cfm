
<cfoutput>

	<!--- <div class="register"> --->
					
		<!-- flex centering -->
		<div class="center-w-flex mt-8">

		<cfif structKeyExists(rc, 'showregister')>

			<!------------------------ 
				create an account 
			------------------------->
			<!--- id="register-account" --->
			<div class="panel box-shadow2" style="max-width:1024px;">
						
				<div class="page-title">
					<h1>Create an Account</h1>
				</div>
						
				<p class="mb-8">
				Signing up for an account is free, quick and easy. Members can more quickly submit offers and inquiries.
				</p>
				
					<div>
						<form 
							id="registerfrm" 
							name="registerfrm"
							action="/register" 
							method="post" 
							autocomplete="off"
							novalidate
							x-data 
							@submit.prevent="$store.forms.form='register';$store.forms.submit(); ">
						
								
								<div class="flex flex-direction-column" style="gap: 3em;">
									<div class="flex-child" >
										<cfoutput>#view( 'common/fragment/item/personal', {phone = 'phone1'})#</cfoutput>
									</div>	
									
									<!--- personal fields --->
									<div class="flex-child" >
										<cfoutput>#view( 'common/fragment/item/pwd', {label = 'Password'})# </cfoutput>

										<div class="form-row checkbox-container">
											<label for="bcast" >
												<input 
													<!--- id="bcast" --->
													name="bcast"
													type="checkbox" 
													class="checkbox" 
													value="1" 
													title="allow us to send you occasional email offers" 
													>
												<span>Send me occasional email offers about new listings and featured items. <i>You may unsubscribe at any time.</i></span>
											</label>
										</div>	

									
										<div class="form-row checkbox-container">
											<label for="agreetandc" >
												<input 
													<!--- id="agreetandc" --->
													name="agreetandc"
													type="checkbox" 
													class="checkbox" 
													required
													data-msg='["valueMissing:you must agree to the terms and conditions"]'			
													title="you must agree to the terms and conditions" 
													<!--- alpine --->
													:class="{'invalid':$store.forms.toggleError('agreetandc')}" 
													x-model="$store.forms.agreetandc.value" >
												<span>I Agree to <a class="redlink" href="/terms">Terms of Service</a></span>
											</label>
											<p 
												class="helper error-message" 
												x-cloak 
												x-show="$store.forms.toggleError('agreetandc')" 
												x-text="$store.forms.agreetandc.errorMessage">
											</p>
										</div>
										
										<div 
											class="form-row" 
											x-cloak 
											x-show="$store.forms.generalError">
												<p 
													class="helper error-message-box error-message" 
													x-html="$store.forms.generalError">
												</p>
										</div>
									
									</div>		

								</div>

								<div class="form-row mt-6 center-w-flex">
									<button 
										id="register"
										name="register"
										<!--- type="submit"  --->
										class="btn btn-red btn-heavy" 
										title="create register profile"
										<!--- alpine --->
										:class="{'submitting' :$store.forms.submitting}" 
										:disabled="$store.forms.submitting">
										<!--- <svg x-show="$store.forms.pwdFailed()" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" >
											<path stroke-linecap="round" stroke-linejoin="round" d="M18.364 18.364A9 9 0 005.636 5.636m12.728 12.728A9 9 0 015.636 5.636m12.728 12.728L5.636 5.636" />
										</svg> --->
										<svg x-show="$store.forms.submitting" class="animate-spin processing"  xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
												<circle style="opacity: .25"  cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
												<path style="opacity: .75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
										</svg>Register
									</button>
								</div>

								<div class="form-row" style="text-align: center;">
									Already have an account?<div><a href="/login" class="redlink">Log In</a> here</div>
								</div>

						</form>
					</div>

				</div>

			</cfif>	
			<cfif structKeyExists(rc, 'showlogin')>
				<!----------------
					login  
				----------------->
				<!--- id="register-login" --->

				<div class="panel box-shadow2" style="max-width:375px;">
						
						<div class="page-title">
							<h1>Log In</h1>
						</div>
						
						<cfif structKeyExists(rc, 'message')>
							#view( 'common/fragment/errorbox', { messages =  rc.message } )#
						</cfif>
						
						
						<p class="mb-8">
						if you have an account, log in with your username/email address
						</p>

						<div>
						
							<form 
								action="/login" 
								method="post">

								<div class="form-row">
									<input class="form-control" type="text" placeholder="username" name="username" required/>
								</div>
								<div class="form-row">
									<input class="form-control" type="password" placeholder="password" name="password" required/>
								</div>	
						
								<div class="center-w-flex form-row mt-6">
									<button
										id="login"
										name="login"
										<!--- type="submit"  --->
										class="btn btn-red btn-heavy" 
										title="Log In">
										Log In
									</button>
									<cfif structKeyExists(rc, 'destination')>
										<input type="hidden" value="#rc.destination#" name="destination" />
									</cfif>
							
								</div>

							<div class="form-row"  style="text-align: center;">
								<a href="/forgotpassword" class="redlink">Forgot Password?</a>
								<div>
									Don't have an account? <a href="/register" class="redlink">Register</a> here
								</div>
							</div>
						</div>
					</form>
				</div>
				
			</cfif>

		</div>

</cfoutput>
