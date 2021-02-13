[h: expression = arg(0)]
[h: argType = json.type (arg(1))]
[h, if (argType == "OBJECT"): 
		findType = json.get (arg(1), "type");
		findType = arg (1)]

[h: log.debug (getMacroName() + ": expression = " + expression + "; findType = " + findType)]
[h: types = json.merge ("[]", 
						dnd5e_RollExpression_getExpressionType (expression),
						dnd5e_RollExpression_getTypeNames (expression))]
[h: hasType = 0]
[h, foreach (type, types), code: {
	[h, if (type == findType): hasType = 1; ""]
}]
[h: log.debug (getMacroName() + ": hasType = " + hasType)]
[h: macro.return = hasType]