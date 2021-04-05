<!-- Get the health related values from params -->
[h: log.debug(getMacroName() + ": " + json.indent(macro.args))]
[h: id = json.get(macro.args, "id")]
[h: libToken = startsWith(getName(id), "Lib:")]
[h, if(libToken), code: {
	[h: broadcast("Not applying health to library token: " + getName(id))]
	[h: return(0, "")]
}; {""}]
[h: current = json.get(macro.args, "current")]
[h, if (!isNumber(current)): current = 0; '']
[h: maximum = json.get(macro.args, "maximum")]
[h, if (!isNumber(maximum)): maximum = 0; '']
[h, if (maximum == 0), code: {
	[h: broadcast(strformat("No maximum HP value is set for token %s. Health will not be changed.", getName(id)))]
	[h: return(0, "")]
}]
[h: temporary = json.get(macro.args, "temporary")]
[h, if (!isNumber(temporary)): temporary = 0; '']
[h: dsPass = json.get(macro.args, "dsPass")]
[h, if (!isNumber(dsPass)): dsPass = 0; '']
[h: dsFail = json.get(macro.args, "dsFail")]
[h, if (!isNumber(dsFail)): dsFail = 0; '']
[h: exhaustionDeath = json.get(macro.args, "exhaustion6")]
[h, if (!isNumber(exhaustionDeath)): exhaustionDeath = 0; '']
[h: textType = json.get(macro.args, "text-type")]
[h, if (json.isEmpty(textType)): textType = "none"]
[h: textValue = json.get(macro.args, "text-value")]
[h, if (json.isEmpty(textValue)): textValue = 0]

<!-- An audit log of sorts -->
[h: log.info("AUDIT TOKEN HEALTH: " + getName(id) + " HP:" + getProperty("HP", id) + "/" + current
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
[h: log.debug("effectiveHP=" + effectiveHP + " effectiveMaxHP=" + effectiveMaxHP + " effectiveDamage=" + effectiveDamage)]

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

<!-- Output values set to empty -->
[h: detailImages = "[]"]
[h: ownerText = "[]"]
[h: imgSrc = '<img src="%s" alt="%s" width="30" height="30"/>']
[h: imageColumn = '<td width="34" style="padding:0px;border-width:1pt;border-style:solid;text-align:center;">' + imgSrc + '</td>']

<!-- set the state, and show state images being set, and only those being set -->
[h, foreach(state, states), code: {
	[h: ending = number(json.get(endingValues, state))]
	[h: setState(state, ending, id)]
	[h: log.debug(getMacroName() + ": state=" + state + " ending=" + ending + " getState()=" + getState(state, id))]
	[h, if (ending == 1 && ending != json.get(startingValues, state)): detailImages = json.append(detailImages , strformat(imageColumn, getStateImage(state), state))]
}]

<!-- Set the bars, death save changes are shown -->
[h, foreach(bar, bars), code: {
	[h: visible = number(json.get(endingValues, bar + "-visible"))]
	[h: value = number(json.get(endingValues, bar + "-value"))]
	[h: deathSave = if (visible == 1 && (bar == "DSPass" || bar == "DSFail"), 1, 0)]
	[h, if (visible): setBar(bar, value, id); setBarVisible(bar, visible)]
	<!-- if (deathSave && value != json.get(startingValues, bar + "-value")): detailImages = json.append(detailImages , strformat(imageColumn, getBarImage(bar, 0, value), bar)) -->
}]

<!-- Set the properties, changes are shown to owner/GM -->
[h, foreach(prop, properties), code:  {
	[h: ending = number(json.get(endingValues, prop))]
	[h: setProperty(prop, ending, id)]
	[h: log.debug(getMacroName() + ": prop=" + prop + " ending=" + ending + " getProperty()=" + getProperty(prop, id))]
	[h, if (ending != json.get(startingValues, prop)): ownerText = json.append(ownerText, strformat("%{prop} = <b>%{ending}</b>"))]
}]
[h, if (!json.isEmpty(ownerText)), code: {
	[h: ownerText = json.toList(ownerText, ", ")]
	[h: ownerText = strformat('<td style="border-width:1pt;border-style:solid;padding:0px 5px 0px 3px;" NOWRAP>%{ownerText}</td>')]
}]

<!-- Output -->
[h: supportedTypes = json.append("[]", "damage", "healed", "tempHp", "update", "deathSave", "o5e")]
[h: type = json.indexOf(supportedTypes, textType)]
[h: log.debug(getMacroName() + ": textType=" + textType + " type=" + type)] 
[h, if (type >= 0), code: {

	<!-- Set up the variables used to generate ouput -->
	[h: name = getName(id)]
	[h: imageLink = strformat(imgSrc, getTokenImage("", id), getName(id))]
	[h: adjustStyle = json.append("[]", "rgb(255,192,192)", "rgb(192,255,192)", "yellow", "rgb(192,192,192)", "rgb(192,192,255)", "rgb(192,192,192)")]
	[h: adjustStyle = json.get(adjustStyle, type)]
	[h: adjustText = json.append("[]", "<i><b>DAMAGED</b></i> for <b>%{textValue}</b>", "<i><b>HEALED</b></i> for <b>%{textValue}</b>",
						"<i><b>TEMP HP</b></i> of <b>%{textValue}</b> applied", "<i><b>DND BEYOND UPDATE</b></i>", "<i><b>DEATH SAVE</b></i> <b>%{textValue}</b>",
						"<i><b>O5E UPDATE</b></i> <b>%{textValue}</b>")]
	[h: adjustText = strformat(json.get(adjustText, type))]
	[h: ownerText = json.toList(ownerText, " ")]
	[h: detailImages = json.toList(detailImages, " ")]
	[h: outTable  = 
		'<table style="border-spacing:1pt;border-width:0px;border-style:solid;padding:0px;">
		  <tr>
		    <td width="34" style="padding:0px;border-width:1pt;border-style:solid;text-align:center;">%{imageLink}</t>
		    <td width="250" style="background-color:%{adjustStyle};border-width:1pt;border-style:solid;padding:0px 5px 0px 3px;" NOWRAP><b>%{name}</b> %{adjustText}.</td>
		    %{ownerText}
		    %{detailImages}
		  </tr>
		</table>']

	<!-- Determine the people who get details -->
	[h: owners = getOwners("json", id)]	
	[h: players = getAllPlayerNames("json")]
	[h: detailPlayers = "[]"]
	[h: otherPlayers = "[]"]
	[h, foreach(player, players), code: {
		[h, if (isGM(player) || json.contains(owners, player)): detailPlayers = json.append(detailPlayers, player); otherPlayers = json.append(otherPlayers, player)]
	}]	
	[h: broadcast(strformat(outTable), detailPlayers)]
	[h: ownerText = ""]
	[h, if (!json.isEmpty(otherPlayers)): broadcast(strformat(outTable), otherPlayers)]
}]