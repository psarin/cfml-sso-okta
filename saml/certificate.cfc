component {

	function getCertInfo(string filePath,
							Object idProviderModel){

		var certinfo

		if (isNull(filePath)){
			certinfo = idProviderModel.getCertificate()
		}else{
			certinfo = fileRead(filePath)
		}

		certinfo = replaceList(certinfo, '-----BEGIN CERTIFICATE-----,-----END CERTIFICATE-----', '')

		return certinfo;
	}

	function generateCertificate(required string certInfo){
		// Load the public certificate we have, to be used to verify that the xmlSignature has been correctly signed and not altered
		// TODO: add verification that certificate provided in SAML response is the same as our certificate
		var certificateFactory = createObject("java", "java.security.cert.CertificateFactory").getInstance('X.509')
		var byteArrayInputStream  = createObject("java","java.io.ByteArrayInputStream").init( ToBinary(trim(certInfo)));
		var ourCertificate = certificateFactory.generateCertificate( byteArrayInputStream)

		return ourCertificate
	}
}