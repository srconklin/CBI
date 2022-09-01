<cfif structKeyExists(rc, 'nv')>
    <cfset title = "Email Not Yet Verified" />
    <cfset instruction = "That email address exists but has not been verified. An email was already sent to <strong>#encodeforHTML(rc.email)#</strong> with a link to verify your account. Please click the link in that email.<br>If you did't receive the email, please check your spam folder or request a new link below." />
<cfelse>
    <cfset title = "Verify Email" />
    <cfset instruction = "An email has been sent to <strong>#encodeforHTML(rc.email)#</strong> with a link to verify your account.<br>If you don't receive the email, please check your spam folder or request a new link below." />
</cfif>

<cfoutput>
<div class="container" style="padding:1rem;padding-bottom:1rem;">
   
    <div class="flex justify-center align-center flex-direction-column" style="margin-top: 1rem;">
     
        <h1 class="lead-title">#title#</h1>
        <svg xmlns="http://www.w3.org/2000/svg" class="icon-title" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
            <path stroke-linecap="round" stroke-linejoin="round" d="M16 12a4 4 0 10-8 0 4 4 0 008 0zm0 0v1.5a2.5 2.5 0 005 0V12a9 9 0 10-9 9m4.5-1.206a8.959 8.959 0 01-4.5 1.207" />
          </svg>
        <p class="instruction">#instruction#</p>
        <form action="/resendlink" method="post">
            <button type="submit" class="btn btn-red">Resend Email</button>
            <!--- note:  email address to resend link to is relying on the session variable to exist. if it has expired we need to notify of a problem --->
        </form>    
    
    </div>
</div>
</cfoutput>