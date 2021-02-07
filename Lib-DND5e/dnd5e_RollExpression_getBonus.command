[h: rollExpression = arg (0)]
[h: bonus = json.get (rollExpression, "bonus")]
[h, if (encode (bonus) == ""): bonus = 0; ""]
[h, if (argCount() > 1): doExpansion = arg(1); doExpansion = 1]
[h: log.debug (getMacroName() + ": doExpansion = " + doExpansion)]
<!-- Force expansion to false when no token is selected -->
[h: tokenId = currentToken()]
[h, if (tokenId == ""), code: {
	[log.debug (getMacroName() + ": Skipping property expansion - no token selected")]
	[doExpansion = 0]
}; {}]

[h, if (doExpansion), code: {
	[propertyModifiers = json.get (rollExpression, "propertyModifiers")]
	[foreach (propertyModifier, propertyModifiers, ""), code: {
		[log.debug (getMacroName() + ": Evaluating " + propertyModifier)]
		<!-- These are more like expressions rather than sraight property values
			so run them through macroEval -->
		[evalMacro ("[h: propertyValue = floor (" + propertyModifier + ")]")]
		[log.debug (getMacroName() + ": propertyValue = " + propertyValue)]
		[if (isNumber (propertyValue)): bonus = bonus + propertyValue; ""]
	}]
}; {}]

[h: macro.return = bonus]