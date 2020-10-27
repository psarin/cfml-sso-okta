<cfscript>
	function getDebugEncodedSAMLResponse(){
		// INSERT your debug encoded response here to run test
		return "";
	}


	function runTest(debug){
		var encodedSAMLResponse = debug?getDebugEncodedSAMLResponse():arguments.SAMLResponse

		writeDump(var=objSAML.buildPacket(encodedSAMLResponse))
	}

	objSAML = new saml.saml()

	debug = true
	runTest(debug)
</cfscript>