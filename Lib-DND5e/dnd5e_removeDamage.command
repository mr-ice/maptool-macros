<!-- If called as a function get the object from the first parameter, then read the object -->
[h: log.debug("dnd5e_removeDamage: " + json.indent(macro.args))]
[h, if(json.type(macro.args) == "ARRAY"): macro.args = json.get(macro.args, 0)]
[h: id = json.get(macro.args, "id")]
[h, if (json.isEmpty(id) || lower(id) == "currenttoken"): id = currentToken()]
[h: current = json.get(macro.args, "current")]
[h, if (!isNumber(current)): current = getProperty(current, id)]
[h, if (!isNumber(current)): current = 0]
[h: dmg = json.get(macro.args, "damage")]
[h, if (!isNumber(dmg)): dmg = 0]
[h, if (dmg == 0): text = "none"; text = "damage"]
[h: temporary = json.get(macro.args, "temporary")]
[h, if (!isNumber(temporary)): temporary = getProperty(temporary, id)]
[h, if (!isNumber(temporary)): temporary = 0]
[h: log.debug("dnd5e_removeDamage: current=" + current + " temporary=" + temporary + " damage=" + dmg)]

<!-- Remove damage temp first, then current -->
[h, if (dmg >= temporary), code: {
	[h: dmg = dmg - temporary]
	[h: temporary = 0]
};{
	[h: temporary = temporary - dmg]
	[h: dmg = 0]
}]
[h, if (dmg >= current): current = 0; current = current - dmg]
[h: log.debug("dnd5e_removeDamage After: current=" + current + " temporary=" + temporary)]

<!-- Update the toon  -->
[h: params = json.set("{}", "id", id, "current", current, "temporary", temporary, "maximum", getProperty("MaxHP", id),
	"dsPass", getProperty("DSPass", id), "dsFail", getProperty("DSFail", id), "exhaustion6", getState("Exhaustion 6", id),
	"text-type", text, "text-value", dmg)]
[h, macro("dnd5e_applyHealth@Lib:DnD5e"): params]