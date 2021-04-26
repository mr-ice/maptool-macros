<!-- Get the health related values from params -->
[h: inputObj = macro.args]
[h, if (json.type(inputObj) == "ARRAY" && json.length (inputObj) > 0): 
		inputObj = json.get(inputObj, 0)]
[h: log.debug (getMacroName() + "## inputObj = " + json.indent (inputObj))]
[h: assert (json.type (inputObj) == "OBJECT", "Invalid parameters: " + inputObj)]
[h: id = json.get(inputObj, "id")]
[h: assert (id != "", "No 'id' parameter provided: " + inputObj)]

[h: currentStats = json.set ("{}", "current", getProperty ("HP", id), "maximum", getProperty ("MaxHP", id),
		"temporary", getProperty ("tempHP", id), "dsPass", getProperty ("DSPass", id), 
		"dsFail", getProperty ("DSFail", id), "exhaustion6", getState ("Exhaustion 6", id))]
[h: log.debug (getMacroName() + "## currentStats = " + currentStats)]
[h: inputObj = json.merge (currentStats, inputObj)]
[h: log.debug (getMacroName() + "## new inputObj = " + inputObj)]

[h: libToken = startsWith(getName(id), "Lib:")]
[h, if(libToken), code: {
	[h: broadcast("Not applying health to library token: " + getName(id))]
	[h: return(0, "")]
}; {""}]
[h: current = json.get(inputObj, "current")]
[h, if (!isNumber(current)): current = 0; '']
[h: maximum = json.get(inputObj, "maximum")]
[h, if (!isNumber(maximum)): maximum = 0; '']
[h, if (maximum == 0), code: {
	[h: broadcast(strformat("No maximum HP value is set for token %s. Health will not be changed.", getName(id)))]
	[h: return(0, "")]
}]
[h: temporary = json.get(inputObj, "temporary")]
[h, if (!isNumber(temporary)): temporary = 0; '']
[h: dsPass = json.get(inputObj, "dsPass")]
[h, if (!isNumber(dsPass)): dsPass = 0; '']
[h: dsFail = json.get(inputObj, "dsFail")]
[h, if (!isNumber(dsFail)): dsFail = 0; '']
[h: exhaustionDeath = json.get(inputObj, "exhaustion6")]
[h, if (!isNumber(exhaustionDeath)): exhaustionDeath = 0; '']
[h: textType = json.get(inputObj, "text-type")]
[h, if (json.isEmpty(textType)): textType = "none"]
[h: textValue = json.get(inputObj, "text-value")]
[h, if (json.isEmpty(textValue)): textValue = 0]

<!-- An audit log of sorts -->
[h: log.info(getMacroName() + "## AUDIT TOKEN HEALTH: " + getName(id) + " HP:" + getProperty("HP", id) + "/" + current
			+ " TempHP:" + getProperty("TempHP", id) + "/" + temporary
			+ " MaxHP:" + getProperty("MaxHP", id) + "/" + maximum)]

<!-- Current properties, states and bars -->
[h: startingValues = "{}"]
[h: states = json.append("[]", "Bloodied", "Dying", "Dead", "Stable", "Damaged", "Prone")]
[h, foreach(state, states): startingValues = json.set(startingValues, state, getState(state, id))]
[h: bars = json.append("[]", "HP", "Damage", "DSPass", "DSFail")]
[h, foreach(bar, bars): startingValues = json.set(startingValues, bar + "-visible", isBarVisible(bar, id), bar + "-value", getBar(bar, id))]
[h: properties = json.append("HP", "TempHP", "MaxHP", "DSPass", "DSFail")]
[h, foreach(prop, properties): startingValues = json.set(startingValues, prop, getProperty(prop, id))]
[h: log.debug(getMacroName() + ": startingValues=" + json.indent(startingValues))]

