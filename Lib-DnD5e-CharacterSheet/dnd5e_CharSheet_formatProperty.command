[h: propertyName = arg(0)]
[h, if (argCount() > 1): isLiteral = arg(1); isLiteral = 0]
[h, if (argCount() > 2): noNBSP = arg(2); noNBSP = 0]
[h, if (!isLiteral):
	value = getProperty (propertyName);
	value = propertyName]
[h, if (!noNBSP && encode (value) == ""):
	value = "&nbsp;"]
[r: value]