
<cfif rc.result.success>
    <cfset title = "Yah! Email Verified" />         
    <cfset instruction = "You are now logged in! Please feel free to browse our inventory." />         
<cfelse>        
    <cfset title = "Hmm, something went wrong with verifying your email address." />         
    <cfset instruction = "looks like there is a problem, try sending another link using the button below or contact customer support at the email or phone number in the footer below." />         
</cfif>
<cfoutput>

    <div class="container" style="padding:1rem;padding-bottom:1rem;">
        <div class="register" style="display: flex; align-items: center; flex-direction:column; margin-top: 1rem; justify-content: center;">
            
            
            <h1 class="" style="margin-bottom:1rem;">#title#</h1>
            
            
             <cfif rc.result.success>
                
                <svg xmlns="http://www.w3.org/2000/svg" style="width:6rem;height:6rem;" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M16 12a4 4 0 10-8 0 4 4 0 008 0zm0 0v1.5a2.5 2.5 0 005 0V12a9 9 0 10-9 9m4.5-1.206a8.959 8.959 0 01-4.5 1.207" />
                </svg>

             <cfelse>

                <svg xmlns="http://www.w3.org/2000/svg" style="width:6rem;height:6rem;" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                 </svg>

             </cfif>

            <p style="font-size:18px;margin-top:1rem;margin-bottom:1rem; ">#instruction#</p>
            <button class="btn btn-red" >Resend Email</button>
        
        </div>
    </div>
    </cfoutput>