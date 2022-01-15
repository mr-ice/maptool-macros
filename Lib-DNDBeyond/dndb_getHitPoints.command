[h: toon = arg (0)]

<!-- HP -->
[h: totalLevel = 0]
[h: classArry = ""]

<!-- Find hit-points-per-level modifiers -->
[h: hpPerLevelMods = dndb_searchGrantedModifiers (json.set ("", "object", toon,
													"type", "bonus",
													"subType", "hit-points-per-level"))]
[h: totalClassLevelBonus = 0]
[h, foreach (class, json.path.read (toon, "data.classes")), code: {
	[h: level = json.get (class, "level")]
	[h: totalLevel = totalLevel + level]
	[h: className = json.path.read (class, "definition.name")]
	[h: classObj = json.set ("", "className", className, "level", level)]
	[h: hitDiceVar = json.path.read (class, "definition.hitDice")]
	[h: classObj = json.set (classObj, "hitDice", hitDiceVar)]

	<!-- Search in modifiers for one that matches a class feature, add the bonus to class obj -->
	[h: classBonus = 0]
	[h, foreach (mod, hpPerLevelMods), code: {
		[h: results = dndb_searchJsonObject (json.set ("", "object", json.get (class, "classFeatures"),
														"id", json.get (mod, "componentId")))]
		[h, if (json.length (results) > 0): classBonus = classBonus + json.get (mod, "value")]
	}]
	[h: totalClassLevelBonus = totalClassLevelBonus + classBonus * level]
	[h: classObj = json.set (classObj, "classBonus", classBonus)]
	[h: classArry = json.append (classArry, classObj)]
}]

[h: abilities = dndb_getAbilities (toon)]
[h: baseHp =  json.path.read (toon, "data.baseHitPoints")]

<!-- search in modifiers for one that matches a racial feature, set a raceBonus -->
[h: raceBonus = 0]
[h: racialTraits = json.path.read (toon, "data.race.racialTraits")]
[h, foreach (mod, hpPerLevelMods), code: {
		[h: results = dndb_searchJsonObject (json.set ("", "object", racialTraits,
														"definition.id", json.get (mod, "componentId")))]
		[h, if (json.length (results) > 0): raceBonus = raceBonus + (totalLevel * json.get (mod, "value"))]
}]

<!-- add the class bonuses -->
[h: totalBonus = raceBonus + totalClassLevelBonus]
[h: maxHpVar = baseHp + totalBonus + (json.get (abilities, "conBonus") * totalLevel)]
[h: log.info ("dndb_getHitPoints: classArry = " + classArry + "
		baseHp = " + baseHp + "
		raceBonus = " + raceBonus + "
		totalBonus = " + totalBonus + "
		maxHpVar = " + maxHpVar)]
<!-- include race and class bonuses -->

[h: damageTaken = json.path.read (toon, "data.removedHitPoints")]
[h: temporaryHitPoints = json.path.read (toon, "data.temporaryHitPoints")]
[h: maxHpModifier = json.path.read (toon, "data.bonusHitPoints")]
[h: overrideMaxHp = json.path.read (toon, "data.overrideHitPoints")]
[h: log.info ("dndb_getHitPoints: damageTaken = " + damageTaken + "
		temporaryHitPoints = " + temporaryHitPoints + "
		maxHpModifier = " + maxHpModifier + "
		overrideMaxHp = " + overrideMaxHp)]
[h, if (maxHpModifier != "" && isNumber (maxHpModifier)): maxHpVar = maxHpVar + number (maxHpModifier)]
[h, if (overrideMaxHp != "" && isNumber (overrideMaxHp)): maxHpVar = number (overrideMaxHp)]

[h: deathSaves = json.path.read (toon, "data.deathSaves")]
[h: dsPass = json.get (deathSaves, "successCount")]
[h: dsPass = if (isNumber(dsPass), dsPass, 0)]
[h: dsFail = json.get (deathSaves, "failCount")]
[h: dsFail = if (isNumber(dsFail), dsFail, 0)]


[h: hitPoints =  json.set ("",
							"maxHp", maxHpVar,
							"currentHp", maxHpVar - damageTaken,
							"tempHp", temporaryHitPoints,
							"dsPass", dsPass,
							"dsFail", dsFail)]
							
[h: macro.return = hitPoints]