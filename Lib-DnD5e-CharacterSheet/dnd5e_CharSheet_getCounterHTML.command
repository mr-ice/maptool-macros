[h: dnd5e_CharSheet_Constants(getMacroName())]
[h: counters = getProperty (PROP_COUNTERS)]
[h: log.debug (CATEGORY + "## counters = " + counters)]
[h: html = "<table class='mixed-outline'>"]
[h, foreach (counterName, counters), code: {
	[counter = json.get (counters, counterName)]
	[log.debug (CATEGORY + "## counter = " + counter)]
	[name = getStrProp (counter, "name", "unnamed", "##")]
	[limit = getStrProp (counter, "limit", 0, "##")]
	[current = getStrProp (counter, "current", limit, "##")]
	[type = getStrProp (counter, "type", "rounds", "##")]
	[counterHtml = "<tr><td class='standard-label'>" + 
		macroLink (name, "dnd5e_CharSheet_changeCounters@" + LIB_TOKEN,
			"", json.append ("", counterName), currentToken()) + "</td><td align='center' class='standard-value'>" + 
		macroLink ("<b>+</b>", "dnd5e_CharSheet_incrementCounter@" + LIB_TOKEN, 
			"", json.append ("", counterName, "1"), currentToken()) + " " +
		macroLink (current, "dnd5e_CharSheet_incrementCounter@" + LIB_TOKEN, 
			"", json.append ("", counterName, "-1"), currentToken()) + " / " + limit + "</td><td class='standard-label'>" + type + "</td></tr>"]
	[html = html + counterHtml]
	
}]
[h: html = html + "<tr><td align='center' class='subtext' colspan='3'><b>" + 
	macroLink ("COUNTERS", "dnd5e_CharSheet_changeCounters@" + LIB_TOKEN, 
		"", "", currentToken()) +
		"</b></td><tr></table>"]

[h: log.trace (CATEGORY + "## html = " + html)]
[h: macro.return = html]