<!-- Ending values start with everything off, except prone -->
[h: endingValues = "{}"]
[h, foreach(state, states): endingValues = json.set(endingValues, state, 0)]
[h: endingValues = json.set(endingValues, "Prone", getState("Prone", id))]
[h, foreach(bar, bars): endingValues = json.set(endingValues, bar + "-visible", 0, bar + "-value", 0)]
[h, foreach(prop, properties): startingValues = json.set(startingValues, prop, getProperty(prop, id))]
[h: log.debug(getMacroName() + ": endingValues cleared=" + json.indent(endingValues))]

<!-- Calculate the effective health for the bars -->
[h: effectiveHP = current + temporary]
[h: effectiveMaxHP = maximum + temporary]
[h: effectiveDamage = effectiveMaxHP - effectiveHP]
[h: log.debug(getMacroName() + "## effectiveHP=" + effectiveHP + " effectiveMaxHP=" + effectiveMaxHP + " effectiveDamage=" + effectiveDamage)]

<!-- Determine dead/dying+death saves/bloodied -->
[h: state = if (exhaustionDeath || (current == 0 && !isPC(id)) 
				|| (current == 0 && isPC(id) && dsFail >= 3), "dead", "fine")]
[h: state = if (state == "fine" && current == 0 && dsPass >= 3, "stable", state)]
[h: state = if (state == "fine" && current == 0, "dying", state)]
[h: state = if (state == "fine" && current <= maximum / 2, "bloodied", state)]
[h: state = if (state == "fine" && current < maximum, "damaged", state)]
[h, switch(state), code:
	case "dead": {
		[h: endingValues = json.set(endingValues, "Dead", 1)]
		[h, if (isPC(id)), code: {
			[h: endingValues = json.set(endingValues, "Prone", 1)]
		}; {
			[h: init = getInitiative(id)]
			[h, if (id == getInitiativeToken()): nextInitiative(); ""]
			[h: removeFromInitiative(id)]
			[h: setLayer("OBJECT", id)]
			[h: list = getLibProperty("_deadTokens", "Lib:DnD5e")]
			[h: deadToken = json.set("{}", "id", id, "initiative", init)]
			[h: list = json.append(list, deadToken)]
			[h, while(json.length(list) > 10): list = json.remove(list, 0)]
			[h: setLibProperty("_deadTokens", list, "Lib:DnD5e")]
		}]
	};
	case "stable": {
		[h: endingValues = json.set(endingValues, "Stable", 1)]
		[h: endingValues = json.set(endingValues, "Prone", 1)]
	};
	case "dying": {
		[h: endingValues = json.set(endingValues, "Dying", 1)]
		[h: endingValues = json.set(endingValues, "DSPass-visible", 1, "DSPass-value", 0.25 * dsPass)]
		[h: endingValues = json.set(endingValues, "DSFail-visible", 1, "DSFail-value", 0.25 * dsFail)]
		[h: endingValues = json.set(endingValues, "Prone", 1)]
	};
	case "bloodied": {
		[h: endingValues = json.set(endingValues, "Bloodied", 1)]
	};
	case "damaged": {
		[h: endingValues = json.set(endingValues, "Damaged", 1)]
		[h: setState("Damaged", 1, id)]
	};
	default: {
}]

<!-- Set the HP?Temp?Max bars -->
[h, if(current != 0), code: {
	[h: endingValues = json.set(endingValues, "HP-visible", 1, "HP-value", current / effectiveMaxHP)]
	[h: endingValues = json.set(endingValues, "Damage-visible", 1, "Damage-value", effectiveDamage / effectiveMaxHP)]
	[h, if (!isPC(id)): setLayer("TOKEN", id); ""]
}]

<!-- Save the token properties -->
[h: endingValues = json.set(endingValues, "HP", current)]
[h: endingValues = json.set(endingValues, "TempHP", temporary)]
[h: endingValues = json.set(endingValues, "MaxHP", maximum)]
[h: endingValues = json.set(endingValues, "DSPass", if(current == 0, dsPass, 0))]
[h: endingValues = json.set(endingValues, "DSFail", if(current == 0, dsFail, 0))]
[h: log.debug(getMacroName() + ": endingValues=" + json.indent(endingValues))]

