<!-- Callers must pass in the character json themselves. No getter methods should shoulder the -->
<!-- responsibility of calling dndb_getCharJSON -->
<!-- Requires two parameters: toon json and weapon object -->
[h: toon = arg(0)]
[h: weapon = arg (1)]
[h, if (json.length (macro.args) > 2): characterValues = arg (2); characterValues = "[]"]

[h: attackType = lower (json.get (weapon, "attackType"))]

<!-- TODO - come back to this -->
[h: finesse = json.path.read (weapon, "properties.[?(@.name == 'Finesse')]")]
[h: log.debug (getMacroName() + ": finesse = " + finesse)]

[h, if (json.length (finesse) > 0): attackType = "finesse"; ""]

<!-- apply proficiency bonus -->
<!-- TODO - any half an expertise here -->
[h: proficientVal = json.get (weapon, "proficient")]
[h, if (proficientVal > 0): proficient = 1; proficient = 0]
[h: log.debug (getMacroName() + ": proficient = " + proficient)]

[h: totalAtkBonus = 0]

[h: searchObj = json.set ("", "object", toon,
					"_searchType", "=~",
					"type", "/bonus/",
					"subType", "/.*-attacks/")]

[h: modifiers = dndb_searchGrantedModifiers (searchObj)]


[h, foreach (modifier, modifiers, ""), code: {
	[qualified = dndb_isWeaponModifierApplicable (modifier, weapon)]
	[if (qualified > 0), code: {
		[bonus = json.get (modifier, "value")]
		[totalAtkBonus = totalAtkBonus + bonus]
		[log.debug (getMacroName() + ": " + modifier)]
		[log.debug (getMacroName() + ": qualified = " + qualified)]
	}]
}]

<!-- finally, bonuses on the weapon itself. No check for equipped here. -->
[h: bonus = json.get (weapon, "bonus")]
[h: totalAtkBonus = totalAtkBonus + bonus]

<!-- Real finally, did the user override -->
<!-- adds to the bonus -->
[h: charValueSearchObj =  json.set ("", "object", characterValues, "valueId", json.get (weapon, "id"), "typeId", 12)]

[h: overrideBonus = 0]
[h: overridden = 0]
[h: override = 0]
[h: overrideResults = dndb_searchJsonObject (charValueSearchObj)]
[h, if (json.length (overrideResults) > 0), code: {
	[overrideBonus = json.get (json.get (overrideResults, 0), "value")]
}; {}]

<!-- overrides the bonus -->
[h: charValueSearchObj = json.set (charValueSearchObj, "typeId", 13)]
[h: overrideResults = dndb_searchJsonObject (charValueSearchObj)]
[h, if (json.length (overrideResults) > 0), code: {
	[overridden = 1]
	[override = json.get (json.get (overrideResults, 0), "value")]
}; {}]
[h: bonusObj = json.set ("{}", 
		"proficient", proficient,
		"attackType", attackType,
		"bonus", totalAtkBonus,
		"overridden", overridden,
		"overrideBonus", overrideBonus,
		"override", override)]
		
[h: log.debug (getMacroName() + ": bonusObj = " + bonusObj)]

[h: macro.return = bonusObj]