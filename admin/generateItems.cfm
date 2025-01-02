
<cfsetting requesttimeout="240" />
<cfsetting showDebugOutput = "no" enablecfoutputonly="false" >
<cfparam name="url.itemno" default="" />
<cfparam name="url.build" default="items,bc" />

<!--- defaults --->
<!--- vtid to use get menu structure data which is sbx in dynaspecs --->

<cfset imgbase = "https://www.capovani.com/clientresources/"  />
<cfset items = [] /> 
<cfset cacheMenu = {} /> 

<!------------------------------------------- 
	functions 
------------------------------------------->
<cfscript>
	string function stripCRLFAndMultipleSpaces(required string theString) {
	  local.result = trim(rereplace(trim(arguments.theString), "([#Chr(09)#-#Chr(30)#])", "", "all"));
	  local.result = trim(rereplace(local.result, "\s{2,}", " ", "all"));
	  return local.result;
	}
</cfscript>

<cffunction name="getMenus">
	<cfargument name="classTID" required="true" type="numeric" />
	<cfargument name="MenuID" required="false"  default="" type="string" />
	<cfargument name="lvlThreshold" required="false" default="7" type="numeric" />
	<cfargument name="delimeter" required="false" default=">" type="string" />
	<cfquery name="qry" datasource="dp_cat" >

		WITH cte_bredcrumb 
		AS 
		(
			-- Anchor member
			SElECT oh.TID, oh.lnm, oh.MenuID, oh.ParentMenuID, oh.lvl, left(oh.MenuID, 3) as base
			FROM [dp_cat].[dbo].[OpsHierarchy2] oh
			WHERE  oh.vtid = #application.vtid#
			and oh.tid = #arguments.classTID#
			<cfif len(arguments.MenuID)>
				and ParentMenuID = '#arguments.MenuID#'
			</cfif>
			--and lvl < #arguments.lvlThreshold#
			
			UNION ALL
			-- Recursive member that references expression_name.
			SELECT o.TID,o.lnm, o.MenuID, o.ParentMenuID, o.lvl, cte.base 
			FROM [dp_cat].[dbo].[OpsHierarchy2] o
			INNER JOIN cte_bredcrumb cte on cte.ParentMenuID =  o.MenuID
			WHERE  o.vtid = #application.vtid#  and o.lvl > 0 
		)

		SELECT MenuID, lnm, base, lvl
		FROM cte_bredcrumb 
		--where lvl < #arguments.lvlThreshold#
		order by base, lvl

		-- select base,
		-- STRING_AGG(lnm,' #arguments.delimeter# ') WITHIN GROUP ( ORDER BY lvl asc)
		-- AS breadcrumb
		-- from cte_bredcrumb 
		-- group by base

	</cfquery>

	<cfreturn qry />
</cffunction>


<!------------------------------------------- 
 Get the item data
------------------------------------------->
<cfquery name="getItem" datasource="dp_cat">
	select
	C.LNm,C.Par1LNm, C.Syn,C.ParentMenuID,
	( select  count(*) as ct
	  from transactions t
	  where t.itemno = i.ItemNo
	  and t.lastlink =1 
	) as popular,
	DATEDIFF(second,{d '1970-01-01'},I.adddt) as unixTimeStamp,
	I.*,
	 II.ServerName,
	 EC1.Text AS ShipText,
	 EC2.Text AS PayText,
	 geo.citySnm, geo.stSnm, geo.CySnm
	FROM Items I 
	INNER JOIN OpsClasses C on C.VTID=#application.vtid# AND C.classTID=I.dataTID AND C.vizPagetop <= 0
	INNER JOIN CoVenues VP ON VP.VTID=I.VTID
	LEFT JOIN ItemsImages II on II.ItemNo=I.Itemno  AND II.ArchDt IS NULL 
	LEFT JOIN ECommerce AS EC1 ON EC1.ECommNo=I.ShippingInfo
	LEFT JOIN ECommerce as EC2 ON EC2.ECommNo=I.PaymentInfo
	OUTER APPLY dbo.getGeoData(I.LLocGID,I.LStPGID,I.LCyGID) as geo
	WHERE I.ArchDt IS NULL 
	<cfif len(url.itemno)>
		AND I.Itemno = <cfqueryparam value="#url.itemno#" cfsqltype="cf_sql_integer" />
	</cfif>
	AND I.IVTID=#application.ivtid# 
			AND (I.vizPub>=9 OR (I.PNo=0 AND 9 <= VP.viz)) 
			AND (I.Qty>0 OR I.inAuction=1 OR 0 >= 3)  AND (I.Qty>0 OR I.OfferBid=1 OR I.inAuction>0 ) AND I.OfferBid=0

	ORDER BY I.DataTID, I.Itemno
		
