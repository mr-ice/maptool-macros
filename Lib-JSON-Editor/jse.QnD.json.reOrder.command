[h: json = arg (0)]
[h: index = arg (1)]
[h: encodedPath = arg (2)]
[h, if (argCount() > 3): orderUp = arg(3); orderUp = 0]
[h: log.debug (getMacroName() + ": json = " + json + "; index = " + index +
		"; encodedPath = " + encodedPath + "; orderUp = " + orderUp)]
<!-- Cant order up on first element or order down on last -->
[h: path = decode (encodedPath)]
[h, if (encodedPath == ""): jarr = json; jarr = json.path.read (json, path)]
[h: log.debug (getMacroName() + ": jarr = " + jarr)]
[h, if (!orderUp), code: {
	[if (json.length (jarr) - 1 <= index): abortCode = 0; abortCode = 1]
}; {
	[if (index == 0): abortCode = 0; abortCode = 1]
}]

[h: log.debug (getMacroName() + ": abortCode = " + abortCode)]
[h: abort (abortCode)]


[h: targetElement = json.get (jarr, index)]
[h, if (orderUp), code: {
	[previousElement = json.get (jarr, index - 1)]
	[jarr = json.set (jarr, index - 1, targetElement)]
	[jarr = json.set (jarr, index, previousElement)]
}; {
	[nextElement = json.get (jarr, index + 1)]
	[jarr = json.set (jarr, index + 1, targetElement)]
	[jarr = json.set (jarr, index, nextElement)]
}]

[h, if (encodedPath == ""): json = jarr; json = json.path.set (json, path, jarr)]
[h: macro.return = json]