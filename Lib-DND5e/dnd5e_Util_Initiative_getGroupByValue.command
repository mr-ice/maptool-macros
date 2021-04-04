[h: tokenId = arg(0)]
[h: dnd5e_Constants (getMacroName())]
[h: doGroupBy = dnd5e_Preferences_getPreference ("initiativeDoGroupBy")]
[h: return (doGroupBy, tokenId)]
[h: groupByValue = dnd5e_Preferences_getPreference ("initiativeGroupByElement")]
<!-- if the group by value is empty, just return the token base name -->
<!-- If the value matches the pattern, pull the match group. Else use the
	value as-is -->
[h: valueIncrPattern = "(.*)\\s+\\d+"]
[h, switch (groupByValue):
	case "Name": value = getName (tokenId);
	case "GM Name": value = getGMName (tokenId);
	case "Label": value = getLabel (tokenId);
	case "Character ID": value = getProperty ("Character ID", tokenId);
	default: log.error (CATEGORY + "## Who fucking wrote this!? " + groupByValue;
]
[h: log.debug (CATEGORY + "## groupByValue = " + groupByValue + "; value = " + value)]
[h, if (value == ""), code: {
	[log.debug (CATEGORY + "## No value found for " + groupByValue + ", using getName")]
	[value = getName (tokenId)]
}]
[h: findId = strfind (value, valueIncrPattern)]
[h, if (getFindCount (findId) > 0): value = getGroup (findId, 1, 1)]
[h: log.debug (CATEGORY + "## baseValue = " + value)]
[h: macro.return = value]