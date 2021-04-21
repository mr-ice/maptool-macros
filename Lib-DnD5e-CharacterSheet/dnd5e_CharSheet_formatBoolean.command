[h: propertyName = arg(0)]
[h, if (argCount() > 1): isLiteral = arg (1); isLiteral = 0]
[h: boolValues = "['O', '&check;']"]
[h, if (!isLiteral): 
		boolPropertyValue = getProperty (propertyName);
		boolPropertyValue = propertyName]
[h, if (boolPropertyValue != "" && boolPropertyValue): 
	boolStr = json.get (boolValues, 1); 
	boolStr = json.get (boolValues, 0)]
[h: macro.return = boolStr]