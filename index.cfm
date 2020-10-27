<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
	<title>SAML Login - One Login</title>
	<cfoutput>
		<link rel="shortcut icon" type="image/png" href="/favicon.png">
		<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css">
		<link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/font-awesome/4.1.0/css/font-awesome.min.css">
		<link rel="stylesheet" href="//fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,600,700">
		<link rel="stylesheet" href="/#request.rootDir#/includes/css/theme.css">
	</cfoutput>
</head>
<body>
    <div class="container">
        <!--- APP IS READY - SHOW FORM --->
		<cfif !isNull(request.identityProvider)>
			<cfoutput>
				<cfset postURL = '/' & request.rootDir & '/post.cfm' />

				<form action="#postURL#" class="form-signin text-center simple-validation" role="form" method="post">
					<h2 class="form-signin-heading text-info">SAML Login Sample</h2>
					<p>
						Click below to login using #request.identityProvider#.
					</p>
					<span class="frmPrc" style="display:none;">
						<button class="btn btn-lg btn-default btn-block" type="button" disabled="disabled" style="line-height:35px;">
							<i class="fa fa-spin fa-spinner"></i> PROCESSING
						</button>
					</span>
					<span class="frmBtn">
						<cfswitch expression = "#request.identityProvider#">
							<cfcase value="okta">
								<button class="btn btn-lg btn-default btn-block" type="submit">
								<!--- 							<img src="#request.siteURL#/includes/img/logo-onelogin.png" /> --->
									<img src="#request.siteURL#/includes/img/logo-okta.svg" style="width:100px;" />
								</button>
							</cfcase>
							<cfcase value="onelogin">
								<button class="btn btn-lg btn-default btn-block" type="submit">
									<img src="#request.siteURL#/includes/img/logo-onelogin.png" />
								</button>
							</cfcase>
						</cfswitch>
					</span>
					<p>
						<a href="/#request.rootDir#/admin.cfm">Click here to edit the identity provider settings</a>
						<br /><br />
						<a href="http://youtu.be/VxS86G4hD-k" class="text-danger" target="_blank">Click here to view demo video</a>
					</p>
				</form>
			</cfoutput>
		<cfelse>
        <!--- SHOW SET UP INFO --->
            <div class="well lead setup-instructions">
                <h1>SAML Login Sample Setup Required</h1>
                <p>
					Welcome to the SAML Sample Application. To begin, you must specify the identify provider in Application.cfc.<BR/>
					<pre>request.identityProvider = "okta"</pre>
					Once complete, reload this page and you
                    will be directed to the configuration page.
                </p>
            </div>
        </cfif>
	</div>
	<cfoutput>
		<script src="//code.jquery.com/jquery-1.11.1.min.js"></script>
		<script src="//netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js"></script>
		<script src="/#request.rootDir#/includes/js/scripts.js"></script>
		<script src="/#request.rootDir#/includes/js/validation.min.js"></script>
	</cfoutput>
</body>
</html>