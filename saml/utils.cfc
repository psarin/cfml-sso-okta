component {

    /**
    * @hint         Gets the AttributeStatement from the XML Response and translates to a ColdFusion Struct
    * @xmlResponse  xml
    * @return       Struct
    */
    public struct function buildAttributes(required xml xmlResponse){
        // setup return struct
        local.attr = {};
        try{
            // read the attributes
			local.attributes = arguments.xmlResponse.XmlChildren;
            // loop thru results and build a struct with our values
            for (attribute in local.attributes){
				// if period in attribute name break into own child struct
                if (!structIsEmpty(attribute.xmlAttributes) and find(".",attribute.xmlAttributes.name)){
                    attr[getToken(attribute.xmlAttributes.name,1,".")][getToken(attribute.xmlAttributes.name,2,".")] = attribute.xmlChildren[1].xmlText;
                } else if (!structIsEmpty(attribute.xmlAttributes)){
                    attr[attribute.xmlAttributes.name] = attribute.xmlChildren[1].xmlText;
                }
			}
        }
		catch (Any e) {
			/* Put any logic here if you want to capture*/
			writeDump(e)
		}

		// Merge in the top level attributes
		structAppend(local.attr, xmlResponse.xmlAttributes)
        return local.attr;
    }


    /**
    * @hint         Handles retrieving a value from an XML response - XML search Wrapper
    * @xmlResponse  xml
    * @xpath        string
    * @reqAttrib    boolean
    * @return       string
    * @author       http://blog.tagworldwide.com/?p=19
    */
    public function getSingleValue(required xml xmlResponse, required string xpath, boolean reqAttrib = true){
        var values= XmlSearch(arguments.xmlResponse,arguments.xpath);
        if (arguments.reqAttrib){
            if (!ArrayLen(values))
                throw(type:"saml", message:"Error: No value for: #xpath#");
        }
        if (isArray(values))
            return values[1];
        else
            return values;
	}

}