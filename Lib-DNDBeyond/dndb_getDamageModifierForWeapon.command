<!-- Callers must pass in the character json themselves. No getter methods should shoulder the -->
<!-- responsibility of calling dndb_getCharJSON -->
<!-- Requires two parameters: toon json and weapon object -->
[h: toon = arg(0)]
[h: weapon = arg (1)]
[h, if (json.length (macro.args) > 2): characterValues = arg (2); characterValues = "[]"]

[h: bonusType = "damage"]

<!-- Calculates attack bonus, including that which comes from the toon's attributes -->
[h: attributes = dndb_getAbilities (toon)]
[h: strBonus = round (math.floor((json.get (attributes, "str") - 10 ) / 2))]
[h: dexBonus = round (math.floor((json.get (attributes, "dex") - 10 ) / 2))]
[h: finesseBonus = max (strBonus, dexBonus)]

[h, if (json.get (weapon, "attackType") == "Melee"): abilityBonus = strBonus; abilityBonus = dexBonus]
[h: finesse = json.path.read (weapon, "properties.[?(@.name == 'Finesse')]")]
[h, if (json.length (finesse) > 0): abilityBonus = finesseBonus]

[h: totalBonus = abilityBonus]

[h: classModifiers = json.path.read (toon, "data.modifiers.class..[?(@.type == '" + bonusType + "')]")]

<!-- WIP: we only know of some class abilities to parse -->
[r, foreach (classModifier, classModifiers), code : {
	<!-- Assume qualified and eliminate from there -->

	[h: qualified = 1]
	[h: bonus = json.get (classModifier, "value")]
	[h: qualified = dndb_isWeaponModifierApplicable (classModifier, weapon)]

	[h, if (qualified > 0), code: {
		[h: totalBonus = totalBonus + bonus]
		[h: log.debug (json.indent (classModifier))]
	}]
}]

<!-- no qualification checks on Race, yet -->
[h: raceDamageModifiers = json.path.read (toon, "data.modifiers.race..[?(@.type == '" + bonusType + "')]")]
[h, foreach (raceDamageModifier, raceDamageModifiers), code: {
	[h: bonus = json.get (raceDamageModifier, "value")]
	[h: totalBonus = totalBonus + bonus]
}]

<!-- apply item bonuses only if equipped -->
[h: itemModifiers = json.path.read (toon, "data.modifiers.item..[?(@.type == '" + bonusType + "')]")]
<!-- for ech itemDamageMod, get the componentId. Find the item in inventory with the matching id and check equipped -->
[h, foreach (itemModifier, itemModifiers), code: {
	<!-- itemModifier may have attack specific sub-types -->
	[h: qualified = dndb_isWeaponModifierApplicable (itemModifier, weapon)]
	[h, if (qualified > 0): log.debug (json.indent (itemModifier))]
	[h: componentId = json.get (itemModifier, "componentId")]
	[h: items = json.path.read (toon, "data.inventory..[?(@.definition.id == '" + componentId + "')]")]
	<!-- should only be one -->
	[h: item = json.get (items, 0)]
	[h: bonus = json.get (itemModifier, "value")]
	[h: equipped = json.get (item, "equipped")]
	[h, if (equipped != "true"): qualified = 0]

	[h, if (qualified > 0): totalBonus = totalBonus + bonus]
}]

<!-- finally, bonuses on the weapon itself -->
[h: bonus = json.get (weapon, "bonus")]
[h: totalBonus = totalBonus + bonus]

<!-- Real finally, did the user override -->
[h: charValueSearchObj =  json.set ("", "object", characterValues, "valueId", json.get (weapon, "id"), "typeId", 10)]
[h: overrideResults = dndb_searchJsonObject (charValueSearchObj)]
[h, if (json.length (overrideResults) > 0): totalBonus = totalBonus + json.get (json.get (overrideResults, 0), "value"); ""]

[h: macro.return = totalBonus]
