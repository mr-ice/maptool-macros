<!-- Instead of the usual arg array, try a json obj -->
[h: filterObj = arg(0)]
[h: toon = json.get (filterObj, "object")]
[h: property = json.get (filterObj, "property")]
[h: log.debug ("dndb_searchGrantedModifiers: property = " + property)]

[h: resultArry = ""]

<!-- whatevers in equippedModifiers is what we want -->
[h: equippedModifiers = dndb_searchForItemGrantedModifiers (filterObj)]
[h: log.debug ("dndb_searchGrantedModifiers: equippedModifiers = " + equippedModifiers)]
[h: resultArry = json.merge (resultArry, equippedModifiers)]


<!-- Ok, classes are next. Anything that is: -->
[h: classArry = dndb_searchForClassGrantedModifiers (filterObj)]
[h: log.debug ("dndb_searchGrantedModifiers: classArry = " + classArry)]
[h: resultArry = json.merge (resultArry, classArry)]

<!-- filterObj is only filter terms. Well provide our own object and stuff property back in as needed -->

[h: filterObj = json.remove (filterObj, "object")]
[h: filterObj = json.remove (filterObj, "property")]

<!-- everything else gets the same treatement -->
<!-- Abstracting Items and Class makese sense since they have special treatement. -->
<!-- Any purpose in doing the same for these? Outside of this script, no sure what -->
<!-- would want to call these scripts anyways -->
[h: nonItems = json.append ("", "background", "condition", "feat", "race")]

[h, foreach (classification, nonItems), code: {
	[h: log.debug ("Searching " + classification)]
	[h: searchObjectPath = "data.modifiers." + classification]
	[h: searchObject = json.path.read (toon, searchObjectPath)]
	[h: subSearchArg = json.set (filterObj, "object", searchObject, "property", property)]

	[h: subSearchResults = dndb_searchJsonObject (subSearchArg)]
	[h: log.debug ("dndb_searchGrantedModifiers: subSearchResults = " + subSearchResults)]
	[h, if (json.length (subSearchResults) > 0): resultArry = json.merge (resultArry, subSearchResults)]
}]

[h: log.debug (resultArry)]
[h: macro.return = resultArry]