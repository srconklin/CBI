 <div id= "nav">
<!--- header --->
	<header class="header" x-cloak x-data="{showMenu : false, hidden: false}" @blur-bg.window="$event.detail?hidden = true:hidden=false;" :class="{ 'header-hidden': hidden }">
		<div class="header-container">
		
			<!--- 2 column  wrapper --->
		  <!--- <div class="header-column"> --->
	
			<!--- logo --->
			<div class="header-logo">
				<a href="/">	
					<img alt="Capovani Brothers" class="block" src="/images/logo_short2.png">
				</a>		
						<!--- <cfif local.route eq 'default'>
							<h3><span>C</span>apovani <span>B</span>rothers <span>I</span>nc</h3>
						</cfif>	 --->
					<!--- </div> --->
		  	</div>
			<!--- 	
			<cfif local.route neq 'default'>
				<div id="searchbox" class="searchbox-abbr"></div>
			</cfif> --->
			<div class="flex justify-center align-items" style="flex:2">
				<div id="searchbox" style="max-width: 800px;"></div>
			</div>

		  <!--- links menu --->
		  <div :class="{ 'hidden': !showMenu }" class="flex header-links">
			<a href="/about">
			  About
			</a>
			<a href="/contact">
			  Contact
			</a>
			<a href="/faq">
			  FAQ
			</a>
			
			<cfif rc.userSession.isLoggedIn >

				<div x-data="{
						showUM : false,
						closeUM() {
							this.showUM = false
						},
						open() {
							this.showUM = true
						}	
					}" 
					x-ref="uMenu"
					class="header-user" 
					@mouseenter="open()" 
					@mouseleave="closeUM()"
					@keydown.escape.window="closeUM()"
					@focusin.window="! $refs.uMenu.contains($event.target) && closeUM()"
					x-id="['userMenu']">

						<!-- button or link -->
						<button 
						class="usericon" 
						type="button"
						@focus= "open()"
						:aria-expanded="showUM"
						:aria-controls="$id('userMenu')">
							<cfoutput>
								<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="64px" height="64px" viewBox="0 0 64 64" version="1.1">
									<circle fill="##FFFFFF" cx="32" width="64" height="64" cy="32" r="32"/>
									<text x="50%" y="50%" fill="##fa0114" style="color: ##fa0114; line-height: 1;font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Oxygen', 'Ubuntu', 'Fira Sans', 'Droid Sans', 'Helvetica Neue', sans-serif;" alignment-baseline="middle" text-anchor="middle" font-size="30" font-weight="600" dy=".1em" dominant-baseline="middle" >#rc.userSession.avatar#</text></svg>
							</cfoutput>
						</button>
						<cfif !rc.userSession.isEmailVerified>
							<a href="/myprofile" title="Verify your eamil" style="opacity:1;"><div class="notify-badge" style=" background-color: gold;" >!</div></a>
						</cfif>

					<!-- drop down menu -->
					<div
						x-ref="dropdownmenu"
						x-show="showUM"
						@click.outside="closeUM()"
						class="userdd box-shadow fadein"
						<!--- x-transition.origin.top.left --->
						:id="$id('userMenu')"
						style="display: none;"
						<!--- x-transition:enter="transition ease-out duration-200"
						x-transition:enter-start="opacity-0 translate-y-1 "
						x-transition:enter-end="opacity-100 translate-y-0"
						x-transition:leave="transition ease-in duration-150"
						x-transition:leave-start="opacity-100 translate-y-0"
						x-transition:leave-end="opacity-0 translate-y-1" --->
						>
						<!-- <div class="shadow-xs rounded-lg overflow-hidden"> -->
						<!-- items -->
						<div class="name">
							<cfoutput>
							<p class="emphasize">#rc.userSession.name#</p>
						</cfoutput>
						</div>
						<div class="divide"></div>
						<a href="/myprofile" class="entry">
							<!--- <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
								<path d="M17.414 2.586a2 2 0 00-2.828 0L7 10.172V13h2.828l7.586-7.586a2 2 0 000-2.828z" />
								<path fill-rule="evenodd" d="M2 6a2 2 0 012-2h4a1 1 0 010 2H4v10h10v-4a1 1 0 112 0v4a2 2 0 01-2 2H4a2 2 0 01-2-2V6z" clip-rule="evenodd" />
							  </svg> --->
							  <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" >
								<path stroke-linecap="round" stroke-linejoin="round" d="M16.862 4.487l1.687-1.688a1.875 1.875 0 112.652 2.652L10.582 16.07a4.5 4.5 0 01-1.897 1.13L6 18l.8-2.685a4.5 4.5 0 011.13-1.897l8.932-8.931zm0 0L19.5 7.125M18 14v4.75A2.25 2.25 0 0115.75 21H5.25A2.25 2.25 0 013 18.75V8.25A2.25 2.25 0 015.25 6H10" />
							  </svg>
							  
							<p>My Profile</p>
						</a>
						<a href="/myfavorites" class="entry">
							<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
								<path stroke-linecap="round" stroke-linejoin="round" d="M21 8.25c0-2.485-2.099-4.5-4.688-4.5-1.935 0-3.597 1.126-4.312 2.733-.715-1.607-2.377-2.733-4.313-2.733C5.1 3.75 3 5.765 3 8.25c0 7.22 9 12 9 12s9-4.78 9-12Z" />
							  </svg>
							<p >My Favorites</p>
						</a>
						<a href="/myoffers" class="entry">
							<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-6">
								<path stroke-linecap="round" stroke-linejoin="round" d="M19.5 14.25v-2.625a3.375 3.375 0 0 0-3.375-3.375h-1.5A1.125 1.125 0 0 1 13.5 7.125v-1.5a3.375 3.375 0 0 0-3.375-3.375H8.25m3.75 9v7.5m2.25-6.466a9.016 9.016 0 0 0-3.461-.203c-.536.072-.974.478-1.021 1.017a4.559 4.559 0 0 0-.018.402c0 .464.336.844.775.994l2.95 1.012c.44.15.775.53.775.994 0 .136-.006.27-.018.402-.047.539-.485.945-1.021 1.017a9.077 9.077 0 0 1-3.461-.203M10.5 2.25H5.625c-.621 0-1.125.504-1.125 1.125v17.25c0 .621.504 1.125 1.125 1.125h12.75c.621 0 1.125-.504 1.125-1.125V11.25a9 9 0 0 0-9-9Z" />
							  </svg>
							  
							<p >My Offers/Inquiries</p>
						</a>
						<a href="/logout" class="entry">
							<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth="1.5" stroke="currentColor" >
								<path strokeLinecap="round" strokeLinejoin="round" d="M15.75 9V5.25A2.25 2.25 0 0 0 13.5 3h-6a2.25 2.25 0 0 0-2.25 2.25v13.5A2.25 2.25 0 0 0 7.5 21h6a2.25 2.25 0 0 0 2.25-2.25V15m3 0 3-3m0 0-3-3m3 3H9" />
							  </svg>
							<p >Sign Out</p>
						</a>
						<!-- </div> -->
					</div>
				</div>
			<cfelse>
				<a href="/login">
					Log In
				</a>
				<button class="btn btn-wy o80" type="button" onclick="location.href='/register'">Register</button>
			</cfif>
			
			
		  </div>

		  <!--- menu icon --->
		<div class="header-nav" :class="{ 'align-self': showMenu }">

			<button type="button" @click.prevent="showMenu = !showMenu ">
	
				<svg id="hamburger" xmlns="http://www.w3.org/2000/svg" class="fill-current" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" x-show="!showMenu">
				<line x1="3" y1="12" x2="21" y2="12"></line>
				<line x1="3" y1="6" x2="21" y2="6"></line>
				<line x1="3" y1="18" x2="21" y2="18"></line>
				</svg>
				<svg id="closeUM-vm" xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" x-show="showMenu">
				<circle cx="12" cy="12" r="10"></circle>
				<line x1="15" y1="9" x2="9" y2="15"></line>
				<line x1="9" y1="9" x2="15" y2="15"></line>
				</svg>
	
			</button>
		</div>
		</div>
		<!--- search bar --->
		
			<!--- <div class="header-searchbar">
				
				<div id="searchbox"></div>
				<!--- <cfif local.route eq 'default'>
					<h2 class="header-title"><span style="font-style:italic;color:#ffeb00">Your source for used semiconductor and scientific equipment</span></h2>
					<!--- <h2 class="header-title"><span style="font-style:italic;color:#ffeb00">equipped to succeed</span> - start your
						search
					</h2> --->
				</cfif>	 --->
			</div> --->

			
			  
	  </header>
	  <cfoutput>
		#view( 'common/fragment/megamenu')#
	   </cfoutput>
	</div>    