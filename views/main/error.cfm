
<cfoutput>
  <div class="container" style="padding:1rem;padding-bottom:1rem;">
      <div class="flex justify-center align-center flex-direction-column" style="margin-top: 1rem;">
          
          <h1 class="lead-title">Oops, An error occured!</h1>
          <svg xmlns="http://www.w3.org/2000/svg" class="icon-title" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>
          <div class="instruction">Sorry, something is not quite right!  We have been notified of the issue and we are looking it.</div>
                     
            <a href="/">Go Home</a>
          
      </div>
  </div>
</cfoutput>


<cfif request.showDiagnostics>

  <cfoutput>
    <!--- #view('common/fragment/errorReport')#  --->
    <cfinclude template="/views/common/fragment/errorReport.cfm" >
   </cfoutput>

</cfif>