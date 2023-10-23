
<cfoutput>
  <div class="container" style="padding:1rem;padding-bottom:1rem;">
      <div class="flex justify-center align-center flex-direction-column" style="margin-top: 1rem;">
          
          <h1 class="lead-title">#rc.title#</h1>
          #rc.svg#
          <div class="instruction">#rc.instruction#</div>
          
            <!--- 
                ajax version
                    @submit.prevent="$store.forms.form='resetpassword';$store.forms.submit()" 
                server side version
                    onsubmit="submitCap('resetpasswordfrm', '/myprofile'); return false;"
            --->
            <form 
                id="resetpasswordfrm"  
                name="resetpasswordfrm"  
                class="flex justify-center align-center flex-direction-column" 
                action="/resetpassword" 
                method="post" 
                autocomplete="off"
				novalidate
                @submit.prevent="$store.forms.submit('resetpassword')"
                x-data 
                style="margin-top:1rem">
                
                <!--- token sent via email to decrypt --->
                <input type="hidden" name="token" value="#rc.token#" >

                <input 
                    type="text" 
                    id="username"
                    name="username"
                    autocomplete="username" 
                    style="display:none"
                >

                <cfoutput>
                    #view( 'common/fragment/item/pwd', {label = 'New Password', store='resetpassword'})#
                </cfoutput>

                <div
                    class="form-row" 
                    x-cloak 
                    x-show="$store.resetpassword.generalError">
                        <p 
                            class="helper error-message-box error-message" 
                            x-html="$store.resetpassword.generalError">
                        </p>
                </div>
                
                <button 
				id="resetpassword"
				name="resetpassword"
				type="submit" 
				class="btn btn-red" 
				title="reset your password"
				<!--- alpine --->
				:class="{'submitting' :$store.forms.submitting}" 
				:disabled="$store.forms.submitting || $store.resetpassword.pwdFailed()"
                >
					<svg x-show="$store.forms.submitting" class="animate-spin processing"  xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
							<circle style="opacity: .25"  cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
							<path style="opacity: .75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
					</svg>
                    <svg x-show="$store.resetpassword.pwdFailed()" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" >
                        <path stroke-linecap="round" stroke-linejoin="round" d="M18.364 18.364A9 9 0 005.636 5.636m12.728 12.728A9 9 0 015.636 5.636m12.728 12.728L5.636 5.636" />
                    </svg>
                      
                    Reset Password
			</button>
            </form> 

      </div>
    </div>
  </div>
  <script>
  setTimeout(() => document.getElementById('pwd1').focus(), 100);
</script>
</cfoutput>