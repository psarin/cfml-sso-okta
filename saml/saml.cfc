/**
* @output       false
* @accessors    true
*/
component{

	objSignature = new signature()
	objCertificate = new certificate()
	objUtils = new utils()

    /**
    * @type struct
    * @hint Name of IdProvider, to be used to get correct settings
	*/
	property name="idProvider" type="string";
	/**
    * @type struct
    * @hint Contains the config to be used in XML parsing to get signature, assertion, subject, etc blocks
    */
	property name="signatureConfig" type="struct";
    /**
    * @type struct
    * @hint Contains the conditions returned in a valid response
    */
	property name="conditions" type="struct";

    function init(){
		this.signatureConfig = {
			localName: 'Assertion',
			namespaceUri: 'urn:oasis:names:tc:SAML:2.0:assertion'
		}
        return this;
	}

	function buildPacket(required string encodedSAMLResponse){

		var objSAMLDecoder = new decoder();

		// Decode the encrypted SAML response
		var samlResponse = objSAMLDecoder.decodeSAMLResponse(encodedSAMLResponse)

		var issuer = getIssuer(samlResponse)
		var conditions = getConditions(samlResponse)
		var areConditionsValid = verifyPacket(conditions)

		var subject = getSubject(samlResponse)

		var isValidSignature = objSignature.verifySignature(argumentCollection = {
			xmlSignature: objSignature.buildSignature(samlResponse),
			certificate: objCertificate.generateCertificate()
		})

		return {
			verifications: {
				signature: isValidSignature,
				conditions: areConditionsValid
			},
			issuer: issuer,
			subject: subject,
			conditions: conditions,
			response: samlResponse
		}
	}

	function getIssuer(required string samlResponse){

		var samlIssuerBlock = objUtils.getSingleValue(samlResponse, "//*[local-name()='Issuer' and namespace-uri()='urn:oasis:names:tc:SAML:2.0:assertion']")
		var issuer = samlIssuerBlock.xmlText

		return issuer
	}

	function getConditions(required string samlResponse){

		// Get the relevant conditions block
		var samlConditionsBlock = objUtils.getSingleValue(samlResponse, "//*[local-name()='Conditions' and namespace-uri()='urn:oasis:names:tc:SAML:2.0:assertion']")
		var conditions = objUtils.buildAttributes(samlConditionsBlock)
		conditions.now = Now()
		return conditions
	}

	function getSubject(required string samlResponse){

		// Get the relevant conditions block
		var samlSubjectBlock = objUtils.getSingleValue(samlResponse, "//*[local-name()='Subject' and namespace-uri()='urn:oasis:names:tc:SAML:2.0:assertion']")
		var userId = samlSubjectBlock.NameId.xmlText

		return {
			userID: userId
		}
	}


    /**
    * @hint         Validates the Date Values passed in the SAML Response to Local Time
    * @xmlResponse  xml
    * @return       Struct
    */
    private function verifyPacket(required struct samlPacket){
        return {
            "NotBefore"     : DateCompare(arguments.samlPacket.now, arguments.samlPacket.NotBefore,"s") == 1 ? true : false,
            "NotOnOrAfter"  : DateCompare(arguments.samlPacket.now, arguments.samlPacket.NotOnOrAfter,"s") >= 0 ? false : true
        }
    }



}