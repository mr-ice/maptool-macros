[h: toon = arg (0)]

[h: speedsMap = json.append ("",
			json.set ("", "name", "Burrow", "verb", "burrowing", "id", "2"),
			json.set ("", "name", "Climb", "verb", "climbing", "id", "3"),
			json.set ("", "name", "Swim", "verb", "swimming", "id", "5"),
			json.set ("", "name", "Walk", "verb", "walking", "id", "1"),
			json.set ("", "name", "Fly", "verb", "flying", "id", "4")
			)
]
[h, if (json.length (macro.args) > 1): 
	speedNames = json.append ("", arg(1));
	speedNames = json.append ("", "Burrow", "Climb", "Swim", "Walk", "Fly")
]

[h: speeds = "[]"]

<!-- Collect base speeds from ractial traits -->
[h: baseSpeeds = json.path.read (toon, "data.race.weightSpeeds.normal")]

<!-- toon goes on a diet -->
[h: data = json.get (toon, "data")]
[h: dataRetains = json.append ("", "modifiers", "inventory", "classes", "stats", "bonusStats", "overrideStats", "customSpeeds")]
[h: skinnyData = dndb_getSkinnyObject (data, dataRetains)]
[h: fatToon = toon]
[h: toon = json.set (toon, "data", skinnyData)]

<!-- all speeds bonuses -->
[h: allBonuses = dndb_searchGrantedModifiers (json.set ("", 
							"object", toon,
							"property", "value",
							"subType", "speed",
							"type", "bonus"))]
							
[h: log.debug ("allBonuses: " + allBonuses)]

[h: allBonus = 0]
[h, foreach (value, allBonuses): allBonus = allBonus + value]
							
[h: speedMods = dndb_searchGrantedModifiers (json.set ("", 
							"object", toon,
							"type", "set"))]

<!-- Foreach speed type, find all the granted bonuses -->
[h, foreach (speedName, speedNames), code: {
	<!-- I may have to revisit this after some testing, but so far Ive only found -->
	<!-- granted bonuses as setting speeds to innate-speed-swimming, for example. -->
	<!-- So look for those for each speed and well add the allBonus values after -->
	[h: templateSpeed = json.get (dndb_searchJsonObject (json.set ("", "object", speedsMap, "name", speedName)), 0)]
	[h: verbSpeed = json.get (templateSpeed, "verb")]
	[h: innateSpeed = "innate-speed-" + verbSpeed]

	[h: searchArg = json.set ("", "object", speedMods,
							"property", "value",
							"subType", innateSpeed)]
	[h: grantedSpeeds = dndb_searchJsonObject (searchArg)]

	[h: log.debug ("grantedSpeeds: " + json.indent (grantedSpeeds))]
	[h: setSpeed = 0]
	[h, if (json.length (grantedSpeeds) > 0), code: {
		<!-- get the biggest one -->
		[h: grantedSpeeds = json.sort (grantedSpeeds, "descending")]
		[h: setSpeed = json.get (grantedSpeeds, 0)]
	}]

	<!-- Find custom speeds and use as overrides -->
	[h: lowerName = lower (speedName)]
	[h: baseSpeed = json.get (baseSpeeds, lowerName)]
	[h: actualSpeed = math.max (baseSpeed, setSpeed)]
	<!-- if actualSpeed is 0, dont apply the allBonus to it -->
	[h, if (actualSpeed > 0): actualSpeed = actualSpeed + allBonus]

	<!-- Finally, look in data.customSpeeds. Treat these values as overrides -->
	[h: id = json.get (templateSpeed, "id")]
	[h: customSearchObj = json.set ("", "object", json.path.read (toon, "data.customSpeeds"),
									"movementId", id,
									"property", "distance")]
	[h: customSpeed = dndb_searchJsonObject (customSearchObj)]
	<!-- There will be exactly zero or one -->
	[h, if (encode (customSpeed) != "" && json.length (customSpeed) > 0): actualSpeed = json.get (customSpeed, 0)]
	[h: speed = json.set (templateSpeed, "speed", actualSpeed)]
	<!-- except for walk, dont populate speed 0 -->
	[h, if (lowerName == "walk" || actualSpeed > 0): speeds = json.append (speeds, speed)]
}]

[h: macro.return = speeds]


<!-- Determine encumberance? Its a variant, so skip for now until we determine -->
<!-- a good way of passing that flag -->