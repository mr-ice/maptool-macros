[h: toon = arg (0)]

<!-- stuff it into a single json object -->
<!-- The easy bits -->
[h: basicToon = json.set ("", "name", json.path.read (toon, "data.name"),
						"age", json.path.read (toon, "data.age"),
						"faith", json.path.read (toon, "data.faith"),
						"hair", json.path.read (toon, "data.hair"),
						"eyes",  json.path.read (toon, "data.eyes"),
						"skin", json.path.read (toon, "data.skin"),
						"height", json.path.read (toon, "data.height"),
						"weight", json.path.read (toon, "data.weight"),
						"xp", json.path.read (toon, "data.currentXp"),
						"gender", json.path.read (toon, "data.gender"),
						"avatarUrl", json.path.read (toon, "data.avatarUrl"),
						"url", json.path.read (toon, "data.readonlyUrl"))]

<!-- alightment map -->
[h: alignmentMap = json.set ("", "3", "CE")]
[h: alignmentId =  json.path.read (toon, "data.alignmentId")]
[h: basicToon = json.set (basicToon, "alignment", json.get (alignmentMap, alignmentId))]

<!-- character level -->
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
[h: log.debug ("classArry: "+ classArry)]
[h: basicToon = json.set (basicToon, "classes", classArry)]

<!-- HP -->
[h: abilities = dndb_getAbilities (toon)]
[h: baseHp =  json.path.read (toon, "data.baseHitPoints")]
[h: maxHp = baseHp + (json.get (abilities, "conBonus") * totalLevel)]
[h: damageTaken = json.path.read (toon, "data.removedHitPoints")]
[h: temporaryHitPoints = json.path.read (toon, "data.temporaryHitPoints")]
[h: maxHpModifier = json.path.read (toon, "data.bonusHitPoints")]
[h: overrideMaxHp = json.path.read (toon, "data.overrideHitPoints")]
[h, if (maxHpModifier != "" && isNumber (maxHpModifier)): maxHp = maxHp + number (maxHpModifier)]
[h, if (overrideMaxHp != "" && isNumber (overrideMaxHp)): maxHp = number (overrideMaxHp)]

[h: basicToon = json.set (basicToon, "hitPoints", json.set ("",
							"maxHp", maxHp,
							"currentHp", maxHp - damageTaken,
							"tempHp", temporaryHitPoints))]

<!-- Speed -->
[h: speeds = dndb_getSpeed (toon)]
[h: basicToon = json.set (basicToon, "speeds", speeds)]

<!-- Vision -->
[h: vision = dndb_getVision (toon)]
[h: basicToon = json.set (basicToon, "vision", vision)]

[h: macro.return = basicToon]