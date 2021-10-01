<!--- <cfheader name="Access-Control-Allow-Origin" value="http://localhost:3000"> --->
<cfsetting requesttimeout="240" />
<cfsetting showDebugOutput="no" enablecfoutputonly="true">
<cfset variables.itemColTolerance=10 />

<cfscript>
	string function stripCRLFAndMultipleSpaces(required string theString) {
	  local.result = trim(rereplace(trim(arguments.theString), "([#Chr(09)#-#Chr(30)#])", "", "all"));
	  local.result = trim(rereplace(local.result, "\s{2,}", " ", "all"));
	  return local.result;
	}
</cfscript>

  <cffunction name="getClassOrientation">
    <cfargument name="totalrecords" required="true" type="numeric" />
    <cfargument name="currentRow" required="true" type="numeric" />

    <cfset leftrightcount=1 />
    <cfif arguments.totalrecords ge 5 and arguments.totalrecords le 9>
      <cfset leftrightcount=2 />
      <cfelseif arguments.totalrecords ge 9>
        <cfset leftrightcount=3 />
    </cfif>

    <cfif len(leftrightcount) and currentrow le leftrightcount>
      <cfreturn 'dd-left' />
      <cfelseif len(leftrightcount) and currentrow gt (totalrecords - leftrightcount)>
        <cfreturn 'dd-right' />
        <cfelse>
          <cfreturn 'dd-horiz-center' />
    </cfif>


  </cffunction>


  <cfquery name="getMenuTwoLevels" datasource="dp_cat">
    select lnm, anm, parLnm, Oseq, TypeID, MenuID, ParentMenuID, lvl
    FROM [dp_cat].[dbo].[OpsHierarchy2] oh
    WHERE oh.vtid = 1546 and lvl in (1,2)
    order by line
  </cfquery>

  <cfquery name="getMenuFirstLevel" dbtype="query">
    select lnm, anm, parLnm, Oseq, TypeID, MenuID, ParentMenuID
    FROM getMenuTwoLevels
    WHERE lvl = 1
  </cfquery>

