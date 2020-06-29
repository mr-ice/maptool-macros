[h: toon = arg (0)]

<!-- slim down -->
[h: data = json.get (toon, "data")]
[h: dataRetains = json.append ("", "race", "modifiers", "inventory", "classes", "stats", "bonusStats", "overrideStats", "characterValues")]
[h: skinnyData = dndb_getSkinnyObject (data, dataRetains)]
<!-- Skinnify the toon -->
[h: skinnyToon = json.set (toon, "data", skinnyData)]

[h: abilities = dndb_getAbilities (toon)]
[h: init = json.get (abilities, "dexBonus")]
[h: modSearchArgs = json.set ("", "object", skinnyToon,
							"subType", "initiative")]

[h: initMods = dndb_searchGrantedModifiers (modSearchArgs)]
[h: proficiency = dndb_getProficiencyBonus (toon)]
[h, foreach (initMod, initMods), code: {
	[h: type = json.get (initMod, "type")]
	[h: modBonus = 0]
	[h, switch (type):
		case "bonus": modBonus = dndb_getModValue (skinnyToon, initMod);
		case "half-proficiency": modBonus = round (math.floor (proficiency / 2));
		case "proficiency": modBonus = proficiency;
		case "expertise": modBonus = proficiency * 2; 
		default: "Don't care right now"]
	[h: init = init + modBonus]
}]

[h: macro.return = init]