<!-- Set the properties, changes are shown to owner/GM -->
[h: ownerText = "[]"]
[h: columns = "[]"]
[h: textColumn = '{"text":"%s", "to":["gm","owner"]}']
[h, foreach(prop, properties), code:  {
	[h: ending = number(json.get(endingValues, prop))]
	[h: setProperty(prop, ending, id)]
	[h: log.debug(getMacroName() + "## prop=" + prop + " ending=" + ending + " getProperty()=" + getProperty(prop, id))]
	[h, if (ending != json.get(startingValues, prop)): ownerText = json.append(ownerText, strformat("%{prop} = <b>%{ending}</b>"))]
}]
[h, if (!json.isEmpty(ownerText)), code: {
	[h: columns = json.append(columns, strformat(textColumn, json.toList(ownerText, ", ")))]
}]
[h: log.debug(getMacroName() + "## after properties columns=" + json.indent(columns))]

<!-- set the state, and show state images being set, and only those being set -->
[h: imageColumn = '{"image": "%s", "text":"%s"}']
[h, foreach(state, states), code: {
	[h: ending = number(json.get(endingValues, state))]
	[h: setState(state, ending, id)]
	[h: log.debug(getMacroName() + "## state=" + state + " ending=" + ending + " getState()=" + getState(state, id))]
	[h, if (ending == 1 && ending != json.get(startingValues, state)): columns = json.append(columns, strformat(imageColumn, getStateImage(state), state))]
}]
[h: log.debug(getMacroName() + "## after states columns=" + json.indent(columns))]

<!-- Set the bars, death save changes are shown -->
[h, foreach(bar, bars), code: {
	[h: visible = number(json.get(endingValues, bar + "-visible"))]
	[h: value = number(json.get(endingValues, bar + "-value"))]
	[h: log.debug(getMacroName() + "## bar=" + bar + " visible=" + visible + " value=" + value)]
	[h, if (visible): setBar(bar, value, id); setBarVisible(bar, visible, id)]
}]

<!-- Output -->
[h: tokenColumn = '{"id": "%{id}", "text":"%{adjustText}", "bgColor":"%{adjustStyle}"}']
[h: supportedTypes = json.append("[]", "damage", "healed", "tempHp", "update", "deathSave", "o5e")]
[h: type = json.indexOf(supportedTypes, textType)]
[h: log.debug(getMacroName() + "## textType=" + textType + " type=" + type)] 
[h, if (type >= 0), code: {

	<!-- Set up the variables used to generate ouput -->
	[h: adjustStyle = json.append("[]", "rgb(255,192,192)", "rgb(192,255,192)", "yellow", "rgb(192,192,192)", "rgb(192,192,255)", "rgb(192,192,192)")]
	[h: adjustStyle = json.get(adjustStyle, type)]
	[h: adjustText = json.append("[]", "<i><b>DAMAGED</b></i> for <b>%{textValue}</b>", "<i><b>HEALED</b></i> for <b>%{textValue}</b>",
						"<i><b>TEMP HP</b></i> of <b>%{textValue}</b> applied", "<i><b>DND BEYOND UPDATE</b></i>", "<i><b>DEATH SAVE</b></i> <b>%{textValue}</b>",
						"<i><b>O5E UPDATE</b></i> <b>%{textValue}</b>")]
	[h: adjustText = strformat(json.get(adjustText, type))]
	[h: log.debug(getMacroName() + "## adjustStyle=" + adjustStyle + " adjustText=" + adjustText + " tokenColumn=" + json.indent(strformat(tokenColumn)))]
	[h: dnd5e_Util_chatTokenOutput(strformat(tokenColumn), columns)]
}]
