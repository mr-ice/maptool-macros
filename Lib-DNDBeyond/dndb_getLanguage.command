[h: toon = arg (0)]
[h: searchArg = json.set ("", "object", toon,
							"type", "language")]
[h: modifiers = dndb_searchGrantedModifiers (searchArg)]
[h: languageArry = "[]"]
[h, foreach (modifier, modifiers), code: {
	[languageArry = json.append (languageArry, json.get (modifier, "friendlySubtypeName"))]
}]
[h: macro.return = languageArry]