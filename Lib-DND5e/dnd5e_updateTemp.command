<!-- Read the parameters -->
[h: log.debug("dnd5e_updateTemp: " + json.indent(macro.args, 2))]
[h: id = json.get(macro.args, "id")]
[h: temporary = json.get(macro.args, "temporary")]
[h, if (!isNumber(temporary)): temporary = 0; '']
[h: updateTemp = json.get(macro.args, "updateTemp")]
[h, if (!isNumber(updateTemp)): updateTemp = 0; '']
[h: log.debug("Before: temporary=" + temporary + " updateTemp=" + updateTemp)]

<!-- The temp hit points is the max between the two value -->
[h: temporary = math.max(temporary, updateTemp)]
[h: log.debug("After: temporary=" + temporary)]

<!-- Update the toon  -->
[h: params = json.set("{}", "id", id, "temporary", temporary, "current", getProperty("HP", id), "maximum", getProperty("MaxHP", id)),
	"dsPass", getProperty("DSPass", id), "dsFail", getProperty("DSFail", id), "exhaustion6", getState("Exhaustion 6", id))]
[h, macro("dnd5e_applyHealth@Lib:DnD5e"): params]