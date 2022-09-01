
<cfset instruction = "Enter the email address associated with your account and will send a link to reset your password" />
<cfset title = "Forgot your Password " />

<cfoutput>
<div class="container" style="padding:1rem;padding-bottom:1rem;">

    <div class="flex justify-center align-center flex-direction-column" style="margin-top: 1rem;">
        <h1 class="lead-title">#title#</h1>
        
          <svg xmlns="http://www.w3.org/2000/svg" class="icon-title" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
            <path stroke-linecap="round" stroke-linejoin="round" d="M16.5 10.5V6.75a4.5 4.5 0 10-9 0v3.75m-.75 11.25h10.5a2.25 2.25 0 002.25-2.25v-6.75a2.25 2.25 0 00-2.25-2.25H6.75a2.25 2.25 0 00-2.25 2.25v6.75a2.25 2.25 0 002.25 2.25z" />
          </svg>
          
        <p class="instruction">#instruction#</p>
        <form action="/processforgotpassword" method="post" class="flex justify-center align-center flex-direction-column" style="margin-top:1rem">
            <div class="form-row">
                <input class="form-control" style="min-width: 350px;" type="email" placeholder="email@email.com" name="email" required/>
            </div>
            <button type="submit" class="btn btn-red">Send Reset Email</button>
            <!--- note:  email address to resend link to is relying on the session variable to exist. if it has expired we need to notify of a problem --->
        </form>    
    
    </div>
</div>
</cfoutput>