[h: toon = arg(0)]

<!-- look in data.modifiers for 'type == natural-weapon' -->

<!-- for each modifier found, search for data.actions.race for -->
<!-- the corresponding component ID -->

[h: data = json.get (toon, "data")]
[h: skinnyData = dndb_getSkinnyObject (data, json.append ("", "actions", "modifiers",
							"inventory", "classes", "stats", "bonusStats", "overrideStats"))]
[h: skinnyToon = json.set (toon, "data", skinnyData)]

[h: searchObj = json.set ("", "object", skinnyToon,
							"type", "natural-weapon")]

[h: naturalWeaponMods = dndb_searchGrantedModifiers (searchObj)]
[h: naturalWeapons = "[]"]
[h, foreach (naturalWeaponMod, naturalWeaponMods), code: {
	[h: componentId = json.get (naturalWeaponMod, "componentId")]
	[h: actionSearchObj = json.set ("", 
							"object", json.path.read (skinnyToon, "data.actions.race"),
							"componentId", componentId)]
	[h: actions = dndb_searchJsonObject (actionSearchObj)]
	<!-- Should only be one. Or I only care about one -->
	[h: action = json.get (actions, 0)]
	[h, switch (json.get (action, "actionType")):
		case "1": attackType = "Melee";
		case "2": attackType = "Ranged";
		default: attackType = "Natural"
	]
	[h, switch (json.get (action, "attackTypeRange")):
		case "1": range = "5";
		default: range = "Dunno"
	]
	[h: name = json.get (action, "name")]
	[h: properties = json.append ("", json.set ("", "description", "Natural Attack", "name", name))]
	[h: naturalWeapon = json.set ("", "name", name,
							"attackType", attackType,
							"dmgDie", json.path.read (action, "dice.diceValue"),
							"dmgDice", json.path.read (action, "dice.diceCount"),
							"dmgType", json.get (naturalWeaponMod, "friendlySubtypeName"),
							"range", range,
							"type", json.get (naturalWeaponMod, "friendlyTypeName"),
							"proficient", 1,
							"isMonk", "true",
							"properties", properties,
							"equipped", "true")]
	[h: naturalWeapons = json.append (naturalWeapons, naturalWeapon)]
}]

[h: macro.return = naturalWeapons]