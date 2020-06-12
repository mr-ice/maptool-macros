<!-- Instead of the usual arg array, try a json obj -->
[h: filterObj = arg(0)]
[h: toon = json.get (filterObj, "object")]
[h: property = json.get (filterObj, "property")]

<!-- filterObj is only filter terms. Well provide our own object and stuff property back in as needed -->
<!-- TODO: I have to pass this object around now, so preserve the original and roll yer own here -->
[h: filterObj = json.remove (filterObj, "object")]
[h: filterObj = json.remove (filterObj, "property")]

<!-- Item bonuses are listed in the modifiers object, but should not apply if the associated object isnt -->
<!-- equipped. This first retreives a list of equipped items and builds an arry of ids. Then full modifier -->
<!-- objects are pulled from items and their componentIds checked against equipped ids -->

[h: log.debug ("Searching item")]
[h: items = json.path.read (toon, "data.inventory")]
[h: equippedItems = json.path.read (items, ".[?(@.equipped == true)]")]
[h: equippedItemIds = json.path.read (equippedItems, "[*].definition.id")]
[h: log.debug ("Equipped items: " + equippedItemIds)]

<!-- now search for modifications from just item and compare componentId with equipped ids -->
[h: itemSearchArg = json.set (filterObj, "object", json.path.read (toon, "data.modifiers.item"))]
[h: itemSearchResults = dndb_searchJsonObject (itemSearchArg)]
[h: log.debug ("Item search results: " + json.indent (itemSearchResults))]
[h: equippedModifiers = "[]"]
[h, foreach (itemModification, itemSearchResults), code: {
	[h: componentId = json.get (itemModification, "componentId")]
	[h, if (json.contains (equippedItemIds, componentId) > 0), code: {
		[h: log.debug ("Modification is equipped")]
		<!-- marshall the result, either scalar or object, into a list -->
		[h, if (property != ""): itemModification = json.path.read (itemModification, property);
								 itemModification = json.append ("", itemModification)]
		[h: equippedModifiers = json.merge (equippedModifiers, itemModification)]
	}]
}]

[h: macro.return = equippedModifiers]