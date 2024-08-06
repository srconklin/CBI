<!DOCTYPE html>
<html lang="en" >

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no,  maximum-scale=5">
  <link rel="shortcut icon" href="/images/favicon.ico">
  <link rel="stylesheet" href="/dist/app-G2Z32QSD.css">
  <!-- Cookie Consent by FreePrivacyPolicy.com https://www.FreePrivacyPolicy.com -->
<script type="text/javascript" src="//www.freeprivacypolicy.com/public/cookie-consent/4.1.0/cookie-consent.js" charset="UTF-8"></script>
<script type="text/javascript" charset="UTF-8">
  document.addEventListener('DOMContentLoaded', function () {
  cookieconsent.run({"notice_banner_type":"simple","consent_type":"express","palette":"light","language":"en","page_load_consent_levels":["strictly-necessary"],"notice_banner_reject_button_hide":false,"preferences_center_close_button_hide":false,"page_refresh_confirmation_buttons":false,"website_name":"Capovani.com","website_privacy_policy_url":"http://127.0.0.1:8080/privacy"});
});
</script>
<noscript>Cookie Consent by <a href="https://www.freeprivacypolicy.com/">Free Privacy Policy Generator</a></noscript>
<!-- End Cookie Consent by FreePrivacyPolicy.com https://www.FreePrivacyPolicy.com -->
<!-- Below is the link that users can use to open Preferences Center to change their preferences. Do not modify the ID parameter. Place it where appropriate, style it as needed. -->
<!--- <a href="#" id="open_preferences_center">Update cookies preferences</a> --->
 <script type="text/plain" src="/dist/app-NUFWYPFS.js" type="module" data-cookie-consent="strictly-necessary" ></script>

<body x-cloak x-data="{hidden: false}" @blur-bg.window="$event.detail?hidden = true:hidden=false; window.scroll({top: 0, left: 0, behavior: 'smooth'});" :class="{ 'no-scroll': hidden }"> 
  <noscript>You need to enable JavaScript to run this app.</noscript>
  <script>if (document.documentMode)  alert('This browser is not suported.\n Please upgrade');</script>
  
  <!--- header --->
	<cfoutput>
		#view( 'common/fragment/header', { "route" =  getItem() } )#
	</cfoutput>
  
  <!--- main --->
  <main class="main" x-data="{ blurred: false }"  @blur-bg.window="$event.detail?blurred = true:blurred=false;" :class="{ 'blur-bg': blurred }">
	<cfoutput>#body#</cfoutput>
  </main>

  <!--- footer --->
  <footer class="footer">
    <div class="footer-container">

       <img alt="Capovani Brothers" style="display:inline-block;" src="/images/logo_short.png">

      <ul class="vertical footer-links">
        <li><a href="/terms">Terms</a></li>
        <!--- <li><a href="/cookie">Cookie policy</a></li> --->
        <li><a href="/privacy">Privacy</a></li>
        <li><a href="#" id="open_preferences_center">Update cookies preferences</a></li>
      </ul>

      <ul class="vertical footer-links">
        <li id="navi-1">
          <a href="/login">Log In</a>
        </li>
        <li id="navi-1">
          <a href="/faq">FAQ</a>
        </li>
        <li id="navi-1">
          <a href="/contact">Contact</a>
        </li>
        <li id="navi-2">
          <a href="/about">About</a>
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
 
 <!--- toasts --->
 <cfoutput>
  #view( 'common/fragment/toasts')#
 </cfoutput>

</body>
</html>

