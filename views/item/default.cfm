<cfoutput>
	<!--- server side properties on a div to make the forms js operate properly --->
	  <div 
		x-data="{
			itemno: #rc.content.itemno# 
		}" 
	  	id="item" 
		itemno="#rc.content.itemno#" 
		itemct="#arraylen(rc.content.imagesXtra)+1#" 
		qty=#rc.content.qty# 
		price="#rc.content.price#">
  
		  <!--- cookie crumb --->
		  <div class="breadcrumb">
			   #rc.bc#
		  </div>
	
		  <article class="item">
			  <!--- left column image carousel --->
			  <aside>
				  <cfoutput>
					 <!--- Note:  server side version of carousel places item list into html source:  SEO  --->
					  #view( 'common/fragment/server/carousel')#
				  	  #view( 'common/fragment/imageModal')#
				</cfoutput>
			  </aside>
			  <!--- right column item detail --->
			  #view('common/fragment/itemFeatures' , {server=true})#
		  </article> 					
	  </div>
	    
  #view('/common/fragment/login')# 
  </cfoutput>
