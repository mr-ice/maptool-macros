[h: toon = arg(0)]

[h, if (json.length (macro.args) > 1): allVisions = arg(1); allVisions = json.append ("", "Blindsight", "Darkvision", "Tremorsense", "Truesight")]
[h: visions = "[]"]

[h, foreach (vision, allVisions), code: {
	[h: distance = 0]
	[h: lowerVision = lower (vision)]
	[h: distances = dndb_searchGrantedModifiers (json.set ("", 
										"object", toon,
										"property", "value",
										"subType", lowerVision,
										"type", "set-base"))]
	[h: log.debug ("dndb_getVision: distances = " + distances]
	[h, if (json.length (distances) > 0), code: {
		[h: distance = json.get (json.sort (distances), 0)]
	}]

	[h: bonuses = dndb_searchGrantedModifiers (json.set ("", 
										"object", toon,
										"property", "value",
										"subType", lowerVision,
										"type", "sense"))]
	[h, foreach (bonus, bonuses): distance = distance + bonus]
	
	[h, if (distance > 0): visions = json.append (visions, json.set ("", 
										"name", vision, 
										"distance", distance))]
}]

[h: macro.return = visions]