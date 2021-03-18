<!-- get toon and maybe a weapon name -->
[h: toon = arg(0)]
[h, if (json.length (macro.args) > 1):
				weapons = dndb_getInventory (toon, "Weapon", arg(1)); 
				weapons = dndb_getInventory (toon, "Weapon")]
[h: basicWeapons = "[]"]

<!-- TODO: Why two reads?? -->
<!-- Get proficencies -->
[h: proficiencies = json.path.read (toon, "data.modifiers..[?(@.type == 'proficiency')]")]

[h: weaponProficiencies = json.path.read (proficiencies,
		".[?(@.subType in ['simple-weapons', 'martial-weapons'])]")]

[h: log.debug (getMacroname() + "## proficiencies = " + proficiencies + 
		"; weaponProficiencies = " + weaponProficiencies)]
[h, foreach (weapon, weapons), code: {
	<!-- Build basic weapon json -->
	[equipped = json.path.read (weapon, "equipped")]
	[attackType = json.path.read (weapon, "definition.attackType")]
	[grantedModifiers = json.path.read (weapon, "definition.grantedModifiers")]
	[bonuses = dndb_searchJsonObject (json.set ("", "object", grantedModifiers,
										"property", "value",
										"type", "bonus"))]
	[bonus = 0]
	[foreach (bonusEl, bonuses): bonus  = bonus + bonusEl]
	[dmgType = json.path.read (weapon, "definition.damageType")]
	<!-- correlate weapon categoryId w/ weaponProficiency entityId -->
	[proficiencyId = json.path.read (weapon, "definition.categoryId")]
	[proficientArry = json.path.read (weaponProficiencies, 
		".[?(@.entityId == '" + proficiencyId + "')]")]
	[log.debug (getMacroName() + "## proficiencyId = " + proficiencyId +
				"; proficientArry = " + proficientArry)]
	[if (json.length (proficientArry) > 0): isProficient = 1; isProficient = 0]
	[if (!isProficient), code: {
		<!-- try by type -->
		[searchObj = json.set ("", "object", proficiencies, "property", "id", "type", "proficiency", 
							"subType", lower (json.path.read (weapon, "definition.type")))]
		[proficientArry = dndb_searchJsonObject (searchObj)]
		[log.debug (getMacroName() + "## by type proficientArry = " + proficientArry)]
		[if (json.length (proficientArry) > 0): isProficient = 1]
	}]
	[if (attackType == "1"): attackTypeLabel = "Melee"; attackTypeLabel = "Ranged"]
	[dmgDie = json.path.read (weapon, "definition.damage.diceValue", "SUPPRESS_EXCEPTIONS")]
	[if (dmgDie == "null"): dmgDie = 0]
	[dmgDice = json.path.read (weapon, "definition.damage.diceCount", "SUPPRESS_EXCEPTIONS")]
	[if (dmgDice == "null"): dmgDice = 0]
	[basicWeapon = json.set ("", "name", json.path.read (weapon, "definition.name"),
		"attackType", attackTypeLabel,
		"dmgDie", dmgDie,
		"dmgDice", dmgDice,
		"dmgType", dmgType,
		"bonus", bonus,
		"id", json.get (weapon, "id"),
		"range", json.path.read (weapon, "definition.range"),
		"longRange", json.path.read (weapon, "definition.longRange"),
		"type", json.path.read (weapon, "definition.type"),
		"properties", json.path.read (weapon, "definition.properties"),
		"proficient", isProficient,
		"isMonk", json.path.read (weapon, "definition.isMonkWeapon"),
		"grantedModifiers", grantedModifiers,
		"equipped", equipped)
	)]
	[basicWeapons = json.append (basicWeapons, basicWeapon)]
}]
[h: macro.return = basicWeapons]
