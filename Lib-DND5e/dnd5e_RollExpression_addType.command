[h: rollExpression = arg (0)]
<!-- types are JSON objects now, but there might be some lingering code hanging
	around acting like their strings. So in that event, lets coerce it to
	an object and add some logging to help us out -->
[h: types = json.get (rollExpression, "types")]
[h, for (i, 1, argCount()), code: {
	[type = arg (i)]	
	[if (json.type (type) != "OBJECT"), code: {
		[log.warn (getMacroName() + ": Provided type was a string: " + type)]
		[log.warn ("rollExpression: " + rollExpression)]
		[type = json.set ("", "type", type)]
	}; {
		[log.debug (getMacroName() + ": type = " + type)]
	}]

	[typeName = json.get (type, "type")]
	[types = json.set (types, typeName, type)]
	<!-- A pretty weak-ass visitor pattern, but it does the job -->
	[visitor = json.get (type, "visitor")]
	[if (json.isEmpty (visitor)): visitor = "{}"; ""]
	[log.debug (getMacroName() + ": " + json.get (type, "type") + " - visitor = " + visitor)]
	[rollExpression = json.merge (rollExpression, visitor)]
}]
[h: rollExpression = json.set (rollExpression, "types", types)]
[h: rollExpression = dnd5e_RollExpression_compileTypeNames (rollExpression)]
[h: macro.return = rollExpression]