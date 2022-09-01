<!DOCTYPE html>
<html lang="en" >

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no,  maximum-scale=5">
  <link rel="shortcut icon" href="/images/favicon.ico">
 <!--- dev --->
 <link rel="stylesheet" href="/dist/styles.css">
 <script src="/dist/app.js" type="module"></script>
 <!--- prod --->
 <!--- <link rel="stylesheet" href="/dist/index.0f205b7a.css">  --->
  

<body x-cloak x-data="{hidden: false}" @blur-bg.window="$event.detail?hidden = true:hidden=false; window.scroll({top: 0, left: 0, behavior: 'smooth'});" :class="{ 'no-scroll': hidden }"> 
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
 <script src="https://www.google.com/recaptcha/api.js?render=6LevHMkfAAAAAInPcjzzNLUUgvmKoeDzcIg4G6qS"></script>
 
</body>
</html>
