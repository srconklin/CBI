<cfset pwdmgr = view( 'common/fragment/pwd', {label = 'New Password', store='resetpassword'}) />
<cfoutput>
    <div class="container" style="padding:1rem;padding-bottom:1rem;">
        <div class="flex justify-center align-center flex-direction-column" style="margin-top: 1rem;">
            
            <h1 class="lead-title">#rc.title#</h1>
            #rc.svg#
            <div class="instruction">#rc.instruction#</div>
            <cfoutput>#view( 'common/fragment/setpwdform', {pwdmgr = pwdmgr, buttonlabel=' Reset Password'})# </cfoutput> 
            
        </div>
    </div>
</cfoutput>