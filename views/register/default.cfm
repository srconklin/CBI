
<cfoutput>

	<div class="register">
					
		<!-- flex row for two boxes -->
		<div class="register-wrapper">


		<cfif !structKeyExists(rc, 'loginOnly')>

			<!------------------------ 
				create an account 
			------------------------->
			<div id="register-account" class="login-panel box-shadow2">
						
				<div class="login-title">
					<h1>Create an Account</h1>
				</div>
				
						
				<p class="register-lead">
				Signing up for an account is free, quick and easy. Members can more quickly submit offers and inquiries.
				</p>
				

					<div>
						<form action="/register" method="post" xdata id="registerfrm"  @submit.prevent="$store.forms.form='register';$store.forms.submit()">
									
							<cfoutput>
							#view( 'common/fragment/item/personal', {phone = 'phone1'})#
							</cfoutput>

							<div class="form-row">
							<label for="password" class="form-label">
								Password <span>*</span>
							</label>
							
							<input name="password" id="password" type="password" class="form-control" :class="{'invalid':$store.forms.password.errorMessage && $store.forms.password.blurred}"  placeholder="password" maxlength="25" required  @blur="$store.forms.validate($event)"/>
							<p class="helper error-message" x-cloak x-show="$store.forms.password.errorMessage && $store.forms.password.blurred" x-text="$store.forms.password.errorMessage" ></p>
							</div>	

							<div class="form-row checkbox-container">
								<label for="bcast" >
									<input class="checkbox" type="checkbox" name="bcast" value="1" >
									<span>Send me occasional email offers about new listings and featured items. <i>You may unsubscribe at any time.</i></span>
								</label>
							</div>	

							<div class="form-row checkbox-container">
								<label for="agreetandc" >
									<input class="checkbox" type="checkbox" name="agreetandc" required>
									<span>Agree to Terms</span>
								</label>
							</div>	

							<div class="form-row" x-cloak x-show="$store.forms.captcha.errorMessage && $store.forms.captcha.blurred">
								<p class="helper error"  x-text="$store.forms.captcha.errorMessage" class="error-message"></p>
							</div>
							<div class="form-row" x-cloak x-show="$store.forms.emailinuse.errorMessage && $store.forms.emailinuse.blurred">
								<p class="helper error"  x-html="$store.forms.emailinuse.errorMessage" class="error-message"></p>
							</div>
							

							<!--- <button type="submit" class="btn btn-red login-submit">Register</button> --->
							<div class="form-row">
								<button type="submit" class="btn btn-red login-submit" :class="{'submitting' :$store.forms.submitting}" :disabled="$store.forms.submitting">
									<svg x-show="$store.forms.submitting" class="animate-spin processing"  xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
											<circle style="opacity: .25"  cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
											<path style="opacity: .75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
									</svg>Register
								</button>
							</div>

						</form>
					</div>

					<div class="login-footnote flex justify-center"></div>

				</div>

			</cfif>	
			<!----------------
				 login  
			-------------------->
			<div id="register-login" class="login-panel box-shadow2">
					
					<div class="login-title">
					<h1>Log In</h1>
					</div>
					
					<cfif structKeyExists(rc, 'message')>
						#view( 'common/fragment/errorbox', { messages =  rc.message } )#
					</cfif>
					
					
					<p class="register-lead">
					if you have an account, log in with your username/email address
					</p>

					<div>
					
						<form action="/login" method="post">
							<div class="form-row">
								<input class="form-control" type="text" placeholder="username" name="username" required/>
							</div>
							<div class="form-row">
								<input class="form-control" type="password" placeholder="password" name="password" required/>
							</div>	
					
						<div>
						<p>
							<a href="/forgotpassword" class="login-fp">Forgot Password?</a>
						</p>
						</div>
					
						<button type="submit" class="btn btn-red login-submit">Log In</button>
						<cfif structKeyExists(rc, 'destination')>
							<input type="hidden" value="#rc.destination#" name="destination" />
						</cfif>
					</form>
					</div>

					<div class="login-footnote flex justify-center mx-3 mt-1">
					<p>Don't have an account? 
						<a href="##">Sign up</a>
					</p>
					</div>

			</div>

		</div>

</cfoutput>
