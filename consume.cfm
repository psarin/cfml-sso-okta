<cfscript>

	if (!isNull(form) && !isNull(form.SAMLResponse)){
		encodedSAMLResponse = form.SAMLResponse
		objSaml = new saml.saml(argumentCollection = {
			idProvider: request.identityProvider,
			idProviderModel: request.identityProviderModel
		})
		samlResponse = objSAML.buildPacket(encodedSAMLResponse)
	}else{
		samlResponse = null
	}

</cfscript>

<!--- DEBUG PURPOSES --->
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
		<link rel="stylesheet" href="//fonts.googleapis.com/css?family=Source+Code+Pro">
		<link rel="stylesheet" href="/#request.rootDir#/includes/css/theme.css">
	</cfoutput>
</head>
<body>
	<cfoutput>
	<cfif isNull(samlResponse)>
		<div class="container">
			<div class="row">
				<div class="col-xs-10">
					<div class="alert alert-danger alert-block">
						No response received from service provider!
					</div>
				</div>
				<div class="col-xs-2">
					<a href="/#request.rootDir#" class="btn btn-default">Return to Initiator Page</a>
				</div>
			</div>
		</div>
	<cfelse>
		<div class="container">
			<div class="row">
				<div class="col-xs-10">
					<cfif samlResponse.verifications.signature>
						<div class="alert alert-success alert-block">
							This is a good response, at this point you would simply validate the email we receive back as a user in the
							database. If the user is not in the database you can opt to crawl the values returned in the XML and create
							a user on the fly.
							<br /><br />
							This request is valid until <strong>#dateTimeFormat(samlResponse.conditions.notOnOrAfter,"yyyy/mm/dd HH:nn")# local time</strong>, since we are
							still in a <strong>POST</strong> state, you can just hit the refresh button to retry after the time specified to see
							the conditions of the request invalidate.
						</div>
					<cfelse>
						<div class="alert alert-danger alert-block">
							This is not a valid response, review below to see why it failed.
						</div>
					</cfif>
				</div>
				<div class="col-xs-2">
					<a href="/#request.rootDir#" class="btn btn-default">Return to Initiator Page</a>
				</div>
			</div>
			<table class="table">
				<colgroup>
					<col width="380">
				</colgroup>
				<tr>
					<th>Is the response valid for time #dateTimeFormat(Now(),"yyyy/mm/dd HH:nn")# local time?</th>
					<td>
						<cfif samlResponse.verifications.signature && samlResponse.verifications.conditions.NotBefore && samlResponse.verifications.conditions.notOnOrAfter>
							<strong class="text-success"><span class="glyphicon glyphicon-ok"></span> Passed</strong>
						<cfelse>
							<strong class="text-danger"><span class="glyphicon glyphicon-remove"></span> Failed</strong>
						</cfif>
					</td>
				</tr>
				<tr>
					<th>Is response signed correctly (certificate check)?</th>
					<td>
						<cfif samlResponse.verifications.signature>
							<strong class="text-success"><span class="glyphicon glyphicon-ok"></span> Passed</strong>
						<cfelse>
							<strong class="text-danger"><span class="glyphicon glyphicon-remove"></span> Failed</strong>
						</cfif>
					</td>
				</tr>
				<cfif samlResponse.verifications.signature>
					<tr>
						<th>The user to check on our end is</th>
						<td>#samlResponse.subject.userID#</td>
					</tr>
					<tr>
						<th>The conditions of this request are</th>
						<td>
							<dl>
								<dt>Not Before</dt>
								<dd>
									#dateTimeFormat(samlResponse.conditions.notBefore,"yyyy/mm/dd HH:nn")# EST
									<cfif samlResponse.verifications.conditions.NotBefore>
										<strong class="text-success"><span class="glyphicon glyphicon-ok"></span> Passed</strong>
									<cfelse>
										<strong class="text-danger"><span class="glyphicon glyphicon-remove"></span> Failed</strong>
									</cfif>
								</dd>
								<dt>Not On Or After</dt>
								<dd>
									#dateTimeFormat(samlResponse.conditions.notOnOrAfter,"yyyy/mm/dd HH:nn")# EST
									<cfif samlResponse.verifications.conditions.notOnOrAfter>
										<strong class="text-success"><span class="glyphicon glyphicon-ok"></span> Passed</strong>
									<cfelse>
										<strong class="text-danger"><span class="glyphicon glyphicon-remove"></span> Failed</strong>
									</cfif>
								</dd>
							</dl>
						</td>
					</tr>
					<tr>
						<th>The attributes of the user returned are</th>
						<td><cfdump var="#samlResponse.subject#" /></td>
					</tr>
				</cfif>
			</table>
			<div class="well">
			<pre>#encodeForHTML(reReplace(samlResponse.response,"(<saml|<ds)",chr(10) & "\1","ALL"))#</pre>
			</div>
		</div>
	</cfif>
    </cfoutput>
</body>
</html>