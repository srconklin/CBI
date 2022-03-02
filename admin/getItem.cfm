<cfsetting showDebugOutput = "no" enablecfoutputonly="true" >
<!--- <cfheader name="Access-Control-Allow-Origin" value="http://localhost:3000"> --->
<cfheader name="Content-Type" value="application/json">

<cfparam name="url.itemno" default="" />
<cfset fileContent = fileRead(ExpandPath( "../" ) & '/data/#url.itemno#.json') /> 
 <cfoutput>
    #fileContent#
 </cfoutput>


