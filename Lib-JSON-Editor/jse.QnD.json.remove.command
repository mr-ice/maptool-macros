[h: encodedPath = arg (0)]
[h: json = arg (1)]
[h: field = arg (2)]
[h: isArray = arg (3)]

[h, if (isArray): apos = ""; apos = "'"]
[h: path = decode (encodedPath)]

[h: log.debug (getMacroName() + ": path = " + path + 
			"; field = " + field + 
			"; isArray = " + isArray)]

[h, if (encodedPath == ""), code: {
	[json = json.remove (json, field)]	
}; {
	[json = json.path.delete (json, path + "[" + apos + field + apos + "]")]
}]


[h: log.debug (getMacroName() + ": json = " + json)]
[h: macro.return = json]