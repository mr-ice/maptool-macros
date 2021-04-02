[h: macroName = arg(0)]
[h: macroData = arg(1)]
[h, if (argCount() > 2): dbName = arg(2); dbName = ""]
[h, if (argCount() > 3): macroProperties = arg(3); macroProperties = "{}"]
[h: dnd5e_Constants(getMacroName())]
[h, if (dbName == ""): dbName = LIB_TOKEN]
[h, if (json.type(macroProperties) != "OBJECT"), code: {
	[log.warn (CATEGORY + "## Ignoring non-object properties: " + macroProperties)]
	[macroProperties = "{}"]
}]

[h: mapNames = getAllMapNames("json")]
[h: tokenObj = "{}"]
[h, foreach (mapName, mapNames), code: {
	[foundId = findToken (dbName, mapName)]
	[if (foundId != ""), code: {
		[tokenObj = json.set (tokenObj, "tokenId", foundId, "mapName", mapName)]
	}]
}]

[h: assert (json.length (tokenObj) > 1, "Could not find " + dbName)]

[h: tokenId = json.get (tokenObj, "tokenId")]
[h: mapName = json.get (tokenObj, "mapName")]
[h: strShift = 80]
[h: encodedData = encode (macroData)]
[h: lastIndex = length (encodedData)]

[h: formattedData = ""]

[h, for (strIndex, 0, lastIndex, strShift), code: {
	[endIndex = strIndex + strShift]
	[if (endIndex > lastIndex): endIndex = lastIndex]
	[formattedData = formattedData + substring (encodedData, strIndex, endIndex) + decode ("%22+%2B+%0A+%22")]
}]
[h: formattedData = decode ("%22") + formattedData + decode ("%22")]
[h: command = "[h: macro.return = " + formattedData + "]"]
[h: macroIndexes = getMacroIndexes (macroName, "json", tokenId, mapName)]
[h, foreach (macroIndex, macroIndexes): removeMacro (macroIndex, tokenId)]
[h: macroIndex = createMacro (macroName, command, macroProperties)]
[h: macro.return = macroIndex]