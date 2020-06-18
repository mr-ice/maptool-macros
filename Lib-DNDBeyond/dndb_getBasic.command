[h: toon = arg (0)]

<!-- stuff it into a single json object -->
<!-- The easy bits -->
<!-- need this for init, and I need to come back and do an init DTO -->
[h: abilities = dndb_getAbilities (toon)]
[h: log.info ("dndb_getBasic: Building base details")]
[h: basicToon = json.set ("", "name", replace (json.path.read (toon, "data.name"),"null", ""),
						"age", replace (json.path.read (toon, "data.age"),"null", ""),
						"faith", replace (json.path.read (toon, "data.faith"),"null", ""),
						"hair", replace (json.path.read (toon, "data.hair"),"null", ""),
						"eyes",  replace (json.path.read (toon, "data.eyes"),"null", ""),
						"skin", replace (json.path.read (toon, "data.skin"),"null", ""),
						"height", replace (json.path.read (toon, "data.height"),"null", ""),
						"weight", replace (json.path.read (toon, "data.weight"),"null", ""),
						"xp", replace (json.path.read (toon, "data.currentXp"),"null", ""),
						"gender", replace (json.path.read (toon, "data.gender"),"null", ""),
						"avatarUrl", replace (json.path.read (toon, "data.avatarUrl"),"null", ""),
						"url", replace (json.path.read (toon, "data.readonlyUrl"),"null", ""),
						"abilities", abilities)]


<!-- alightment map -->
[h: log.info ("dndb_getBasic: Alignment")]
[h: alignmentMap = json.set ("", "1", "LG",
							     "2", "NG",
							     "3", "CG",
							     "4", "LN",
							     "5", "N",
							     "6", "CN",
							     "7", "LE",
							     "8", "NE",
							     "9", "CE",
							     "10", "Unaligned")]
[h: alignmentId =  json.path.read (toon, "data.alignmentId")]
[h: basicToon = json.set (basicToon, "alignment", json.get (alignmentMap, alignmentId))]

<!-- character level -->
[h: log.info ("dndb_getBasic: Character level")]
[h: totalLevel = 0]
[h: classArry = ""]
[h, foreach (class, json.path.read (toon, "data.classes")), code: {
	[h: level = json.get (class, "level")]
	[h: totalLevel = totalLevel + level]
	[h: className = json.path.read (class, "definition.name")]
	[h: classObj = json.set ("", "className", className, "level", level)]
	[h: hitDice = json.path.read (class, "definition.hitDice")]
	[h: hitDiceUsed = json.get (class, "hitDiceUsed")]
	[h: classObj = json.set (classObj, "hitDice", hitDice, "hitDiceUsed", hitDiceUsed)]
	[h: classArry = json.append (classArry, classObj)]
}]
[h: log.debug ("classArry: "+ classArry)]
[h: basicToon = json.set (basicToon, "classes", classArry)]

<!-- Senses -->
[h: log.info ("dndb_getBasic: Senses")]
[h: senses = dndb_getSenses (toon)]
[h: basicToon = json.set (basicToon, "senses", senses)]

<!-- HP -->
[h: log.info ("dndb_getBasic: Hitpoints")]
[h: hitPoints = dndb_getHitPoints (toon)]
[h: basicToon = json.set (basicToon, "hitPoints", hitPoints)]

<!-- Speed -->
[h: log.info ("dndb_getBasic: Speed")]
[h: speeds = dndb_getSpeed (toon)]
[h: basicToon = json.set (basicToon, "speeds", speeds)]
[h: log.info ("dndb_getBasic: Done!")]
[h: macro.return = basicToon]