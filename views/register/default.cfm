<cfparam name="local.concise" default="false" >

<cfoutput>
	
	<!--- <div class="register"> --->
					
		<!-- flex centering -->
		<div class="center-w-flex  <cfif not local.concise> mt-8 </cfif>">

		<cfif structKeyExists(rc, 'showregister')>

			<!------------------------ 
				create an account 
			------------------------->
			<!--- id="register-account" --->
			<div class="panel <cfif not local.concise>box-shadow2</cfif>" style="max-width:1024px;">
						
				<div class="form-header text-center">
					<h1 class="lead-title">Create an Account</h1>
				</div>
						
				<p class="mb-8 text-center">
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
							@submit.prevent="$store.forms.submit('register'); ">
														
								<div class="flex flex-direction-column" style="gap: 3em;">
									<div class="flex-child" >
										<cfoutput>#view( 'common/fragment/personal', {store='register'})#</cfoutput>
									</div>	
									
									<!--- personal fields --->
									<div class="flex-child" >
										<cfoutput>#view( 'common/fragment/pwd', {label = 'Password', store='register'})# </cfoutput>

										<div class="form-row checkbox-container">
											<label for="bcast" >
												<input 
													id="bcast"
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
													id="agreetandc"
													name="agreetandc"
													type="checkbox" 
													class="checkbox" 
													required
													data-msg='["valueMissing:you must agree to the terms and conditions"]'			
													title="you must agree to the terms and conditions" 
													<!--- alpine --->
													:class="{'invalid':$store.register.toggleError('agreetandc')}" 
													x-model="$store.register.agreetandc.value" >
												<span>I Agree to <a class="redlink" href="/terms">Terms of Service</a></span>
											</label>
											<p 
												class="helper error-message" 
												x-cloak 
												x-show="$store.register.toggleError('agreetandc')" 
												x-text="$store.register.agreetandc.errorMessage">
											</p>
										</div>
										
										<div 
											class="form-row" 
											x-cloak 
											x-show="$store.register.generalError">
												<p 
													class="helper error-message-box error-message" 
													x-html="$store.register.generalError">
												</p>
										</div>
									
									</div>		

								</div>

								<div class="form-row mt-6 center-w-flex">
									<button 
										id="register"
										name="register"
										<!--- type="submit"  --->
										class="btn btn-primary btn-heavy" 
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

								<div class="form-row text-center">
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

				<div  <cfif not local.concise>class="panel box-shadow2" </cfif> style="width:100%; max-width: 375px;"
					x-data="{title: 'Log In'}" 
					@show-login.window="title=$event.detail.title;open=true"
					x-id="['title']"
					:aria-labelledby="$id('title') " 
					>
						<div class="form-header text-center" >
							<h1 class="lead-title" :id="$id('title')" x-text="title"></h1>
						</div>
						
						<cfif structKeyExists(rc, 'message')>
							#view( 'common/fragment/errorbox', { message =  rc.message } )#
						</cfif>
												
						<p class="mb-8 text-center">
						Log in with your username/email address
						</p>

						<div>
							<form 
								id="frmlogin"
								name="frmlogin"
								action="/login" 
								method="post"
								onsubmit="submitCap('frmlogin', '/login'); return false;">

								<div class="form-row">
									<input 
										id="username" 
										name="username" 
										class="form-control" 
										type="text" 
										placeholder="username or email" 
										title="enter your email or username to login" 
										autocomplete="username"
										required/>
								</div>
								<div class="form-row">
									<input
										id="password" 
										name="password" 
										class="form-control" 
										type="password"
										maxlength="25"
										placeholder="password" 
										title="enter your password" 
										autocomplete="current-password"
										required/>
								</div>	
						
								<div class="center-w-flex form-row mt-6">
									<button
										id="login"
										name="login"
										<!--- type="submit"  --->
										class="btn btn-primary btn-heavy" 
										title="Log In">
										Log In
									</button>
									<cfif structKeyExists(rc, 'destination')>
										<input id="destination" type="hidden" value="#rc.destination#" name="destination" />
									<cfelse>
										<input id="destination" type="hidden" name="destination" />	
									</cfif>
							
								</div>

							<div class="form-row text-center">
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
