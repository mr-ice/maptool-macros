[h: toon = arg(0)]
[h: weaponArry = arg(1)]

[h: basicArry = "[]"]

<!-- Get proficencies -->
[h: proficiencies = json.path.read (toon, "data.modifiers..[?(@.type == 'proficiency')]")]
<!-- Get proficencies, just the two -->
[h: allProficiencies = json.path.read (toon, "data.modifiers..[?(@.type == 'proficiency')]")]
[h: weaponProficiencies = json.path.read (allProficiencies,
		".[?(@.subType in ['simple-weapons', 'martial-weapons'])]")]

[h, foreach (weaponRaw, weaponArry), code: {
	[h: equipped = json.path.read (weaponRaw, "equipped")]
	[h: attackType = json.path.read (weaponRaw, "definition.attackType")]
	[h: grantedModifiers = json.path.read (weaponRaw, "definition.grantedModifiers")]
	[h: dmgType = json.path.read (weaponRaw, "definition.damageType")]
	<!-- cant imagine there's a weapon that grants multiple bonuses, but this is
		an array, so treat it like one even though it's just one.-->
	[h: bonus = 0]
	[h, foreach (modifier, grantedModifiers), code: {
		[h: bonusType = json.get (modifier, "type")]
		[h: weaponBonus = json.get (modifier, "value")]
		[h, if (equals (bonusType, "bonus") > 0): bonus = bonus + weaponBonus; bonus = bonus]
		[h: dmgType = dmgType + ", " + json.get (modifier, "subType")]
	}]

	<!-- correlate weapon categoryId w/ weaponProficiency entityId -->
	[h: proficiencyId = json.path.read (weaponRaw, "definition.categoryId")]
	[h: proficientArry = json.path.read (weaponProficiencies, 
		".[?(@.entityId == '" + proficiencyId + "')]")]
	[h, if (attackType == "1"): attackTypeLabel = "Melee"; attackTypeLabel = "Ranged"]

	[h: basicWeapon = json.set ("", "name", json.path.read (weaponRaw, "definition.name"),
		"attackType", attackTypeLabel,
		"dmgDie", json.path.read (weaponRaw, "definition.damage.diceValue"),
		"dmgDice", json.path.read (weaponRaw, "definition.damage.diceCount"),
		"dmgType", dmgType,
		"bonus", bonus,
		"range", json.path.read (weaponRaw, "definition.range"),
		"longRange", json.path.read (weaponRaw, "definition.longRange"),
		"type", json.path.read (weaponRaw, "definition.type"),
		"properties", json.path.read (weaponRaw, "definition.properties"),
		"proficient", json.length (proficientArry),
		"isMonk", json.path.read (weaponRaw, "definition.isMonkWeapon"),
		"equipped", equipped)
	)]

	<!-- bleh, move this to the end so I can save a nested level of execution -->
	[h: basicArry = json.append (basicArry, basicWeapon)]
}]
[h: macro.return = basicArry]