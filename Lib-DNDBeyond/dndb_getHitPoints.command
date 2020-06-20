[h: toon = arg (0)]

<!-- HP -->
[h: totalLevel = 0]
[h: classArry = ""]

[h, foreach (class, json.path.read (toon, "data.classes")), code: {
	[h: level = json.get (class, "level")]
	[h: totalLevel = totalLevel + level]
	[h: className = json.path.read (class, "definition.name")]
	[h: classObj = json.set ("", "className", className, "level", level)]
	[h: hitDice = json.path.read (class, "definition.hitDice")]
	[h: classObj = json.set (classObj, "hitDice", hitDice)]
	[h: classArry = json.append (classArry, classObj)]
}]

[h: abilities = dndb_getAbilities (toon)]
[h: baseHp =  json.path.read (toon, "data.baseHitPoints")]
[h: maxHp = baseHp + (json.get (abilities, "conBonus") * totalLevel)]
[h: damageTaken = json.path.read (toon, "data.removedHitPoints")]
[h: temporaryHitPoints = json.path.read (toon, "data.temporaryHitPoints")]
[h: maxHpModifier = json.path.read (toon, "data.bonusHitPoints")]
[h: overrideMaxHp = json.path.read (toon, "data.overrideHitPoints")]
[h, if (maxHpModifier != "" && isNumber (maxHpModifier)): maxHp = maxHp + number (maxHpModifier)]
[h, if (overrideMaxHp != "" && isNumber (overrideMaxHp)): maxHp = number (overrideMaxHp)]

[h: deathSaves = json.path.read (toon, "data.deathSaves")]
[h: dsPass = json.get (deathSaves, "successCount")]
[h, if (dsPass == "null"): dsPass = 0]
[h: dsFail = json.get (deathSaves, "failCount")]
[h, if (dsFail == "null"): dsFail = 0]


[h: hitPoints =  json.set ("",
							"maxHp", maxHp,
							"currentHp", maxHp - damageTaken,
							"tempHp", temporaryHitPoints,
							"dsPass", dsPass,
							"dsFail", dsFail)]
[h: macro.return = hitPoints]
