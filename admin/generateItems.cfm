<!--- <cfheader name="Access-Control-Allow-Origin" value="http://localhost:3000"> --->
<cfsetting requesttimeout="240" />
<cfsetting showDebugOutput = "no" enablecfoutputonly="true" >
<cfparam name="url.itemno" default="" />


<cfset items = [] /> 
<cfset cacheMenu = {} /> 

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
	<cfargument name="lvlThreshold" required="false" default="4" type="numeric" />
	<cfargument name="delimeter" required="false" default=">" type="string" />
	<cfquery name="qry" datasource="dp_cat" >

		WITH cte_bredcrumb 
		AS 
		(
			-- Anchor member
			SElECT oh.TID, oh.lnm, oh.MenuID, oh.ParentMenuID, oh.lvl, left(oh.MenuID, 3) as base
			FROM [dp_cat].[dbo].[OpsHierarchy2] oh
			WHERE  oh.vtid = 63160  
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
			WHERE  o.vtid = 63160  and o.lvl > 0 
		)

		SELECT MenuID, lnm, base, lvl
		FROM cte_bredcrumb 
		where lvl < #arguments.lvlThreshold#
		order by base, lvl

		-- select base,
		-- STRING_AGG(lnm,' #arguments.delimeter# ') WITHIN GROUP ( ORDER BY lvl asc)
		-- AS breadcrumb
		-- from cte_bredcrumb 
		-- group by base

	</cfquery>

	<cfreturn qry />
</cffunction>


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
	-- I.Cotid, I.IVTID,
	-- I.ItemNo, I.dataTID, I.isFeatured,	I.isNew, I.isReduced, I.isSpecial, I.Headline, I.Descr, I.adddt, 
	-- I.Price,
	-- -- I.Prifmt,
	-- -- I.CurrSymbolScaled,
	-- I.Qty,
	-- --I.UnitsDisplay,
	-- I.makeTxt,
	-- I.Model,
	-- I.imgServNameMn,
	-- II.ServerName,
	-- I.DescrSfx,


	geo.citySnm, geo.stSnm, geo.CySnm
	FROM Items I WITH (NOLOCK)
	INNER JOIN OpsClasses C on C.VTID=63160 AND C.classTID=I.dataTID AND C.vizPagetop <= 0
	INNER JOIN CoVenues VP ON VP.VTID=I.VTID
	LEFT JOIN ItemsImages II on II.ItemNo=I.Itemno  AND II.ArchDt IS NULL 
	OUTER APPLY dbo.getGeoData(I.LLocGID,I.LStPGID,I.LCyGID) as geo
	WHERE I.ArchDt IS NULL 
	<cfif len(url.itemno)>
		AND I.Itemno = <cfqueryparam value="#url.itemno#" cfsqltype="cf_sql_integer" />
	</cfif>
	AND I.IVTID=108 AND (I.vizPub>=9 OR (I.PNo=0 AND 9 <= VP.viz))  AND (I.Qty>0 OR I.inAuction=1 OR 0 >= 3)  AND (I.Qty>0 OR I.OfferBid=1 OR I.inAuction>0 ) AND I.OfferBid=0
	ORDER BY I.DataTID, I.Itemno
		
  </cfquery>
	

