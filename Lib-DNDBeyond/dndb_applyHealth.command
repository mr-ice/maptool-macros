[h: basicToon = dndb_getBasicToon ()]
[h: hitPoints = json.get(basicToon, "hitPoints")]
[h: params = json.set("{}", "id", currentToken(), "current", json.get(hitPoints, "currentHp"), 
	"temporary", json.get(hitPoints, "tempHp"), "maximum", json.get(hitPoints, "maxHp"),
	"dsPass", json.get(hitPoints, "dsPass"), "dsFail", json.get(hitPoints, "dsFail"), 
	"exhaustion6", getState("Exhaustion 6"))]
[h, macro("dnd5e_applyHealth@Lib:DnD5e"): params]