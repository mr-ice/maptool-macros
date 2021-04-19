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
	[h: allImmunities = lower(getProperty("Immunities", id))]
	[h, if (listContains(allImmunities, damageType) || optValue == "immunity"), code: {
		[h: totalDamage = 0]
		[h: applied = listAppend(applied, "Immunity")]
	}; {""}]
	[h: allResistances = lower(getProperty("Resistances", id))]
	[h, if (listContains(allResistances, damageType) || optValue == "resistance"), code: {
		[h: totalDamage = floor(totalDamage / 2)]
		[h, if (totalDamage == 0): totalDamage = 1]
		[h: applied = listAppend(applied, "Resistance")]
	}; {""}]
	[h: allVulnerabilities = lower(getProperty("Vulnerabilities", id))]
	[h, if (listContains(allVulnerabilities, damageType) || optValue == "vulnerability"), code: {
		[h: totalDamage = totalDamage * 2]
		[h: applied = listAppend(applied, "Vulnerability")]
	}; {""}]
}; {""}]

<!-- If there is no save roll we are done -->
[h: macro.return = json.set("{}", "damage", totalDamage, "applied", applied, "type", damageType)]
[h: return(!json.isEmpty(saveRoll), macro.return)]

<!-- if a save was made for partial damage hanlde that here -->
[h: save = dnd5e_SavedAttacks_processSave(saveRoll, totalDamage, saveEffect)]
[h: applied = listAppend(applied, json.get(save, "saveText"))]

<!-- Return modified damage and what was done to it -->
[h: macro.return = json.set("{}", "damage", json.get(save, "damage"), "applied", applied, "type", damageType, "saveOutput", json.get(save, "saveOutput"))]