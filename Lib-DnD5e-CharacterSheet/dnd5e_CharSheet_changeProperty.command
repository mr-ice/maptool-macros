[h: propertyName = arg (0)]
[h, if (argCount() > 1): prompt = arg (1); prompt = propertyName]
[h: propertyValue = getProperty (propertyName)]
[h: abort (input ("propertyValue | " + propertyValue + " | " + prompt +
	" | TEXT "))]
[h: setProperty (propertyName, propertyValue)]
[h: dnd5e_CharSheet_refreshPanel()]