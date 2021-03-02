[h: encodedPath = arg (0)]
[h: jsonVal = arg (1)]
[h, if (argCount() > 2): isArray = arg (2); isArray = 0]
[h: log.debug (getMacroName() + ": encodedPath = " + 
		encodedPath + "; jsonVal = " + jsonVal + "; isArray = " + isArray)]
[h: path = decode (encodedPath)]
[h: log.debug (getMacroName() + ": path = " + path)]
[h, if( isArray ), code: {
	[h: cancel = input( strformat(
	"newElement | %s | %s ", "", "Enter the value for the new array element"
	) )]
	[h: abort( cancel )]
	[if (encode (path) == "%5B%5D"): jsonVal = json.append (jsonVal, newElement);
			jsonVal = json.path.add (jsonVal, path, newElement)]
}; {
	[h: cancel = input(
		".| Enter the new object element: || LABEL | SPAN=TRUE",
		"newKey | key | Key",
		"newValue || Value"
	)]
	[h: abort( cancel )]
	[log.warn ("encodedPath = " + encodedPath)]
	[if (encodedPath == "%5B%27%27%5D"): jsonVal = json.set (jsonVal, newKey, newValue);
			jsonVal = json.path.put (jsonVal, path, newKey, newValue)]
}]
[h: macro.return = jsonVal]