<!--- megamenu --->
  <cfsavecontent variable="menu">
    <cfoutput>
      <nav aria-label="Navigation" class="megamenu"> 
        <ul>

          <cfloop query="getMenuTwoLevels">
            <!--- level 1 --->
            <cfif getMenuTwoLevels.lvl eq 1>

              <cfquery name="getMenuchildren" dbtype="query">
                select menuID
                FROM getMenuTwoLevels
                WHERE ParentMenuID = '#getMenuTwoLevels.MenuID#'
              </cfquery>
              <cfset columns=0 />
              <cfif getMenuchildren.recordcount le variables.itemColTolerance>
                <cfset columns=1 />
              <cfelseif getMenuchildren.recordcount le (variables.itemColTolerance*2)>
                 <cfset columns=2 />
              <cfelseif getMenuchildren.recordcount le (variables.itemColTolerance*3)>
                <cfset columns=3 />
              </cfif>

              <cfset itemsPerColumn=int(getMenuchildren.recordcount / columns)+1 />

              <li class="dropdown">
                <a href="/search/#urlEncode(getMenuTwoLevels.Lnm)#" class="dropdown__title" aria-expanded="false"aria-controls="main-#replacenocase(getMenuTwoLevels.Lnm, ' ',  '-')#-dropdown">#getMenuTwoLevels.lnm#</a>
                <ul class="dropdown__menu dd-vertical #(columns gt 1 ? 'dd-mega-group' : '')# #getClassOrientation(getMenuFirstLevel.recordCount, getMenuTwoLevels.Oseq)# dd-ease-out">

            <!--- level 2 --->
            <cfelse>

                    <cfif columns gt 1 and getMenuTwoLevels.OSeq eq 1>
                      <li>
                        <ul class="dropdown__mglinks">
                    </cfif>

                    <li><a href="/search/#urlEncode(getMenuTwoLevels.parLnm &"_"& getMenuTwoLevels.Lnm)#">#getMenuTwoLevels.Lnm#</a></li>

                    <cfif columns gt 1 and getMenuTwoLevels.OSeq eq variables.itemsPerColumn>
                      </ul>
                       <ul class="dropdown__mglinks">
                    </cfif>

            <cfif getMenuTwoLevels.OSeq eq getMenuchildren.recordCount>
              </ul>
              </li>

              <cfif columns gt 1>
                </ul>
                </li>
              </cfif>
            </cfif>

        </cfif>


        </cfloop>

        </ul>
      </nav>
    </cfoutput>
  </cfsavecontent>

  <!--- megamenu slide-menu  --->

  <cfsavecontent variable="menuslide">
    <cfoutput>
      <div class="categoryheader">
      <div class="slider">
          <a href="##" @click="$dispatch('open-megamenu', { open: true })" >Shop Categories</a>&nbsp;<a class="anchor" href="##">&##10132;</a> 
      </div>
    </div>
    <div id="megamenu-sidepanel" class="megamenu-sidepanel" x-data="{open: false}" @open-megamenu.window="open = $event.detail.open" @keydown.escape="open = false">
  	<div X-show.transition.opacity.duration.500="open"	@click="open = false" class="blackout"></div>
	  <div class="transform processing panel-container" :class="{'-translate-x-full': !open}">
		<button @click="open=false" x-ref="closeButton" class="closebutton fixed">
        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
        </svg>
		</button>
     <section class="content">
      <nav aria-label="Navigation" x-data="{panel: -1}">
        <h3 class="nav-header">Shop By Category</h3>
        <ul>

          <cfloop query="getMenuTwoLevels">
            <!--- level 1 --->
            <cfif getMenuTwoLevels.lvl eq 1>

              <cfquery name="getMenuchildren" dbtype="query">
                select menuID
                FROM getMenuTwoLevels
                WHERE ParentMenuID = '#getMenuTwoLevels.MenuID#'
              </cfquery>

              <li class="accordian" > 
                <div class="flex justify-between" :class="{'active': panel==#getMenuTwoLevels.Oseq#}">
                    <a href="/search/#urlEncode(getMenuTwoLevels.Lnm)#" class="accordian-title" aria-expanded="false" aria-controls="main-#replacenocase(getMenuTwoLevels.Lnm, ' ',  '-')#-accordian">#getMenuTwoLevels.Lnm#</a>
                    <a href="##" @click="panel==#getMenuTwoLevels.Oseq# ? panel=-1 : panel = #getMenuTwoLevels.Oseq#">
                      <svg xmlns="http://www.w3.org/2000/svg" fill="none" class="chevron-right" x-show="panel!=#getMenuTwoLevels.Oseq#" viewBox="0 0 24 24" stroke="currentColor">
                           <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
                      </svg>
                      <svg xmlns="http://www.w3.org/2000/svg" class="chevron-down" x-show="panel==#getMenuTwoLevels.Oseq#" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
                      </svg>
                    </a>
                </div>
                <ul class="panel" x-show.transition.in.duration.700ms="panel==#getMenuTwoLevels.Oseq#">
            <!--- level 2 --->
            <cfelse>
                <li><a href="/search/#urlEncode(getMenuTwoLevels.parLnm &"_"& getMenuTwoLevels.Lnm)#">#getMenuTwoLevels.Lnm#</a></li>
          
                <cfif getMenuTwoLevels.OSeq eq getMenuchildren.recordCount>
                  </ul>
                    </li>
                </cfif>
            </cfif>

        </cfloop>

        </ul>
      </nav>
      
    </section>    
   </div>
  </div>
   </cfoutput>
  </cfsavecontent>
  
  <cfsavecontent variable="themenues">
    <cfoutput>
      <div class="megamenu-container" x-cloak x-data="{hidden: false}" @blur-bg.window="$event.detail?hidden = true:hidden=false;" :class="{ 'megamenu-hidden': hidden }">
      #menu#
      #menuslide#
      </div>
    </cfoutput>
  </cfsavecontent>
  
  <cfset fileWrite( ExpandPath( "../" ) & '/views/common/fragment/megamenu.cfm' , stripCRLFAndMultipleSpaces(themenues)) />

  Done!
