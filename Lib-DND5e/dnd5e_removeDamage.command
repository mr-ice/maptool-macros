<!-- Read the parameters -->
[h: log.info("dnd5e_removeDamage: " + json.indent(macro.args, 2))]
[h: id = json.get(macro.args, "id")]
[h: current = json.get(macro.args, "current")]
[h, if (!isNumber(current)): current = 0; '']
[h: dmg = json.get(macro.args, "damage")]
[h, if (!isNumber(dmg)): dmg = 0; '']
[h: temporary = json.get(macro.args, "temporary")]
[h, if (!isNumber(temporary)): temporary = 0; '']
[h: log.info("Before: current=" + current + " temporary=" + temporary + " damage=" + dmg)]

<!-- Remove damage temp first, then current -->
[h, if (dmg >= temporary), code: {
	[h: dmg = dmg - temporary]
	[h: temporary = 0]
};{
	[h: temporary = temporary - dmg]
	[h: dmg = 0]
}]
[h, if (dmg >= current): current = 0; current = current - dmg]
[h: log.info("After: current=" + current + " temporary=" + temporary)]

<!-- Update the toon  -->
[h: params = json.set("{}", "id", id, "current", current, "temporary", temporary, "maximum", getProperty("MaxHP", id),
	"dsPass", getProperty("DSPass", id), "dsFail", getProperty("DSFail", id), "exhaustion6", getState("Exhaustion 6", id))]
[h, macro("dnd5e_applyHealth@Lib:DnD5e"): params]