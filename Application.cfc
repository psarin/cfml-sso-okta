/**
*   @output     false
*/
component{

    this.name               = "SAML_Sample_App";
    this.sessionmanagement  = true;
    this.sessiontimeout     = createTimeSpan(0,7,0,0);
	this.triggerDataMember=true;
	this.invokeImplicitAccessor=true;

	// Mappings
	this.mappings['/saml'] = getDirectoryFromPath(getCurrentTemplatePath()) & '/saml'

    // java settings
    this.javaSettings       = {
        LoadPaths       : ["/saml/jars"],
        reloadOnChange  : true,
        watchInterval   : 60
	};

    public boolean function onRequestStart(){
		request.identityProvider  = "okta";
		request.rootDir = "cfml-sso-okta/"
        request.siteURL     = "http" & (cgi.server_port_secure ? "s" : "") & ":" & "//" & cgi.server_name & ":" & cgi.server_port & "/" & request.rootDir;

		if (structKeyExists(url,"reload")){
            location("./",false);
        }

        // check if identityProvider is setup and configured
        if (!isNull(request.identityProvider)){
			try{
				data = deserializeJson(fileRead('config/#request.identityProvider#.json'));
				request.identityProviderModel =  createObject('component', 'saml.providers.' & request.identityProvider).init(argumentCollection = data)

			}catch (any e){
				request.identityProviderModel =  createObject('component', 'saml.providers.' & request.identityProvider).init()
			}
			if (isNull(request.identityProviderModel)){
				request.identityProviderModel =  createObject('component', 'saml.providers.' & request.identityProvider).init()
			}

            // relocate to admin if not completely setup
            if (!findNoCase("admin",cgi.script_name) && !request.identityProviderModel.isReady())
                location("/#request.rootDir#/admin.cfm",false);
        }

        return true;
    }

}