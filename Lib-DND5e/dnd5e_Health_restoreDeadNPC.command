[h: list = getLibProperty("_deadTokens", "Lib:DnD5e")]
[h, if (json.isEmpty(list)), code: {
	[h: broadcast("There are currently no dead tokens listed", "gm")]
	[h: return(0, "")]
}; {""}]
[h: last = json.length(list) - 1]
[h: lastDeadToken = json.get(list, last)]
[h: list = json.remove(list, last)]
[h: lastId = json.get(lastDeadToken, "id")]
[h: init = json.get(lastDeadToken, "initiative")]
[h, if (!isNumber(init)): init = 0]
[h: params = json.set("{}", "id", lastId, "current", "HP", "maximum", "MaxHP", "healing", 1)]
[h: dnd5e_healDamage(params)]
[h: log.debug(getMacroName() + ": name=" + getName(lastId))]
[h: setLibProperty("_deadTokens", list, "Lib:DnD5e")]
[h: setLayer("TOKEN", lastId)]
[h: addToInitiative(0, init, lastId)]
[h: sortInitiative()]