<cfoutput query="getItem" group="itemno" >

	<cfset colheadList = ''>
	<cfset selectList = ''>

	<cfset item = StructNew("Ordered") />  

	<cfset item['itemno'] =  "#getItem.Itemno#" />   
	<cfset item['headline'] = "#trim(REReplaceNoCase(getItem.headline,"(<[^>]*>|&nbsp;|<br>)", " ","All"))#" />   
	<cfset item['description'] = "#trim(REReplaceNoCase(getItem.descr,"(<[^>]*>|&nbsp;|<br>)", " ","All"))#"  />   
	<cfset item['mfr'] =  "#getItem.maketxt#" />
	<cfset item['model'] =  "#getItem.model#" />
	<cfset item['price'] =  len(getItem.price) ? "#dollarFormat(getItem.price)#" : "Best Price" />
	<cfset item['qty'] =  "#getItem.qty#" />
	<cfset item['location'] =  "#getItem.citySnm#, #getItem.stSnm# #getItem.CySnm#"/>
	<cfset item['category'] =  "#getItem.LNm#" />
	<cfset item['keywords'] =  "#trim(replace(getItem.syn, ',',' ','all'))#" />
	<!--- <cfset item['adddate'] =  "#getItem.adddt#" />   --->
	<cfset item['unixTimeStamp'] =  "#getItem.unixTimeStamp#" />  
	<cfset item['popular'] =  "#getItem.popular#" />  
	<cfset item['isFeatured'] =  "#getItem.isFeatured#" />  
	<cfset qryMenus = getMenus(getItem.dataTID, getItem.ParentMenuID) />
	
	<cfset breadcrumb = "" />
	<cfloop query="qryMenus">
		<cfset breadcrumb = listAppend(breadcrumb, trim(qryMenus.lnm), '>') />
		<!--- <cfset breadcrumb = replace(breadcrumb,">", ' > ', 'all') /> --->
		<cfset item['categories.lvl#qryMenus.currentrow-1#'] = "#replace(breadcrumb,">", ' > ', 'all')#" />
	</cfloop>	

	<!--- <cfhttp url="https://www.capovani.com/iinfo.cfm?ItemNo=#getItem.Itemno#" charset="utf-8" method="GET" resolveurl="false" throwonerror="no">  
	<cfset arResults  = reFindNoCase("(<!-- specs -->)(.*?)(<!-- \/specs -->)", CFHTTP.FileContent, 1, true, "1") /> 
	<cfset specs = Mid(CFHTTP.FileContent,arResults.POS[3],arResults.LEN[3])>
	<cfset specs = #trim(REReplaceNoCase(specs,'(&nbsp;|<img src="/dpimages/s.gif" width=1 height=1>|valign="?top"?|<!-- (.+?) -->)', ' ','All'))#>
	<cfset item['specstable'] = stripCRLFAndMultipleSpaces(specs) >
	 --->

		<cfset classParsDir = "/clientSites/#getItem.COTID#/#getItem.IVTID#/classFiles/#Trim(Right(getItem.DataTID,2))#/#Trim(getItem.DataTID)#/">
		<cfinclude template="#variables.ClassParsDir#ClassParsC.cfm">
	
		<cfset variables.irow= "alt"/>
		<cfset AllowVendorAliases = 0>
		<cfsavecontent variable="specs">
			<table border="0" cellpadding="2">
			<cfinclude template="#variables.DescrTemplateDir#iformC.cfm">
			</table>
		</cfsavecontent>
		<cfset specs = #trim(REReplaceNoCase(specs,'(&nbsp;|<img src="/dpimages/s.gif" width=1 height=1>|valign="?top"?|<!-- (.+?) -->)', ' ','All'))#>
		<cfset item['specstable'] = stripCRLFAndMultipleSpaces(specs) >


	<cfset item['imgbase'] =  "https://www.capovani.com/clientresources/" />  
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

	<cfset arrayAppend(items, item) />

	<cfset fileWrite( ExpandPath( "../" ) & '/data/#getItem.Itemno#.json',  #trim(serializeJSON(item))# ) />
	#getItem.currentrow#  #getItem.Itemno#<br>
	
</cfoutput>

<cfset fileWrite( ExpandPath( "../" ) & '/data/items.json',  #trim(serializeJSON(items))# ) />
<cfoutput>DONE</cfoutput>
<!--- <cfcontent reset="true"> 
<cfheader name="Content-Type" value="application/json"> 

 <cfoutput>
  #trim(serializeJSON(items))#
 </cfoutput> --->


