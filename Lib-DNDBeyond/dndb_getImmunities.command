[h: toon = arg (0)]
[h: searchObj = json.set ("", "object", toon, "type", "immunity")]
[h: resistanceMods = dndb_searchGrantedModifiers (searchObj)]
[h: resistanceNames = "[]"]
[h, foreach (resistanceMod, resistanceMods), code: {
	[resistanceName = json.get (resistanceMod, "friendlySubtypeName")]
	[resistanceNames = json.append (resistanceNames, resistanceName)]
}]
[h: resistanceNames = json.sort (json.unique (resistanceNames))]
[h: macro.return = resistanceNames]