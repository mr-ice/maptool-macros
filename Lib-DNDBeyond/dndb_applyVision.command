[h: basicToon = getProperty ("dndb_BasicToon")]
[h, if (encode (basicToon) == ""), code: {
	[h: error = "You must initialize with DNDBeyond first"]
	[h: abort (input ( " junk | | " + error + " | LABEL | TEXT=fals"))]
	[h: return (0, error)]
}]

[h: senses = json.get (basicToon, "senses")]
[h: senseStr = ""]
[h, foreach (sense, senses), code: {
	[h: senseName = json.get (sense, "name")]
	[h: distance = json.get (sense, "distance")]
	[h, if (distance > 0): senseStr = senseStr + ", " + senseName +
				" " + distance]
	<!-- Currently, the only Sight Type to apply is Darkvision -->
	[h, if (senseName == "Darkvision"): setSightType ("Darkvision")]
}]
[h, if (senseStr == ""): senseStr = "Normal"; senseStr = substring (senseStr, 2)]
[h: setProperty ("Senses", senseStr)]