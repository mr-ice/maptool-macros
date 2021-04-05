<!-- Read the parameters -->
[h: log.debug(getMacroName() + ": " + json.indent(macro.args))]
[h, if (json.type(macro.args) == "ARRAY"): macro.args = json.get(macro.args, 0)]
[h: id = json.get(macro.args, "id")]
[h, if (json.isEmpty(id) || lower(id) == "currentToken"): id = currentToken()]
[h: current = json.get(macro.args, "current")]
[h, if (!isNumber(current)): current = getProperty(current, id)]
[h, if (!isNumber(current)): current = 0; '']
[h: healing = json.get(macro.args, "healing")]
[h, if (!isNumber(healing)): healing = 0; '']
[h, if (healing == 0): text = "none"; text = "healed"]
[h: maximum = json.get(macro.args, "maximum")]
[h, if (!isNumber(maximum)): maximum = getProperty(maximum, id)]
[h, if (!isNumber(maximum)): maximum = 0; '']
[h: log.debug(getMacroName() + "Before: current=" + current + " maximum=" + maximum + " healing=" + healing)]

<!-- Add healing to health up to max health -->
[h: current = current + healing]
[h, if (current > maximum): current = maximum; ""]
[h: log.debug("After: current=" + current)]

<!-- Update the toon  -->
[h: params = json.set("{}", "id", id, "current", current, "temporary", getProperty("TempHP", id), "maximum", maximum,
	"dsPass", getProperty("DSPass", id), "dsFail", getProperty("DSFail", id), "exhaustion6", getState("Exhaustion 6", id),
	"text-type", text, "text-value", healing)]
[h, macro("dnd5e_applyHealth@Lib:DnD5e"): params]