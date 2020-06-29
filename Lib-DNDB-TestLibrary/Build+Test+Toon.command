[h: ENCODE_CMD_TEMPLATE_BEGIN = "[h: encoded = encoded + " + decode ("%22")]
[h: abort (input ("charId | 0 | Character ID | Text"))]
[h: toon = dndb_getCharJSON (charId)]
[h: macroConfig = json.set ("", "group", "Toon")]
[h: toonName = json.path.read (toon, "data.name")]
[h: toonName = replace (toonName, " ", "")]
[h: toonName = replace (toonName, decode ("%22"), "")]
[h: toonName = replace (toonName, "-", "")]
[h: macroName = "dndbt_" + toonName]
[h: encodedToon = encode (toon)]
[h: macroCommand = "[h: encoded = " + decode ("%22%22") + "]"]
[h: strShift = 320]
[h: strIndex = 0]
[h: lastIndex = length (encodedToon)]
[h, while (strIndex < lastIndex), code: {
	[h: log.debug ("strIndex = " + strIndex + "; lastIndex = " + lastIndex + "; strShift = " + strShift)]
	[h: endIndex = strIndex + strShift]
	[h, if (endIndex > lastIndex): endIndex = lastIndex; ""]
	[h: encodedData = substring (encodedToon, strIndex, endIndex)]
	[h: macroCommand = macroCommand + ENCODE_CMD_TEMPLATE_BEGIN + 
			encodedData + decode ("%22") + "]" + decode ("%0A")]
	<!-- Maptool bug, it wont stop at lastIndex if it shoots past lastIndex -->
	[h: strIndex = strIndex + strShift]
}]

[h: macroCommand = macroCommand + "[h: macro.return = decode (encoded)]"]

[h: macroConfig = json.set (macroConfig, "command", macroCommand, "label", macroName)]

[h: createMacro (macroName, macroCommand, macroConfig)]