<!-- Callers must pass in the character json themselves. No getter methods should shoulder the -->
<!-- responsibility of calling dndb_getCharJSON -->
<!-- Requires two parameters: toon json and weapon object -->
[h: toon = arg(0)]
[h: weapon = arg (1)]
[h, if (json.length (macro.args) > 2): characterValues = arg (2); characterValues = "[]"]

[h: log.debug ("dndb_getAttackModifierForWeapon")]

<!-- Calculates attack bonus, including that which comes from the toon's attributes -->
[h: attributes = dndb_getAbilities (toon)]
[h: strBonus = round (math.floor((json.get (attributes, "str") - 10 ) / 2))]
[h: dexBonus = round (math.floor((json.get (attributes, "dex") - 10 ) / 2))]
[h: finesseBonus = max (strBonus, dexBonus)]
[h: log.debug ("strBonus: " + strBonus + " - dexBonus: " + dexBonus + " - finesseBonus" + finesseBonus)]

[h, if (json.get (weapon, "attackType") == "Melee"): abilityBonus = strBonus; abilityBonus = dexBonus]
[h: finesse = json.path.read (weapon, "properties.[?(@.name == 'Finesse')]")]
[h, if (json.length (finesse) > 0): abilityBonus = finesseBonus]
[h: totalAtkBonus = abilityBonus]
[h: log.debug ("abilityBonus: " + abilityBonus)]

<!-- apply proficiency bonus -->
[h: proficiencyBonus = dndb_getProficiencyBonus (toon)]
[h: proficient = json.get (weapon, "proficient")]
[h, if (proficient > 0): totalAtkBonus = totalAtkBonus + proficiencyBonus]
[h: log.debug ("proficiencyBonus: " + proficiencyBonus + " - totalAtkBonus: " + totalAtkBonus)]

[h: classAtkModifiers = json.path.read (toon, "data.modifiers.class..[?(@.type == 'bonus')]")]

<!-- WIP: we only know of some class abilities to parse -->
[h, foreach (classAtkModifier, classAtkModifiers), code : {
	[h: bonus = json.get (classAtkModifier, "value")]
	[h: qualified = dndb_isWeaponModifierApplicable (classAtkModifier, weapon)]
	[h, if (qualified > 0), code: {
		[h: totalAtkBonus = totalAtkBonus + bonus]
		[h: log.debug (json.indent (classAtkModifier, 3))]
		[h: log.debug ("qualified: " + qualified)]

	}]
}]

[h: log.debug ("totalAtkBonus after class: " + totalAtkBonus)]
<!-- no Race bonus to apply, yet. need a use case -->


<!-- apply item bonuses only if equipped -->
[h: itemAtkModifiers = json.path.read (toon, "data.modifiers.item..[?(@.type == 'bonus')]")]
<!-- for ech itemDamageMod, get the componentId. Find the item in inventory with the matching id and check equipped -->
[h, foreach (itemAtkModifier, itemAtkModifiers), code: {
	[h: qualified = dndb_isWeaponModifierApplicable (itemAtkModifier, weapon)]
	[h, if (qualified > 0): log.debug (json.indent (itemAtkModifier, 3))]
	[h: log.debug ("qualified: " + qualified)]
	
	[h: componentId = json.get (itemAtkModifier, "componentId")]
	[h: items = json.path.read (toon, "data.inventory..[?(@.definition.id == '" + componentId + "')]")]
	<!-- should only be one -->
	[h: item = json.get (items, 0)]
	[h: bonus = json.get (itemAtkModifier, "value")]
	[h: equipped = json.get (item, "equipped")]
	[h, if (equipped != "true"): qualified = 0]
	[h: log.debug ("Qualified after equipped: " + qualified)]
	[h, if (qualified > 0): totalAtkBonus = totalAtkBonus + bonus]
}]

[h: log.debug ("totalAtkBonus after item: " + totalAtkBonus)]

<!-- finally, bonuses on the weapon itself. No check for equipped here. -->
[h: bonus = json.get (weapon, "bonus")]
[h: totalAtkBonus = totalAtkBonus + bonus]

<!-- Real finally, did the user override -->
<!-- adds to the bonus -->
[h: charValueSearchObj =  json.set ("", "object", characterValues, "valueId", json.get (weapon, "id"), "typeId", 12)]
[h: overrideResults = dndb_searchJsonObject (charValueSearchObj)]
[h, if (json.length (overrideResults) > 0): totalAtkBonus = totalAtkBonus +  json.get (json.get (overrideResults, 0), "value"); ""]

<!-- overrides the bonus -->
[h: charValueSearchObj = json.set (charValueSearchObj, "typeId", 13)]
[h: overrideResults = dndb_searchJsonObject (charValueSearchObj)]
[h, if (json.length (overrideResults) > 0): totalAtkBonus = json.get (json.get (overrideResults, 0), "value"); ""]
[h: log.debug ("totalAtkBonus after weapon bonus: " + totalAtkBonus)]

[h: macro.return = totalAtkBonus]