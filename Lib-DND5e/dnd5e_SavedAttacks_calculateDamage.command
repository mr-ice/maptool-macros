[h: log.debug(getMacroName() + ": args=" + json.indent(macro.args))]
[h: id = arg(0)]
[h: totalDamage = arg(1)]
[h: optValue = arg(3)]
[h, if(json.length(macro.args) > 4): saveRoll = arg(4); saveRoll = ""]
[h, if(json.length(macro.args) > 5): saveEffect = arg(5); saveEffect = ""]

<!-- Only keep the first type of damage -->
[h: damageType = lower(trim(listGet(arg(2), 0)))]
[h: log.debug(getMacroName() + ": id=" + id + " totalDamage=" + totalDamage + " damageType=" + damageType + " saveEffect=" + saveEffect 
				+ " saveRoll=" + json.indent(saveRoll))]

<!-- Check damage type against immunities/resistances/vulnerablilities -->
[h: applied = ""]
[h, if (damageType != ""), code: {
	[h: immunities = lower(getProperty("Immunities", id))]
	[h, if (listContains(immunities, damageType) || optValue == "immunity"), code: {
		[h: totalDamage = 0]
		[h: applied = listAppend(applied, if(optValue == "immunity", "GM(Immunity)", "Immunity"))]
	}; {""}]
	[h: resistances = lower(getProperty("Resistances", id))]
	[h, if (listContains(resistances, damageType) || optValue == "resistance"), code: {
		[h: totalDamage = floor(totalDamage / 2)]
		[h: applied = listAppend(applied, if(optValue == "resistance", "GM(Resistance)", "Resistance"))]
	}; {""}]
	[h: vulnerabilities = lower(getProperty("Vulnerabilities", id))]
	[h, if (listContains(vulnerabilities, damageType) || optValue == "vulnerability"), code: {
		[h: totalDamage = totalDamage * 2]
		[h: applied = listAppend(applied, if(optValue == "vulnerability", "GM(Vulnerability)", "Vulnerability"))]
	}; {""}]
}; {""}]

<!-- If there is no save roll we are done -->
[h: macro.return = json.set("{}", "damage", totalDamage, "applied", applied, "type", damageType)]
[h: return(!json.isEmpty(saveRoll), macro.return)]

<!-- if a save was made for partial damage hanlde that here -->
[h: log.debug(getMacroName() + ": saveRoll=" + json.indent(saveRoll))]
[h: tt = "DC " + dnd5e_RollExpression_getSaveDC(saveRoll) + " " + dnd5e_RollExpression_getSaveAbility(saveRoll) + ": "]
[h: tt = tt + dnd5e_RollExpression_getTypedDescriptor(saveRoll, "tooltipRoll") + " = " 
		+ dnd5e_RollExpression_getTypedDescriptor(saveRoll, "tooltipDetail") + " = " + dnd5e_RollExpression_getTotal(saveRoll)]
[h: saveResult = json.get(saveRoll, "saveResult")]
[h, if (saveResult == "passed"): saveResult = trim(lower(saveEffect))]
[h: log.debug(getMacroName() + ": saveResult=" + saveResult + " tt=" + tt)]
[h, switch(saveResult), code:
	case "half": {
		[h: totalDamage = floor(totalDamage / 2)]
		[h: saveEffect = "Save for Half"]
	};
	case "none": {
		[h: totalDamage = 0]
		[h: saveEffect = "Save for None"]
	};
	case "failed": {
		[h: saveEffect = "Save Failed"]
	};
	default: {
		[h, if (isNumber(saveResult)), code: {
			[h: totalDamage = floor(totalDamage * saveResult)]
			[h: saveEffect = "Save for " + round(saveResult * 100) + "%"]
		}; {
			[h: saveEffect = "Save for unknown effect: " + saveResult]
		}]
	}]
[h: applied = listAppend(applied, "<span title='" + tt + "'>" + saveEffect + "</span>")]

<!-- Return modified damage and what was done to it -->
[h: macro.return = json.set("{}", "damage", totalDamage, "applied", applied, "type", damageType)]