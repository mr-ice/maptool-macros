[h: sensesValue = arg (0)]
<!-- for a senses string: blindsight 60 ft., darkvision 120 ft., passive Perception 26
     prune "passive Perception" -->
[h: REG_SENSES = "(.*)\\s*passive\\s+Perception\\s+\\d*"]
[h: matchId = strfind (sensesValue, REG_SENSES)]
[h: matchCount = getFindCount (matchId)]
[h, if (matchCount > 0), code: {
	[Senses = getGroup (matchId, 1, 1)]
}; {
	[Senses = sensesValue]
}]

<!-- Only care about Darkvision atm -->
[h: REG_DARKVISION = ".*darkvision\\s+(\\d+)\\s?ft.*"]
[h: matchId = strfind (sensesValue, REG_DARKVISION)]
[h: matchCount = getFindCount (matchId)]
[h, if (matchCount > 0), code: {
	[darkvisionDist = getGroup (matchId, 1, 1)]
	[switch (darkvisionDist):
		case 30: setSightType ("Darkvision 30");
		case 60: setSightType ("Darkvision 60");
		case 90: setSightType ("Darkvision 90");
		case 120: setSightType ("Darkvision 120");
		case 150: setSightType ("Darkvision 150");
	    default: setSightType ("Darkvision 60")
	]
}; {
	[setSightType ("Normal")]
}]
[h: setHasSight (1)]
