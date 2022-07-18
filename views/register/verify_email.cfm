<cfif structKeyExists(rc, 'nv')>
    <cfset instruction = "That email address exists but has not been verified. An email was already sent to <strong>#encodeforHTML(rc.email)#</strong> with a link to verify your account. Please click the link in that email.<br>If you did't receive the email, please check your spam folder or request a new link below." />
    <cfset title = "Email Not Yet Verified" />
<cfelse>
    <cfset instruction = "An email has been sent to <strong>#encodeforHTML(rc.email)#</strong> with a link to verify your account.<br>If you don't receive the email, please check your spam folder or request a new link below." />
    <cfset title = "Verify Email" />
</cfif>

<cfoutput>
<div class="container" style="padding:1rem;padding-bottom:1rem;">
    <div class="register" style="display: flex; align-items: center; flex-direction:column; margin-top: 1rem; justify-content: center;">
        <h1 class="" style="margin-bottom:1rem;">#title#</h1>
        <!--- <svg xmlns="http://www.w3.org/2000/svg" style="width:6rem;height:6rem;" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
            <path stroke-linecap="round" stroke-linejoin="round" d="M8 4H6a2 2 0 00-2 2v12a2 2 0 002 2h12a2 2 0 002-2V6a2 2 0 00-2-2h-2m-4-1v8m0 0l3-3m-3 3L9 8m-5 5h2.586a1 1 0 01.707.293l2.414 2.414a1 1 0 00.707.293h3.172a1 1 0 00.707-.293l2.414-2.414a1 1 0 01.707-.293H20" />
        </svg> --->
        <svg xmlns="http://www.w3.org/2000/svg" style="width:6rem;height:6rem;" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
            <path stroke-linecap="round" stroke-linejoin="round" d="M16 12a4 4 0 10-8 0 4 4 0 008 0zm0 0v1.5a2.5 2.5 0 005 0V12a9 9 0 10-9 9m4.5-1.206a8.959 8.959 0 01-4.5 1.207" />
          </svg>
        <p style="font-size:18px;margin-top:1rem;margin-bottom:1rem; ">#instruction#</p>
        <form action="/resendlink" method="post">
            <button type="submit" class="btn btn-red">Resend Email</button>
            <!--- note:  email address to resend link to is relying on the session variable to exist. if it has expired we need to notify of a problem --->
        </form>    
    
    </div>
</div>
</cfoutput>