<div class="container"> 
 <h3>Coming soon</h3>
 <cfset domain =  cgi.https eq 'on'? 'https://' : "http://" & cgi.http_host /> 
 <cfdump var="#domain#" abort="false"/>
 <cfdump var="#cgi#" abort="true"/>
 </div>
