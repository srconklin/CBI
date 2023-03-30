 <cfoutput>
 <div style="background-color:##eee;font-size:16px; padding:1rem;">
 <h2 style="margin-top:1rem;"><u>Summary</u></h2>
			  
    <ul>
        <li>Failed FW/1 action: <b>#request.action#</b></li>
        <li>Exception type: <b>#request.exception.type#</b></li>
        <li>Exception message: <b>#request.exception.message#</b></li>
        <li>Exception detail: <b>#request.exception.detail#</b></li>
        <li>Time Stamp: <b>#dateFormat(now(), 'mm/dd/yyy')# @ #timeFormat(now(), 'HH:mm')#</b></li>
    </ul>

    <h2 style="margin:1rem 0 1rem 0;"><u>Scope Dumps</u></h2>
    <cfif len(request.stacktrace)>
        <h2 style="margin:1rem 0 1rem 0;background-color:pink;">Exception Stack Trace</h2>    
        #request.stacktrace#
    </cfif>
     <!--- #writedump(var=request.exception.tagcontext, format="html")#  --->
    <h2 style="margin:1rem 0 1rem 0;background-color:pink;">rc</h2>    
    #writedump(var=rc, format="html" )#
    <h2 style="margin:1rem 0 1rem 0;background-color:pink;">CGI</h2>    
    #writedump(var=CGI, format="html")#
    <h2 style="margin:1rem 0 1rem 0;background-color:pink;">Session</h2> 
    #writedump(var=session, format="html")#
</div>
</cfoutput>