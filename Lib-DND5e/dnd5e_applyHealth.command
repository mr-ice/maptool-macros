<!-- Get the health related values from params -->
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
[h: setState ("Bloodied", 0)]
[h: setState ("Dying", 0)]
[h: setState ("Dead", 0)]
[h: setState ("Stable", 0)]
[h: setBarVisible ("DSPass", 0)]
[h: setBarVisible ("DSFail", 0)]
[h: setBarVisible ("HP", 0)]
[h: setBarVisible ("Damage", 0)]

<!-- Determine dead/dying+death saves/bloodied -->
[h: state = if (exhaustionDeath || (current == 0 && !isPC()) || (current == 0 && isPC() && dsFail >= 3), "dead", "fine")]
[H: state = if (state != "dead" && current == 0 && isPC() && dsPass >= 3, "stable", "fine")]
[h: state = if (state == "fine" && current == 0, "dying", "fine")]
[h: state = if (state == "fine" && current > maximum / 2, "bloodied", "fine")]
[h, switch(state), code:
	case "dead": {
		[h: current = 0]
		[h: temporary = 0]
		[h: setState("Dead", 1, id)]
    [h if (!isPC(id)):removeInitiative(id); ""]
	};
	case "stable": {
		[h: temporary = 0]
		[h: setState("Stable", 1, id)]
	};
	case "dying": {
		[h: temporary = 0]
		[h: setState("Dying", 1, id)]

		<!-- Is a PC dying? Show death saves --> 
		[h, if (isPC()), code: {
			[h: setBar ("DSPass", 0.25 * dsPass)]
			[h: setBar ("DSFail", 0.25 * dsFail)]
		}; ""]
	};
	case "bloodied": {
		[h: temporary = 0]
		[h: setState("Bloodied", 1, id)]
	};
	default: {

		<!-- Toon is fine. Fine! Set the health bars -->
		[h: effectiveHP = current + temporary]
		[h: effectiveMaxHP = maximum + temporary]
		[h: effectiveDamage = effectiveMaxHP - effectiveHP]
		[h: log.info("effectiveHP=" + effectiveHP + " effectiveMaxHP=" + effectiveMaxHP + " effectiveDamage=" + effectiveDamage)]
		[h: setBar("HP", current / effectiveMaxHP, id)]
		[h: setBar("Damage", effectiveDamage / effectiveMaxHP, id)]
}]
	
<!-- Save the token properties -->
[h: setProperty ("HP", current, id)]
[h: setProperty ("TempHP", temporary, id)]
[h: setProperty ("MaxHP", maximum, id)]
[h: setProperty ("DSPass", dsPass, id)]
[h: setProperty ("DSFail", dsFail, id)]