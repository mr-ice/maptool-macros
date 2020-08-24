[h: basicToon = dndb_getBasicToon ()]

[h: senses = json.get (basicToon, "senses")]
[h: senseStr = ""]
[h: setSightType ("Normal")]
[h, foreach (sense, senses), code: {
	[h: senseName = json.get (sense, "name")]
	[h: distance = json.get (sense, "distance")]
	[h, if (distance > 0): senseStr = senseStr + ", " + senseName +
				" " + distance; ""]
	<!-- Currently, the only Sight Type to apply is Darkvision -->
	[h, if (senseName == "Darkvision" && distance > 0), code: {
		[h, switch (distance):
			case 30: setSightType ("Darkvision 30");
			case 60: setSightType ("Darkvision 60");
			case 90: setSightType ("Darkvision 90");
			case 120: setSightType ("Darkvision 120");
			case 150: setSightType ("Darkvision 150");
		    default: setSightType ("Darkvision 60")
			]
	}; {""}]
}]
[h, if (senseStr == ""): senseStr = "Normal"; senseStr = substring (senseStr, 2)]
[h: log.debug ("dndb_getBasicToon: senseStr = " + senseStr)]
[h: setProperty ("Senses", senseStr)]