<!---

Reading, decoding and inflating a SAML XML respone with Coldfusion

This script is heavily inspired by the following posts:
- Ciarán Archer : https://flydillonfly.wordpress.com/2011/06/28/using-coldfusion-to-unzip-a-gzip-base64-string/
- Ryan Loda : http://www.coderanch.com/t/545270/java/java/Decode-SAML-Request
- Ben Nadel : http://www.bennadel.com/blog/1343-converting-a-base64-value-back-into-a-string-using-coldfusion.htm

--->

component {

	public function decodeSAMLResponse (string samlResponse= "") hint="Decode a SAML authentication response from Azure AD"{

		var cleanSAMLResponse = replaceNoCase(arguments.SAMLResponse,"SAMLResponse=","","all");
		var xmlStr = createObject("java", "javax.xml.bind.DatatypeConverter", "/orrms/server/jars/").parseBase64Binary(base64urldecode(cleanSAMLResponse));
		xmlStr = ToString(xmlStr,"utf-8");

		// Soemtimes a few xtra characters after the closing tag
		var cnt = find("</samlp:Response>",xmlStr);
		if (cnt GT 0 AND len(xmlStr) GT cnt+16){
			xmlStr = left(xmlStr,cnt+16);
		}
		return xmlStr;
	}

	public function base64urldecode (string samlResponse= "") hint="The Azure response contained a few URL encodings that weren't getting converted properly by 'normal' CF URL decode functions."{

		var value = replace(arguments.SAMLResponse, "%2B", "+", "all" );
		value = replace(value, "%3D", "=", "all" );
		return value;
	}
}