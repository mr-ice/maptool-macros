[h: inputString = arg(0)]
[h, if (argCount() > 1): defaultValue = arg(1); defaultValue = ""]
<!-- No matching on outer braces (ala, outter nests) -->
<!-- If we want to support nesting, we can return to this and just add some additional 
		passes until theres no match. But Im content to start off ignoring that for now -->
[h: propertyPattern = "\\{([^{}]*)\\}"]
[h: findId = strfind (inputString, propertyPattern)]
[h: findCount = getFindCount (findId)]

[h, for (match, 1, findCount + 1), code: {
	[propertyName = getGroup (findId, match, 1)]
	[log.debug (getMacroName() + ": found property name '" + propertyName + "'")]
	<!-- We may or may not be running with the help of a token. In the event we are not,
		expand the property value to 0 -->
	[propertyValue = dnd5e_Property_getPropertySafe (propertyName, defaultValue)]
	[log.debug (getMacroName() + ": propertyValue = " + propertyValue)]
	<!-- Since we know our original regex pattern excluded nested braces, 
			a simple pattern for replace is all we need -->
	[inputString = replace (inputString, "\\{" + propertyName + "\\}", propertyValue)]
}]
[h: macro.return = inputString]