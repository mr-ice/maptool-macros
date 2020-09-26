<!-- Read parameters -->
[h: task = json.get(macro.args, "task")]
[h: label = json.get(macro.args, "label")]
[h: header = json.get(macro.args, "header")]
[h: apply = json.get(macro.args, "apply")]

<!-- Create the list of token names to show to the user -->
[h: sNames = getSelectedNames()]
[h, if (sNames == ""): names = "No tokens selected!"; names = ""]
[h, forEach(name, sNames): names = names + "<li>" + name]
[h: inputList = listAppend("", "junk|<html><b>" + header + "</b><ul>" + names + "</ul></html>|-|LABEL|SPAN=TRUE", "##")]

<!-- Read the value from the user --> 
[h, if (task == "drain"), code: {
	[h: json.toVars(dnd5e_AE2_getConstants())]
	[h: inputList = listAppend(inputList, "ability|" + CHAR_ABILITIES + "|Select Ability:|LIST|VALUE=Strength DELIMITER=JSON", "##")]
}]
[h: inputList = listAppend(inputList, "value|0|" + label + "|TEXT|WIDTH=4", "##")]
[h: abort(input(inputList))]
[h, if (!isNumber(value)): value = 0]
[h, if (task != "drain" && value < 0): value = 0]

<!-- Process each selected token -->
[h: sIds = getSelected()]
[h: log.debug("IDs:'" + sIds + "' Names:" + sNames)]
[h, foreach(id, sIds), code: {
	[h: log.debug("ID: " + id + " " + task +"=" + value)]
	[h, if (task == "drain"), code: {
		 [h: dnd5e_Health_applyAbilityChange(json.get(CHAR_ABILITIES, ability), value, id)]
	}; {
		[h: params = json.set("{}", "id", id, "current", getProperty("HP", id), "maximum", getProperty("MaxHP", id), 
			"temporary", getProperty("TempHP", id), task, value)]
		[h, macro(apply): params]
	}]
}]