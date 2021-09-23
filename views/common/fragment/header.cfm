	<!--- header --->
	<header class="header" x-data="{showMenu : false, hidden: false}" @blur-bg.window="$event.detail?hidden = true:hidden=false;" :class="{ 'header-hidden': hidden }">
		<div class="header-container">
		  <!--- 2 column  wrapper --->
		  <div class="header-column">
	
			<!--- logo --->
			<div class="header-logo">
				<a href="/">	
					<img alt="Capovani Brothers" class="block" src="/images/logo_short.png">
				</a>		
				<cfif local.route eq 'default'>
					<h3><span>C</span>apovani <span>B</span>rothers <span>I</span>nc</h3>
				</cfif>	
			</div>
			
			<!--- menu icon --->
			<div class="header-nav">
	
			  <button type="button" @click.prevent="showMenu = !showMenu ">
	
				<svg id="hamburger" xmlns="http://www.w3.org/2000/svg" class="fill-current" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" x-show="!showMenu">
				  <line x1="3" y1="12" x2="21" y2="12"></line>
				  <line x1="3" y1="6" x2="21" y2="6"></line>
				  <line x1="3" y1="18" x2="21" y2="18"></line>
				</svg>
				<svg id="close-vm" xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" x-show="showMenu">
				  <circle cx="12" cy="12" r="10"></circle>
				  <line x1="15" y1="9" x2="9" y2="15"></line>
				  <line x1="9" y1="9" x2="15" y2="15"></line>
				</svg>
	
			  </button>
			</div>
		  </div>
<!--- 	
		 <cfif local.route neq 'default'>
			<div id="searchbox" class="searchbox-abbr"></div>
		</cfif> --->

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
			<cfif structKeyExists(session, 'auth') and session.auth.isLoggedIn >
				<!--- <a href="/logout">
					<cfoutput>#session.auth.user.firstname#</cfoutput>
				</a> --->

				<div x-data="{showUM : false}" class="header-user" @mouseenter="showUM = true" @mouseleave="showUM = false">

					<!-- button or link -->
					<a class="usericon" href="#">
						<svg xmlns="http://www.w3.org/2000/svg" fill="none" stroke="currentColor" stroke-width="2"
							stroke-linecap="round" stroke-linejoin="round">
							<path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2" />
							<circle cx="12" cy="7" r="4" />
						</svg>
					</a>

					<!-- drop down menu -->
					<div x-show="showUM"
						class="userdd box-shadow"
						x-transition:enter="transition ease-out duration-200"
						x-transition:enter-start="opacity-0 translate-y-1 "
						x-transition:enter-end="opacity-100 translate-y-0"
						x-transition:leave="transition ease-in duration-150"
						x-transition:leave-start="opacity-100 translate-y-0"
						x-transition:leave-end="opacity-0 translate-y-1">
						<!-- <div class="shadow-xs rounded-lg overflow-hidden"> -->
						<!-- items -->
						<a href="" class="entry">
							<p class="emphasize">Scott Conklin</p>
						</a>
						<div class="divide"></div>
						<a href="" class="entry">
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
								<path d="M17.414 2.586a2 2 0 00-2.828 0L7 10.172V13h2.828l7.586-7.586a2 2 0 000-2.828z" />
								<path fill-rule="evenodd" d="M2 6a2 2 0 012-2h4a1 1 0 010 2H4v10h10v-4a1 1 0 112 0v4a2 2 0 01-2 2H4a2 2 0 01-2-2V6z" clip-rule="evenodd" />
							  </svg>
							<p>My Profile</p>
						</a>
					
						<a href="/logout" class="entry">
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
								<path fill-rule="evenodd" d="M3 3a1 1 0 00-1 1v12a1 1 0 102 0V4a1 1 0 00-1-1zm10.293 9.293a1 1 0 001.414 1.414l3-3a1 1 0 000-1.414l-3-3a1 1 0 10-1.414 1.414L14.586 9H7a1 1 0 100 2h7.586l-1.293 1.293z" clip-rule="evenodd" />
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
				<button class="btn btn-wy o80" type="button">Register</button>
			</cfif>
			
			
		  </div>
		</div>
		<!--- search bar --->
		
			<div class="header-searchbar">
				<cfif local.route eq 'default'>
					<h2 class="header-title"><span style="font-style:italic;color:#ffeb00">equipped to succeed</span> - start your
						search
					</h2>
				</cfif>	
				<div id="searchbox"></div>
			</div>

			
			  
	  </header>

	  