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

    <cfset leftrightcount='' />
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

  <cfsavecontent variable="menu">
    <cfoutput>
      <nav aria-label="Navigation">
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
                <a href="/search/#urlEncode(getMenuTwoLevels.Lnm)#" class="dropdown__title" aria-expanded="false"
                  aria-controls="main-dishes-dropdown">#getMenuTwoLevels.anm#</a>
                <ul
                  class="dropdown__menu dd-vertical #(columns gt 1 ? 'dd-mega-group' : '')# #getClassOrientation(getMenuFirstLevel.recordCount, getMenuTwoLevels.Oseq)# dd-ease-out">

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

  <cfset fileWrite( ExpandPath( "../" ) & '/views/common/fragment/megamenu.cfm' , stripCRLFAndMultipleSpaces(menu) ) />

  Done!
