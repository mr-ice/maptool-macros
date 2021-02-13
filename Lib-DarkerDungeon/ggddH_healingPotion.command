[h: level = arg(0)]
[h, if (json.isEmpty(level)): level = "Lesser"]
[h: level = capitalize(lower(level))]
[h: basicToon = getProperty("dndb_basicToon")]
[h: assert(!json.isEmpty(basicToon), "The character is not initialized")]
[h: hitDice = json.path.read(basicToon, "classes[*].hitDice")]
[h: hitDie = math.listMax(json.toList(hitDice))]
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
[h: macro.return = json.toList(out, "")]