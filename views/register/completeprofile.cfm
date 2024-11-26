<cfoutput>
   <!--- <cfset pwdmgr = view( 'common/fragment/pwd', {label = 'New Password', store='setpassword'}) /> --->    
    <div class="container" style="padding:1rem;padding-bottom:1rem;margin-top: .5rem;">
        <div class="flex justify-center align-center flex-direction-column" >
             <cfif structKeyExists(rc, 'pb')>
                #rc.pb#
             </cfif>
            <h1 class="lead-title">#rc.title#</h1>
            #rc.svg#
            <div class="instruction">#rc.instruction#</div>
           
            <!--- <cfif structKeyExists(rc, 'gotoSetPassword')>  
               <a href="/completeprofile" class="btn btn-red" >Next &raquo;</a> --->
            <cfif structKeyExists(rc, 'showPasswordMgr')>  
               <!--- a complete password form with configurable destination --->
               #view( 'common/fragment/setPassWordForm',
                      { 
                        destination = 'setpassword', // route maps to  /register/setPassword
                        label = 'New Password', 
                        buttonlabel=' Create Password'
                     })#  
            <cfelseif rc.allowResend>
               <a href="/resendlink" class="btn btn-red" >Resend Email</a>  
            </cfif>

        </div>
    </div>
</cfoutput>
