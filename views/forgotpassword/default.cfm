
<cfoutput>
    <!--- <div class="container" style="padding:1rem;padding-bottom:1rem;"> --->
      <div class="center-w-flex mt-8">
        <!--- <div class="flex justify-center align-center flex-direction-column" style="margin-top: 1rem;"> --->
            
            <h1 class="lead-title">#rc.title#</h1>
            #rc.svg#
            <div class="instruction">#rc.instruction#</div>
                
            <cfif rc.allowSend>
               <form 
                  id="frmForgotPassword" 
                  name="frmForgotPassword" 
                  <!--- class="flex justify-center align-center flex-direction-column"  --->
                  action="/forgotpassword" 
                  method="post" 
                  onsubmit="submitCap('frmForgotPassword', '/myprofile'); return false;"
                  >
                  <div class="form-row">
                      <input 
                          id="email"
                          name="email"
                          class="form-control" 
                          type="email"
                          placeholder="email@email.com"
                          title="enter the email associated with the account"
                          required
                          />
                  </div>  
  
                  <div class="center-w-flex form-row mt-6">
                      <button 
                          id="=resetpassword"
                          name="=resetpassword"
                          class="btn btn-red" 
                          type="submit" 
                          title="Send reset email"
                          <!--- onclick="submitCap('frmForgotPassword', '/myprofile')" --->
                          >
                          Send Reset Email
                      </button>
                  </div>
                </form> 
            </cfif>
        </div>
    </div>
    <script>
    setTimeout(() => document.getElementById('email').focus(), 100);
    </script>
  </cfoutput>