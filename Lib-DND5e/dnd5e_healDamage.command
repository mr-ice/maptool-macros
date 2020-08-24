<!-- Read the parameters -->
[h: log.debug("dnd5e_healDamage: " + json.indent(macro.args, 2))]
[h: id = json.get(macro.args, "id")]
[h: current = json.get(macro.args, "current")]
[h, if (!isNumber(current)): current = 0; '']
[h: healing = json.get(macro.args, "healing")]
[h, if (!isNumber(healing)): healing = 0; '']
[h: maximum = json.get(macro.args, "maximum")]
[h, if (!isNumber(maximum)): maximum = 0; '']
[h: log.debug("Before: current=" + current + " maximum=" + maximum + " healing=" + healing)]

<!-- Add healing to health up to max health -->
[h: current = current + healing]
[h, if (current > maximum): current = maximum; ""]
[h: log.debug("After: current=" + current)]

<!-- Update the toon  -->
[h: params = json.set("{}", "id", id, "current", current, "temporary", getProperty("TempHP", id), "maximum", maximum),
	"dsPass", getProperty("DSPass", id), "dsFail", getProperty("DSFail", id), "exhaustion6", getState("Exhaustion 6", id))]
[h, macro("dnd5e_applyHealth@Lib:DnD5e"): params]