<!-- Get the health related values from params -->
[h: log.info("dnd5e_applyHealth: " + json.indent(macro.args, 2))]
[h: id = json.get(macro.args, "id")]
[h: current = json.get(macro.args, "current")]
[h, if (!isNumber(current)): current = 0; '']
[h: maximum = json.get(macro.args, "maximum")]
[h, if (!isNumber(maximum)): maximum = 0; '']
[h: temporary = json.get(macro.args, "temporary")]
[h, if (!isNumber(temporary)): temporary = 0; '']
[h: dsPass = json.get(macro.args, "dsPass")]
[h, if (!isNumber(dsPass)): dsPass = 0; '']
[h: dsFail = json.get(macro.args, "dsFail")]
[h, if (!isNumber(dsFail)): dsFail = 0; '']
[h: exhaustionDeath = json.get(macro.args, "exhaustion6")]
[h, if (!isNumber(exhaustionDeath)): exhaustionDeath = 0; '']

<!-- Clear all of the states/bars -->
[h: setState ("Bloodied", 0, id)]
[h: setState ("Dying", 0, id)]
[h: setState ("Dead", 0, id)]
[h: setState ("Stable", 0, id)]
[h: setBarVisible ("HP", 0, id)]
[h: setBarVisible ("Damage", 0, id)]
[h: setBarVisible ("DSPass", 0, id)]
[h: setBarVisible ("DSFail", 0, id)]

<!-- Calculate the effective health for the bars -->
[h: effectiveHP = current + temporary]
[h: effectiveMaxHP = maximum + temporary]
[h: effectiveDamage = effectiveMaxHP - effectiveHP]
[h: log.info("effectiveHP=" + effectiveHP + " effectiveMaxHP=" + effectiveMaxHP + " effectiveDamage=" + effectiveDamage)]

<!-- Determine dead/dying+death saves/bloodied -->
[h: state = if (exhaustionDeath || (current == 0 && !isPC(id)) 
				|| (current == 0 && isPC(id) && dsFail >= 3), "dead", "fine")]
[h: state = if (state == "fine" && current == 0 && dsPass >= 3, "stable", state)]
[h: state = if (state == "fine" && current == 0, "dying", state)]
[h: state = if (state == "fine" && current <= maximum / 2, "bloodied", state)]
[h, switch(state), code:
	case "dead": {
		[h: setState("Dead", 1, id)]
		[h, if (isPC(id)), code: {
			[h: setState("Prone", 1, id)]
		}; {
			[h: removeFromInitiative(id)]
			[h: setLayer("OBJECT", id)]
		}]
	};
	case "stable": {
		[h: setState("Stable", 1, id)]
		[h: setState("Prone", 1, id)]
	};
	case "dying": {
		[h: setState("Dying", 1, id)]
		[h: setBar("DSPass", 0.25 * dsPass, id)]
		[h: setBar("DSFail", 0.25 * dsFail, id)]
		[h: setState("Prone", 1, id)]
	};
	case "bloodied": {
		[h: setState("Bloodied", 1, id)]
	};
	default: {
}]

[h, if(current != 0), code: {
	[h: setBar("HP", current / effectiveMaxHP, id)]
	[h: setBar("Damage", effectiveDamage / effectiveMaxHP, id)]
	[h, if (!isPC(id)): setLayer("TOKEN", id); ""]
}]

<!-- Save the token properties -->
[h: setProperty ("HP", current, id)]
[h: setProperty ("TempHP", temporary, id)]
[h: setProperty ("MaxHP", maximum, id)]
[h: setProperty ("DSPass", if(current == 0, dsPass, 0), id)]
[h: setProperty ("DSFail", if(current == 0, dsFail, 0), id)]