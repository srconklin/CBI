<cfoutput>
    <div class="container" style="padding:1rem;padding-bottom:1rem;">
        <div class="flex justify-center align-center flex-direction-column" style="margin-top: 1rem;">
            
            <h1 class="lead-title">#rc.title#</h1>
            #rc.svg#
            <div class="instruction">#rc.instruction#</div>
                       
                <form action="/resendlink" method="post" class="flex justify-center align-center flex-direction-column" style="margin-top:1rem">
                       
                    <cfif rc.allowResend>
                        <button class="btn btn-red" >Resend Email</button>
                    </cfif>
                </form> 
        </div>
    </div>
</cfoutput>
