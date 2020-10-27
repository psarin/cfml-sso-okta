component {

	objUtils = new utils()


	public function buildSignature(required string samlResponse){

		// Get the relevant assertion block
		var samlAssertionBlock = objUtils.getSingleValue(samlResponse, "//*[local-name()='Assertion' and namespace-uri()='urn:oasis:names:tc:SAML:2.0:assertion']")
		// Need to set the ID attribute to use as reference as per https://stackoverflow.com/questions/63615930/soap-xml-ws-security-signature-verification
		samlAssertionBlock.setIdAttributeNS("", "ID", true);

		// Initialize the library, needs to be done at least once and doing more than once won't cause problems
		Init = CreateObject("Java", "org.apache.xml.security.Init", "./jars/").Init().init();
		// Using the samlAssertionBlock Signature, generate a Java XML Security Signature
		var samlAssertionSignatureBlock = samlAssertionBlock.Signature[1];
		return CreateObject("java", "org.apache.xml.security.signature.XMLSignature", "./jars/").init(samlAssertionSignatureBlock,"");
	}


    /**
    * @hint         Handles building and validating a SAML response into a ColdFusion Struct
    * @xmlResponse  boolean
    * @return       Struct
    */
    public function verifySignature(required xmlSignature, required certificate ){

		return xmlSignature.checkSignatureValue(certificate);
	}

}