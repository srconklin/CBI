<cfoutput>
    
    <div class="container" style="padding:1rem;padding-bottom:1rem;">
        <div class="flex justify-center align-center flex-direction-column" style="margin-top: 1rem;">
             <cfif structKeyExists(rc, 'pb')>
                #rc.pb#
             </cfif>
            <h1 class="lead-title">#rc.title#</h1>
            #rc.svg#
            <div class="instruction">#rc.instruction#</div>
           
            <cfif structKeyExists(rc, 'gotoSetPassword')>  
               <a href="/completeprofile" class="btn btn-red" >Next &raquo;</a>
            <cfelseif structKeyExists(rc, 'showPasswordMgr')>  
               <cfset pwdmgr = view( 'common/fragment/pwd', {label = 'New Password', store='resetpassword'}) />
               #view( 'common/fragment/setpwdform', {pwdmgr = pwdmgr, buttonlabel=' Create Password'})#
            <cfelseif rc.allowResend>
               <a href="/resendlink" class="btn btn-red" >Resend Email</a>  
            </cfif>

        </div>
    </div>
</cfoutput>
