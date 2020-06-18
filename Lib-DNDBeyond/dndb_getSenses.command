[h: toon = arg (0)]

[h: VISION_NAMES = json.append ("", "Darkvision", "Blindsight", "Truesight", "Tremorsense")]

[h: data = json.get (toon, "data")]
[h: dataRetains = json.append ("", "modifiers", "inventory", "classes", "stats", "bonusStats", "overrideStats")]
[h: skinnyData = dndb_getSkinnyObject (data, dataRetains)]
<!-- Skinnify the toon -->
[h: skinnytoon = json.set (toon, "data", skinnyData)]

[h: searchObj = json.set ("", "object", skinnytoon,
							"type", "set-base")]
[h: baseMods = dndb_searchGrantedModifiers (searchObj)]

[h: searchObj = json.set (searchObj, "type", "sense")]
[h: bonusMods = dndb_searchGrantedModifiers (searchObj)]

[h: visions = "[]"]
<!-- set the bases -->
[h, foreach (visionName, VISION_NAMES), code: {
	[h: log.debug ("dndb_getSenses: visionName = " + visionName)]
	[h: lVisionName = lower (visionName)]
	<!-- search in the base Mod for the biggest base value -->
	[h: modSearchObj = json.set ("", "object", baseMods,
								"subType", lVisionName,
								"property", "value")]
	[h: distances = dndb_searchJsonObject (modSearchObj)]
	[h: log.debug ("base distances: " + distances)]
	[h, if (json.length (distances) == 0), code: {
		[h: distance = 0]
	}; {
		[h: distances = json.sort (distances, "desc")]
		[h: distance = json.get (distances, 0)]
	}]
	[h: baseDistance = distance]

	<!-- add the bonsues -->
	[h: modSearchObj = json.set (modSearchObj, "object", bonusMods)]
	[h: distances = dndb_searchJsonObject (modSearchObj)]
	[h: log.debug ("bonus distances: " + distances)]
	[h, if (json.length (distances) == 0), code: {
		[h: distance = 0]
	}; {
		[h: distances = json.sort (distances, "desc")]
		[h: distance = json.get (distances, 0)]
	}]
	[h: bonusDistance = distance]
	
	[h: vision = json.set ("", "name", visionName, "distance", baseDistance + bonusDistance)]	
	[h: visions = json.append (visions, vision)]
}]

[h: macro.return = visions]