</cfquery>

<!------------------------------------------- 
 clear the items directory 
------------------------------------------->
<cfif listfindnocase(url.build, 'items')>
	<p>clearing items dir</p>	
	<cfdirectory name="datadir" directory="#expandpath('../data')#" filter=".json">
	<cfloop query="datadir">
		<cfset cffile_file = "#expandpath('../data')#/#name#">
		<cffile action="delete" file="#cffile_file#">
	</cfloop>
</cfif>


<!------------------------------------------- 
 clear the breadcrumbs directory 
------------------------------------------->
<cfif listfindnocase(url.build, 'bc')>
	<p>clearing bc dir</p>	
	<cfdirectory name="datadir" directory="#expandpath('../data/bc')#" >
	<cfloop query="datadir">
		<cfset cffile_file = "#expandpath('../data/bc')#/#name#">
		<cffile action="delete" file="#cffile_file#">
	</cfloop>
</cfif>


<cftry>

	
<cfoutput query="getItem" group="itemno" >

	<cfset breadcrumb = "" />
	<cfset breadcrumbUI = "" />
	<cfset colheadList = ''>
	<cfset selectList = ''>

	<cfset item = StructNew("Ordered") />  

	<!------------------------------------------- 
	build menu heirarchy 
	------------------------------------------->
	<cfset qryMenus = getMenus(getItem.dataTID, getItem.ParentMenuID) />
	<cfset bcpath = '' />
	<cfset breadcrumbUI = '<ul class="ais-Breadcrumb-list"><li class="ais-Breadcrumb-item"><a class="ais-Breadcrumb-link" href="/search/">All Categories</a></li>' />
	<cfloop query="qryMenus">
		<cfset bcpath = listAppend(bcpath, trim(qryMenus.lnm), '_') />
		<cfset breadcrumb = listAppend(breadcrumb, trim(qryMenus.lnm), '>') />
		<cfset item['categories.lvl#qryMenus.currentrow-1#'] = "#replace(breadcrumb,">", ' > ', 'all')#" />
		<cfset breadcrumbUI = breadcrumbUI & '<li class="ais-Breadcrumb-item"><span class="ais-Breadcrumb-separator" aria-hidden="true">&gt;</span><a class="ais-Breadcrumb-link" href="/search/#encodeForURL(trim(bcpath))#/">#trim(qryMenus.lnm)#</a></li>' />
	</cfloop>	
	<cfset breadcrumbUI = breadcrumbUI & '</ul>' />

	<!------------------------------------------- 
 	build the item json object
	------------------------------------------->

	<cfset item['itemno'] =  "#getItem.Itemno#" />   
	<cfset item['headline'] = "#trim(REReplaceNoCase(getItem.headline,"(<[^>]*>|&nbsp;|<br>)", " ","All"))#" />   
	<cfset item['description'] = "#decodeForHTML(trim(REReplaceNoCase(getItem.descr,"(<[^>]*>|&nbsp;|<br>)", " ","All")))#"  />   
	<cfset item['location'] =  "#getItem.citySnm#, #getItem.stSnm# #getItem.CySnm#"/>
	<cfset item['category'] =  "#getItem.LNm#" />
	<cfset item['mfr'] =  "#getItem.maketxt#" />
	<cfset item['model'] =  "#getItem.model#" />
	<cfset item['keywords'] =  "#trim(replace(getItem.syn, ',',' ','all'))#" />
	<cfset item['unixTimeStamp'] =  "#getItem.unixTimeStamp#" />  
	<cfset item['popular'] =  "#getItem.popular#" />  
	<cfset item['isFeatured'] =  "#getItem.isFeatured#" />  
	
	<!------------------------------------------- 
		images
	 ------------------------------------------->

	 <cfset item['imgbase'] =  imgBase/>  
	 <cfif len(getItem.imgServNameMn)>
		 <cfset item['imgMain'] =  "#Trim(getItem.CoTID)#/#getItem.IVTID#/#Trim(Right(getItem.DataTID,2))#/#getItem.DataTID#/#getItem.imgServNameMn#" />  
	 <cfelse>
		 <cfset item['imgMain'] =  "no-image.png" />
	 </cfif>
	 <cfset arImages =  [] />  
 
	 <cfoutput>
		 <cfif len(getItem.ServerName)>
			 <cfset arrayAppend(arImages, "#Trim(getItem.CoTID)#/#getItem.IVTID#/#Trim(Right(getItem.DataTID,2))#/#getItem.DataTID#/#getItem.ServerName#") />
		 </cfif>	
	 </cfoutput>		
 
	 <cfset item['imagesXtra'] = arImages />

	 <!--- add to batch --->
	<cfset arrayAppend(items, item) />

	<!--------------------------------------------------------- 
		single file json data only 
		from here on data is not sent typsense or algolia
	---------------------------------------------------------->
	<cfset item['pagetitle'] =  len(getItem.pagetitle) gt 0 ?  trim(REReplaceNoCase(getItem.pagetitle,"(<[^>]*>|&nbsp;|<br>)", " ","All")) : item['headline'] />   
	<cfset item['price'] =  len(getItem.price) ? "#dollarFormat(getItem.price)#" : "Best Price" />
	<cfset item['qty'] =  "#getItem.qty#" />

	<!------------------------------------------- 
		specstable
	 ------------------------------------------->
	<cfset classParsDir = "/clientSites/#getItem.COTID#/#getItem.IVTID#/classFiles/#Trim(Right(getItem.DataTID,2))#/#Trim(getItem.DataTID)#/">
	<cfinclude template="#variables.ClassParsDir#ClassParsC.cfm">

	<cfset variables.irow= "alt"/>
	<cfset AllowVendorAliases = 0>
	<cfsavecontent variable="specs">
		<table border="0" cellpadding="2">
		<cfinclude template="#variables.DescrTemplateDir#iformC.cfm"> 
		</table>
	</cfsavecontent>
	<!--- remove unncessary legacy layout garbage --->
	<cfset specs = #trim(REReplaceNoCase(specs,'(&nbsp;|<img src="/dpimages/s.gif" width=1 height=1>|valign="?top"?|<!-- (.+?) -->)', ' ','All'))#>
	<cfset item['specstable'] = stripCRLFAndMultipleSpaces(specs) >

	
	<!------------------------------------------- 
		terms
	 ------------------------------------------->
	 <!--- shipping --->
	<!--- nb space not necessary --->
	<cfset ship =  trim(REReplaceNoCase(getItem.ShipText,'(&nbsp;|<p>|</p>)', ' ','All')) >
	<!--- replace brs with P; looks nicer --->
	<cfset ship =  trim(REReplaceNoCase(ship,'<br ?/?>', '<p class="mt-2 mb-4">','All')) >
	<!--- links with routes --->
	<cfset ship =  trim(REReplaceNoCase(ship,'terms.cfm', '/terms','All')) >
	<cfset item['shipterms'] =  ship />  

	<!--- payment --->
	<!--- nb space not necessary --->
	<cfset pay =  trim(REReplaceNoCase(getItem.paytext,'&nbsp;', ' ','All')) >
	<!--- replace brs with P; looks nicer --->
	<cfset pay =  trim(REReplaceNoCase(pay,'<br ?/?>', '<p class="mt-2 mb-2">','All')) >
	<!--- links with routes --->
	<cfset pay =  trim(REReplaceNoCase(pay,'terms.cfm', '/terms','All')) >
	<cfset item['payterms'] =  pay/>  

	

	<!------------------------------------------- 
		Create files
	 ------------------------------------------->
	<cfif listfindnocase(url.build, 'items')>
		<cfset fileWrite( ExpandPath( "../" ) & '/data/#getItem.Itemno#.json',  #trim(serializeJSON(item))# , 'UTF-8') />
	</cfif>	
	<cfif listfindnocase(url.build, 'bc')>
		<cfset fileWrite( ExpandPath( "../" ) & '/data/bc/#getItem.Itemno#.cfm',  #trim(breadcrumbUI)# ) />
	</cfif>
	#getItem.currentrow#  #getItem.Itemno#<br>
	
</cfoutput>

<cfcatch>
	<cfdump var="#cfcatch#" abort="true"/>
</cfcatch>
</cftry>

	
<!------------------------------------------- 
	create array of items for algolia
 ------------------------------------------->
<cfif listfindnocase(url.build, 'items')>
	<cfset fileWrite( ExpandPath( "../" ) & '/data/items.json',  #trim(serializeJSON(items))# , 'UTF-8') />
</cfif>	

<cfoutput>DONE</cfoutput>



