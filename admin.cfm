<cfscript>
    if (cgi.request_method == "POST"){
        request.identityProviderModel.setCompanyName(form.companyName);
        request.identityProviderModel.setConsumeUrl(form.consumeUrl);
        request.identityProviderModel.setIssuerUrl(form.issuerUrl);
        request.identityProviderModel.setIssuerID(form.issuerID);
		request.identityProviderModel.setCertificate(form.certificate);

		data = serializeJson(request.identityProviderModel)
		fileWrite("config/" & request.identityProviderModel & ".json", data)
        session.saved = true;
        sleep(250);
        location(cgi.http_referer,false);
    }
</cfscript>
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
        <cfoutput>
        <cfif structKeyExists(session,"saved")>
            <div class="alert alert-success">
                <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                Changes saved!
            </div>
            <cfset structDelete(session,"saved") />
        </cfif>
        <cfif request.identityProviderModel.isReady()>
            <div class="well well-small text-center text-success">
                <span class="glyphicon glyphicon-ok"></span> Application is ready to use, <a href="/#request.rootDir#">click here</a> to go to test request.
            </div>
        </cfif>
		<form role="form" method="post" class="simple-validation">
            <div class="form-group">
                <label for="companyName">Identity Provider</label>
                <input type="text" class="form-control" id="companyName" name="companyName" disabled value="#encodeForHTML(request.identityProvider)#">
                <p class="help-block">
                    The selected identity provider, as specified in Application.cfc.
                </p>
            </div>
            <div class="form-group">
                <label for="companyName">Company Name</label>
                <input type="text" class="form-control" id="companyName" name="companyName" placeholder="Enter Company Name" value="#encodeForHTML(request.identityProviderModel.getCompanyName())#">
                <p class="help-block">
                    This is not required for SAML, only here for example if you were to add to multi-tenant app, possibly tie into Company table.
                </p>
            </div>
            <div class="form-group required">
                <label for="consumeUrl">Consume URL</label>
                <input type="text" class="form-control" id="consumeUrl" name="consumeUrl" placeholder="Enter Consume URL (ie: #request.siteURL#consume/)" value="#encodeForHTML(request.identityProviderModel.getConsumeUrl())#">
                <p class="help-block">
					The URL of the consume file / service for this app, to which the Identity Provider redirects after authentication and POSTs the SAML Response. This is usually configured on the Identity Provider side but if you supply it here, this value will be checked against the SAML Response from provider.
                </p>
            </div>
            <div class="form-group required">
                <label for="issuerUrl">Issuer</label>
                <input type="text" class="form-control" id="issuerUrl" name="issuerUrl" placeholder="Enter Issuer (ie: #request.siteURL#)" value="#encodeForHTML(request.identityProviderModel.getIssuerUrl())#">
                <p class="help-block">
                    The issuer of the authentication request. This would usually be the URL of the issuing web application and this value is used to post to the proper URL.
                </p>
            </div>
            <div class="form-group required">
                <label for="issuerID">Issuer ID</label>
                <input type="text" class="form-control" id="issuerID" name="issuerID" placeholder="Enter Issuer ID" value="#encodeForHTML(request.identityProviderModel.getIssuerID())#">
                <p class="help-block">
                    The ID for this app at the Identity Provider and this value is used to post to the proper URL. You can find
                    this value after creating the App and clicking on <strong class="text-info">"Single Sign-On"</strong> tab.
                </p>
            </div>
            <div class="form-group required">
                <label for="certificate">X.509 Certificate</label>
                <textarea class="form-control" id="certificate" name="certificate" rows="10" placeholder="Enter Certificate Text">#encodeForHTML(request.identityProviderModel.getCertificate())#</textarea>
                <p class="help-block">
                    Enter the Certificate Content used for this App on OneLogin. This can be found under the <strong class="text-info">"Single Sign-On"</strong> tab. Look for the
                    <strong class="text-info">"X.509 Certificate"</strong> and click on <strong class="text-info">"View Details"</strong>. On the following page you will see
                    a text box with the value to enter here.
                </p>
            </div>
            <span class="frmPrc" style="display:none;">
                <button class="btn btn-default" type="button" disabled="disabled">
                    <i class="fa fa-spin fa-spinner"></i> Saving ...
                </button>
            </span>
            <span class="frmBtn">
                <button type="submit" class="btn btn-primary">Save Settings</button>
            </span>
        </form>
        </cfoutput>
	</div>
	<cfoutput>
		<script src="//code.jquery.com/jquery-1.11.1.min.js"></script>
		<script src="//netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js"></script>
		<script src="/#request.rootDir#/includes/js/scripts.js"></script>
		<script src="/#request.rootDir#/includes/js/validation.min.js"></script>
	</cfoutput>
</body>
</html>