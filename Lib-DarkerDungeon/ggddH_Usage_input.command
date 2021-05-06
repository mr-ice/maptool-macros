<!-- Get all of the useables defined, create a named list -->
[h: useables = ggddH_Usage_getUsables()]
[h, if (json.isEmpty(useables)), code: {
	[h: existingList = "None Available"]
};{
	[h: existingList = json.toList(json.merge(json.append("[]", "Create New"), json.fields(useables, "json")))]
}]

<!-- Create all of the fields -->
[h: existingField = "edit|"+existingList+"|Edit Existing|LIST|VALUE=STRING"]
[h: dieSizes = json.append("[]", "d20", "d12", "d10", "d8", "d6", "d4", "Empty")]
[h: dieSides = json.append("[]", "20", "12", "10", "8", "6", "4", "0")]
[h: dieField = "dieSize|"+dieSizes+"|Use Die Size|LIST|SELECT=6 DELIMITER=JSON"]
[h: newField = "new|New Name|Create New|TEXT"]
[h: label = "crap|Choose an existing or create a new Useable|none|LABEL|SPAN=TRUE"]
[h: abort(input(label, newField, existingField, dieField))]
[h: log.info(getMacroName() + ": new=" + new + " edit=" + edit + " dieSize=" + dieSize)]
[h, if (edit == "None Available" || edit == "Create New"), code: {
	[h: assert(!json.isEmpty(new), "A unique name is required for a new useable")]
	[h: assert(!json.contains(useables, new), "A useable named '" + new + "' already exists")]
	[h: name = new]
};{
	[h: assert(json.contains(useables, edit), "No useable named '" + edit + "' exists")]
	[h: name = edit]
}]
[h: size = json.get(dieSides, dieSize)]
[h: useables = json.set(useables, name, size)]
[h: setProperty("ggdd_useables", useables)]
[h: ggddH_Usage_updateMacros(name, size, currentToken(), 1)]