[h: propertyName = arg(0)]
[h, if (argCount() > 1): defaultValue = arg(1); defaultValue = ""]
[h: log.debug (getMacroname() + ": propertyName = " + propertyName + 
		"; defaultValue = " + defaultValue)]
[h: propertyValue = defaultValue]
[h: currentTokenId = currentToken()]
[h: log.debug (getMacroName() + ": currentTokenId = " + currentTokenId)]
[h, if (currentTokenId != ""), code: {
	[propertyValue = getProperty (propertyName)]
	[log.debug (getMacroName() + ": token property value = " + propertyValue)]
	[if (encode (propertyValue) == ""): property = defaultValue; ""]
}; {}]
[h: macro.return = propertyValue]