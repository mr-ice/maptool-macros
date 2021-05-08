[h: level = arg(0)]
[h, if (json.isEmpty(level)): level = "Lesser"]
[h: level = capitalize(lower(level))]
[h: basicToon = getProperty("dndb_basicToon")]
[h: assert(!json.isEmpty(basicToon), "The character is not initialized")]
[h: hitDiceValue = json.path.read(basicToon, "classes[*].hitDice")]
[h: hitDie = math.listMax(json.toList(hitDiceValue))]
[h, switch(level):
	case "Lesser": heal = json.set("{}", "dieCount", 2, "bonus", 2);
	case "Greater": heal = json.set("{}", "dieCount", 4, "bonus", 4);
	case "Superior": heal = json.set("{}", "dieCount", 6, "bonus", 8);
	case "Supreme": heal = json.set("{}", "dieCount", 8, "bonus", 16);
	default: assert(0, "Unknow level passed: " + level)
]
[h: json.toVars(heal)]
[h: rolls = ""]
[h, count(dieCount): rolls = listAppend(rolls, roll(1, hitDie), " +")]
[h: total = math.listSum(rolls, " +")]
[h: totalHeal = total + bonus]
[h: out = json.append("[]", strformat("<br><font size='4'><b>Using %{level} Healing Potion</b></font>"))]
[h: out = json.append(out, "<div style='margin-left: 15px;'>")]
[h: out = json.append(out, "<span title='" + dieCount + "d" + hitDie + " + " + bonus + " = [" + rolls + "] + " + bonus + " = " + total + " + " + bonus + " = " + totalHeal +  "'>")]
[h: out = json.append(out, strformat("Healed for <b>%{totalHeal}</b><br></span>"))]
[h: params = json.set("{}", "id", currentToken(), "current", getProperty("HP"), "maximum", getProperty("MaxHP"), "healing", totalHeal)]
[h, macro("dnd5e_healDamage@Lib:DnD5e"): params]

<!-- Prompt to roll usable -->
[h: useables = ggddH_Usage_getUsables()]
[h, if (!json.isEmpty(useables)), code: {
	[preferenceKey = "ggdd.healingUseable." + level]
	[previousChoiceValue = dnd5e_Preferences_getPreference (preferenceKey)]
	[noUsable = "No Usable"]
	[fields = json.merge (json.append ("[]", noUsable), json.fields(useables, "json"))]
	[log.debug (getMacroName() + "## fields = " + fields)]
	[previousChoice = json.indexOf (fields, previousChoiceValue)]
	[inputStr = "rollUsable | Spend a useable? || Label | span=true "]
	[useableChoiceStr = "useableChoice | " + fields + " | Useable | LIST | " + 
		"delimiter=json value=string select=" + previousChoice]
	[inputStr = listAppend (inputStr, useableChoiceStr, "##")]
	[chose = input(inputStr)]
	[if (!chose): useableChoice = noUsable]
	[if (useableChoice != noUsable), code: {
		[out = json.append (out, ggddH_Usage_use(useableChoice))]
		[dnd5e_Preferences_setPreference(preferenceKey, useableChoice)]
	}]
}]
[h: macro.return = json.toList(out, "")]