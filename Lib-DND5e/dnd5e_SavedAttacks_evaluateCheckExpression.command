[h: id = arg(0)]
[h: checkExp = arg(1)]
[h: state = arg(2)]
[h: log.debug(getMacroName() + ": args=" + json.indent(macro.args))]
[h: check = dnd5e_RollExpression_getTargetCheck(checkExp)]
[h: log.debug(getMacroName() + " start: length=" + length(check) + " check=|" + check + "|")]

<!-- Remove Strings -->
[h: search = check]
[h: search = replace(search, "\\Q\\'\\E", "  ")]
[h: log.debug(getMacroName() + " replace ': length=" + length(search) + " check=|" + search + "|")]
[h: search = replace(search, '\\Q\\"\\E', "  ")]
[h: log.debug(getMacroName() + ' replace ": length=' + length(search) + " check=|" + search + "|")]
[h, forEach(find, "('.*?')," + '(".*?")'), code: {
	[h: regex = strfind(search, find)]
	[h: log.debug(getMacroName() + ": search=" + search + " find=" + find + " count=" + getFindCount(regex))]
	[h, count(getFindCount(regex)), code: {
		[h: match = roll.count + 1]
		[h: group = 0]
		[h: start = getGroupStart(regex, match, group)]
		[h: end = getGroupEnd(regex, match, group)]
		[h, if (start == 0): firstPart = ""; firstPart = substring(search, 0, start)]
		[h, if (end == length(search)): lastPart = ""; lastPart = substring(search, end)]
		[h: middlePart = ""]
		[h, for(space, 0, end - start): middlePart = middlePart + " "]
		[h: search = firstPart + middlePart + lastPart]
		[h: log.debug(getMacroName() + " constant: start=" + start + " end=" + end + " firstPart=" + firstPart + " lastPart=" + lastPart 
			+ " length=" + length(search) + " search=" + search)]
	}]
}]
[h: log.debug(getMacroName() + " removed constants : length=" + length(search) + " search=|" + search + "|")]

<!-- Search for Property Names -->
[h: propertyNames = getAllPropertyNames("*", "json")]
[h: stateNames = getTokenStates("json")]
[h: replacements = "[]"]
[h: invalidNames = "[]"]
[h: regex = strfind(search, "[a-zA-Z_][a-zA-Z0-9_.]+")]
[h, count(getFindCount(regex)), code: {
	[h: match = roll.count + 1]
	[h: group = 0]
	[h: log.debug(getMacroName() + ": match=" + match + " start=" + getGroupStart(regex, match, group) + " end=" + getGroupEnd(regex, match, group) 
			+ " group=" + getGroup(regex, match, group))]
	[h: property = getGroup(regex, match, group)]
	[h: valueFound = 0]
	[h: value = ""]
	[h, if (json.contains(stateNames, property)), code: {
		[h: valueFound = 1]
		[h: value = getState(property, id)]
	}]
	[h, if (json.contains(propertyNames, property)), code: {
		[h: valueFound = 1]
		[h: value = getProperty(property, id)]
		[h: log.debug(getMacroName() + ": property=" + property + " getProperty=" + getProperty(property, id) + " value=" + value + " isNumber=" + isNumber(value))]
	}]
	[h, if (valueFound): replacements = json.append(replacements, json.set("{}", "property", property, "value", value, "start", getGroupStart(regex, match, group), 
							"end", getGroupEnd(regex, match, group))); 
							invalidNames = if(json.contains(invalidNames, property), invalidNames, json.append(invalidNames, property))]
}]

<!-- Check for errors -->
[h, if (!json.isEmpty(invalidNames)), code: {
	[h: tt = dnd5e_Util_encodeHtml("Automatic failure for invalid state or property names: " + json.toList(invalidNames))]
	[h: output = json.get(state, "output") + " <span style='color: red;' title='" + tt + "'>Check FAIL;</span>"]
	[h: state = json.set(state, "check", 0, "output", output)]
	[h: return(0, state)]
}]

<!-- Replace proeprty values in reverse order -->
[h: replacements = json.sort(replacements, "descending", "start")]
[h: log.debug(getMacroName() + ": replaements=" + json.indent(replacements))]
[h, foreach(rep, replacements), code: {
	[h: start = json.get(rep, "start")]
	[h: end = json.get(rep, "end")]
	[h, if (start == 0): firstPart = ""; firstPart = substring(check, 0, start)]
	[h, if (end == length(check)): lastPart = ""; lastPart = substring(check, end)]
	[h: middle = json.get(rep, "value")]
	[h, if(isNumber(middle)): q = ""; q = "'"]
	[h: check = firstPart + " " + q + middle + q + lastPart]
}]
[h: checkResult = eval(check)]
[h: log.debug(getMacroName() + ": expression=|" + check + "| result=" + checkResult)]

<!-- Update the state -->
[h: tt = dnd5e_Util_encodeHtml(dnd5e_RollExpression_getTargetCheck(checkExp) + " = " + check + " = " + if(checkResult, "True", "False"))]
[h: output = json.get(state, "output") + " <span title='" + tt + "'>Check " + if(checkResult, "PASS", "FAIL") + ";</span>"]
[h: player = json.get(state, "player")]
[h: player = json.append(player, strformat('{"text": "Check %s"}', if(checkResult, "PASS", "FAIL")))]
[h: state = json.set(state, "check", checkResult, "output", output, "player", player)]
[h: macro.return = state]