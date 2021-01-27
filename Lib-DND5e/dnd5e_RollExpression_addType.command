[h: rollExpression = arg (0)]
<!-- types are JSON objects now, but there might be some lingering code hanging
	around acting like their strings. So in that event, lets coerce it to
	an object and add some logging to help us out -->
[h: type = arg (1)]
[h, if (json.type (type) != "OBJECT"), code: {
	[log.warn (getMacroName() + ": Provided type was a string: " + type)]
	[log.warn ("rollExpression: " + rollExpression)]
	[type = json.set ("", "type", type)]
}; {
	[log.debug (getMacroName() + ": type = " + type)]
	}]
[h: types = json.get (rollExpression, "types")]
[h: types = json.append (types, type)]
<!-- A pretty weak-ass visitor pattern, but it does the job -->
[h: visitor = json.get (type, "visitor")]
[h, if (json.isEmpty (visitor)): visitor = "{}"; ""]
[h: log.debug (getMacroName() + ": " + json.get (type, "type") + " - visitor = " + visitor)]
[h: rollExpression = json.merge (rollExpression, visitor)] 
[h: macro.return = json.set (rollExpression, "types", types)]