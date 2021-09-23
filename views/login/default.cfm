
<!DOCTYPE html>
<html lang="en" >

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no,  maximum-scale=1, user-scalable=0">

  <!--- <link rel="manifest" href="/manifest.webmanifest"> --->
  <link rel="shortcut icon" href="/images/favicon.ico">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/combine/npm/modern-normalize@1/modern-normalize.min.css,npm/suitcss-base@5/lib/base.min.css">
<!--- dev --->
<!--- <link rel="stylesheet" href="/dist/styles.css"> --->
<!--- prod --->
<link rel="stylesheet" href="/dist/index.c1362ebd.css">
  
 <title>CBI - Login</title>

<body class="login">
	
<cfoutput>

	<div class="container">
					
		<!-- flex row -->
		<div class="login-wrapper">
			
			<div class="login-logo">
				<img alt="CBI" src="images/logo_short.png">
			</div>

			<div class="login-panel box-shadow">
				
				<div class="login-title">
				  <h1>LOG IN</h1>
				</div>
				
				<cfif structKeyExists(rc, 'message')>
					#view( 'common/fragment/errorbox', { messages =  rc.message } )#
				</cfif>
				
				<div>
				
					<form action="/login" method="post">
						<div class="form-row">
							<input class="form-control" type="text" placeholder="username" name="username"/>
						</div>
						<div class="form-row">
							<input class="form-control" type="password" placeholder="password" name="password"/>
						</div>	
				
					 <div>
					  <p>
						<a href="##" class="login-fp">Forgot Password?</a>
					  </p>
					</div>
				
					<button type="submit" class="btn btn-red login-submit">SIGN IN</button>
					<cfif structKeyExists(rc, 'destination')>
					 	<input type="hidden" value="#rc.destination#" name="destination" />
					</cfif>
				  </form>
				</div>

				<div class="login-footnote flex justify-center mx-3 mt-1">
				  <p>Don't have an account? 
					<a href="##">Sign up</a>
				  </p>
				</div>
			  </div>

		</div>

</cfoutput>
</body>

</html>
