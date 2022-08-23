<!DOCTYPE html>
<html lang="en" >

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no,  maximum-scale=5">

  <!--- <link rel="manifest" href="/dist/manifest.webmanifest"> --->
  <link rel="shortcut icon" href="/images/favicon.ico">
  <!--- <link rel="stylesheet" href="https://cdn.jsdelivr.net/combine/npm/modern-normalize@1/modern-normalize.min.css,npm/suitcss-base@5/lib/base.min.css,npm/instantsearch.css@7/themes/algolia-min.min.css"> --->
  <!--- <link rel="stylesheet" href="https://cdn.jsdelivr.net/combine/npm/modern-normalize@1,npm/suitcss-base@5/index.min.css,npm/instantsearch.css@7/themes/algolia-min.min.css"> --->
  <!--- <link rel="stylesheet" href="https://cdn.jsdelivr.net/combine/npm/modern-normalize@1/modern-normalize.min.css,npm/suitcss-base@5/lib/base.min.css,npm/instantsearch.css@7/themes/algolia-min.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/intl-tel-input@17/build/css/intlTelInput.min.css"> --->
 <!--- dev --->
 <link rel="stylesheet" href="/dist/styles.css">
 <script src="/dist/app.js" type="module"></script>
 <!--- prod --->

 <!--- <link rel="stylesheet" href="/dist/index.0f205b7a.css">  --->
  

<body  x-data="{hidden: false}" @blur-bg.window="$event.detail?hidden = true:hidden=false; window.scroll({top: 0, left: 0, behavior: 'smooth'});" :class="{ 'no-scroll': hidden }"> 
  <noscript>You need to enable JavaScript to run this app.</noscript>
  <script>if (document.documentMode)  alert('This browser is not suported.\n Please upgrade');</script>
  
	<cfoutput>
		#view( 'common/fragment/header', { "route" =  getItem() } )#
	</cfoutput>

  <cfoutput>
    #view( 'common/fragment/megamenu')#
   </cfoutput>
   
  <main class="main" x-data="{ blurred: false }"  @blur-bg.window="$event.detail?blurred = true:blurred=false;" :class="{ 'blur-bg': blurred }">
	<cfoutput>#body#</cfoutput>
  </main>

  <!--- footer --->
  <footer class="footer">
    <div class="container footer-container">

      <div>
        <img alt="Capovani Brothers" class="block" src="/images/logo_short.png">
      </div>

      <ul class="vertical footer-links">
        <li><a href="/disclaimer">Disclaimer</a></li>
        <li><a href="/cookie">Cookie policy</a></li>
        <li><a href="/privacy">Privacy</a></li>
      </ul>

      <ul class="vertical footer-links">
        <li id="navi-1">
          <a href="#">Log In</a>
        </li>
        <li id="navi-1">
          <a href="#">FAQ</a>
  
        </li>
        <li id="navi-1">
          <a href="#">Contact</a>
        </li>
        <li id="navi-2">
          <a href="#">About</a>
        </li>
      </ul>

      <div class="footer-address">
        <p>Capovani Brothers Inc.</p>
        <p>704 Prestige Parkway</p>
        <p>Scotia, NY 12302 </p>
        <p>phone: 518.346.8347</p>
        <p>fax: 518.381.9578 </p>
      </div>

    </div>

  </footer>

 <!--- <script src="https://cdn.jsdelivr.net/combine/npm/algoliasearch@4/dist/algoliasearch.umd.min.js,npm/instantsearch.js@4/dist/instantsearch.production.min.js,npm/@ryangjchandler/spruce@2.x.x/dist/spruce.umd.js,npm/alpinejs@2,npm/intl-tel-input@17/build/js/intlTelInput.min.js"></script>  --->
<!--- <script src="https://cdn.jsdelivr.net/combine/npm/instantsearch.js@4.17.0,npm/algoliasearch@4.9.0,npm/@ryangjchandler/spruce@2.x.x/dist/spruce.umd.js,npm/alpinejs@2,npm/intl-tel-input@17/build/js/intlTelInput.min.js"></script>  --->

 <script src="https://www.google.com/recaptcha/api.js?render=6LevHMkfAAAAAInPcjzzNLUUgvmKoeDzcIg4G6qS"></script>
 
 <!--- 
  upgrades
  alpine 3.x.x 
  npm/alpinejs@3.10.3/dist/module.cjs.min.js
  focus plugin
  npm/@alpinejs/focus@3.10.3

  bundle
  https://cdn.jsdelivr.net/combine/npm/alpinejs@3.10.3,npm/@alpinejs/focus@3.10.3

  --->
 <!--- <script src="https://cdn.jsdelivr.net/combine/npm/algoliasearch@4,npm/instantsearch.js@4.37.2/dist/instantsearch.production.min.js,npm/intl-tel-input@17/build/js/intlTelInput.min.js"></script> 
 <!--- <script src="https://cdn.jsdelivr.net/combine/npm/algoliasearch@4,npm/instantsearch.js@4.37.2/dist/instantsearch.production.min.js,npm/@ryangjchandler/spruce@2,npm/alpinejs@2,npm/intl-tel-input@17/build/js/intlTelInput.min.js"></script>  --->
 <script src="https://unpkg.com/smoothscroll-polyfill@0.4.4/dist/smoothscroll.js"></script>
 <!-- Alpine Plugins -->
 <script defer src="https://unpkg.com/@alpinejs/focus@3.10.3/dist/cdn.min.js"></script>
 <!-- Alpine Core -->
 <script defer src="https://unpkg.com/alpinejs@3.10.3/dist/cdn.min.js"></script> --->

 <!--- dev --->
 <!--- <script src="/dist/app.js" ></script> --->
    
  <!--- prod --->
  <!--- <script src="/dist/index.bdc52d37.js" type="module"></script><script src="/dist/index.f8dbd7f8.js" nomodule="" defer></script> --->
  <!--- <script src="/dist/index.49c23201.js" type="module"></script><script src="/dist/index.82e3cb91.js" nomodule="" defer> --->

</body>

</html>
