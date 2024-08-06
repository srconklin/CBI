<cfparam name="local.active" default="1">
<cfset lstoflabels =  "Verify Email,Set Password,Complete!"/>

<cfoutput>
	<div class="container">
        <ol class="progress" >
            <cfloop from="1" to="#listlen(lstoflabels)#" index="i" >
                <cfif i eq local.active>
                    <cfset class = "active" />
                <cfelseif i Lt local.active>
                    <cfset class = "done" />  
                <cfelse>
                    <cfset class = "" />      
                </cfif>    
                <li class="#class#">
                    <span class="name">#listGetAt(lstoflabels, i)#</span>
                    <span class="step"><span>#i#</span></span>
                </li>
            </cfloop>
         
        </ol>
	</div>				
</cfoutput>
