
<!DOCTYPE html>
<html lang="en" >

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no,  maximum-scale=1, user-scalable=0">

  <!--- <link rel="manifest" href="/manifest.webmanifest"> --->
  <link rel="shortcut icon" href="/images/favicon.ico">
  <!--- <link rel="stylesheet" href="https://cdn.jsdelivr.net/combine/npm/modern-normalize@1/modern-normalize.min.css,npm/suitcss-base@5/lib/base.min.css"> --->
<!--- dev --->
<link rel="stylesheet" href="/dist/styles.css">
<!--- prod --->
<!--- <link rel="stylesheet" href="/dist/index.0f205b7a.css">  --->
<!--- <link rel="stylesheet" href="/dist/index.d01acb1f.css"> --->
 
 <title>CBI - Login</title>

<body class="login">
	
<cfoutput>

	<div class="container">
					
		<!-- flex row -->
		<div class="login-wrapper">
			
			<div class="login-logo">
				<img alt="CBI" src="images/logo_short.png">
			</div>

			<div class="login-panel box-shadow2">
				
				<div class="login-title">
				  <h1>SIGN IN</h1>
				</div>
				
				<cfif structKeyExists(rc, 'message')>
					<div style="margin-top: 1rem; margin-bottom: 1rem;"> 
						#view( 'common/fragment/errorbox', { messages =  rc.message } )#
					</div>
				</cfif>
				
				<div>
				
					<form action="/login" method="post">
						<div class="form-row">
							<input 
								id="username"
								name="username"
								class="form-control" 
								type="text" 
								maxlength="50"
								placeholder="username or email" 
								title="enter your email or username to login" 
								required
							/>
						</div>
						<div class="form-row">
							<input
								id="password" 
								name="password" 
								class="form-control" 
								type="password"
								maxlength="25"
								placeholder="password" 
								title="enter your password" 
								required/>
						</div>	
				
					 <div>
					  <p>
						<a href="/forgotpassword" class="login-fp">Forgot Password?</a>
					  </p>
					</div>
				
					<button 
						id="login"
						name="login"
						type="submit" 
						class="btn btn-red login-submit"
						title="login"
						>
						Log In
					</button>
					<cfif structKeyExists(rc, 'destination')>
					 	<input type="hidden" value="#rc.destination#" name="destination" />
					</cfif>
				  </form>
				</div>

				<div class="login-footnote flex justify-center mx-3 mt-1">
				  <p>Don't have an account? 
					<a href="/register">Sign up</a>
				  </p>
				</div>
			  </div>

		</div>

</cfoutput>
</body>

</html>
