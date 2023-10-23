<div class="container"> 
 <h3>Coming soon</h3>

 <cfscript>
    try {
      throw(message="my error", errorCode="errorkeyslug", type="dperror")

    }
    catch (any e) {
        writedump(var="#e#",  abort="true");
    }
 
</cfscript>

 <!--- <cfset domain =  cgi.https eq 'on'? 'https://' : "http://" & cgi.http_host /> 
 <cfdump var="#domain#" abort="false"/>
 <cfdump var="#cgi#" abort="true"/>
 </div> --->
