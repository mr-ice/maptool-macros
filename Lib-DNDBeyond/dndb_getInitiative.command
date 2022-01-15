[h: toon = arg (0)]
[h: dndb_Constants(getMacroName())]
<!-- slim down -->
[h: data = json.get (toon, "data")]
[h: dataRetains = json.append ("", "race", "modifiers", "inventory", "classes", "stats", "bonusStats", "overrideStats", "characterValues")]
[h: skinnyData = dndb_getSkinnyObject (data, dataRetains)]
<!-- Skinnify the toon -->
[h: skinnyToon = json.set (toon, "data", skinnyData)]

[h: modSearchArgs = json.set ("", "object", skinnyToon,
							"subType", "initiative")]

[h: initMods = dndb_searchGrantedModifiers (modSearchArgs)]
[h: log.debug ("initMods = " + initMods)]
[h: bonus = 0]
[h: proficiencyVar = 0]
[h, foreach (initMod, initMods), code: {
	[h: type = json.get (initMod, "type")]
	[h: initModId = json.get (initMod, "id")]
	[h, if (initModId == ID_QUICKDRAW): type = "proficiency"]
	[h: modBonus = 0]
	[h: profBonus = 0]
	[h, switch (type):
		case "bonus": modBonus = dndb_getModValue (skinnyToon, initMod);
		case "half-proficiency": profBonus = 0.5);
		case "proficiency": profBonus = 1;
		case "expertise": profBonus = 2; 
		default: "Don't care right now"]
	[h: proficiencyVar = max (proficiencyVar, profBonus)]
	[h: bonus = bonus + modBonus]
}]
[h: initBonusObj = json.set ("", "bonus", bonus, "proficiency", proficiencyVar)]
[h: macro.return = initBonusObj]