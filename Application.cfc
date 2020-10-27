/**
*   @output     false
*/
component{

    this.name               = "OneLogin_SAML_1.0";
    this.sessionmanagement  = true;
    this.sessiontimeout     = createTimeSpan(0,7,0,0);
    this.datasource         = "onelogin_saml_example";
	this.triggerDataMember=true;
	this.invokeImplicitAccessor=true;

    // java settings
    this.javaSettings       = {
        LoadPaths       : ["/bin"],
        reloadOnChange  : true,
        watchInterval   : 60
    };

	this.mappings['/saml'] = getDirectoryFromPath(getCurrentTemplatePath()) & '/saml'

    public boolean function onRequestStart(){
		request.identityProvider  = "okta";
		request.rootDir = "cfml-sso-okta/"
        request.siteURL     = "http" & (cgi.server_port_secure ? "s" : "") & ":" & "//" & cgi.server_name & ":" & cgi.server_port & "/" & request.rootDir;

		if (structKeyExists(url,"reload")){
            location("./",false);
        }

        // check if company is setup and configured
        if (!isNull(request.identityProvider)){
			try{
				data = deserializeJson(fileRead('config/#request.identityProvider#.json'));
				request.company =  createObject('component', 'saml.providers.' & request.identityProvider).init(argumentCollection = data)

			}catch (any e){
				request.company =  createObject('component', 'saml.providers.' & request.identityProvider).init()
			}
			if (isNull(request.company)){
				request.company =  createObject('component', 'saml.providers.' & request.identityProvider).init()
			}

            // relocate to admin if not completely setup
            if (!findNoCase("admin",cgi.script_name) && !request.company.isReady())
                location("/#request.rootDir#/admin.cfm",false);
        }

        return true;
    }

}