<cfscript>
  try{
	isssuerFinalUrl = request.identityProviderModel.getRedirectToIdentityProviderUrl()

    // now send to identity provider
    location ( isssuerFinalUrl, false);
  }
catch(Any e){
    writeDump(e);
}
</cfscript>