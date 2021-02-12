<!-- Callers must pass in the character json themselves. No getter methods should shoulder the -->
<!-- responsibility of calling dndb_getCharJSON -->
<!-- Requires two parameters: toon json and weapon object -->
[h: toon = arg(0)]
[h: weapon = arg (1)]
[h, if (json.length (macro.args) > 2): characterValues = arg (2); characterValues = "[]"]

[h: attackType = lower (json.get (weapon, "attackType"))]
[h: finesse = json.path.read (weapon, "properties.[?(@.name == 'Finesse')]")]
[h: log.debug (getMacroName() + ": finesse = " + finesse)]

[h, if (json.length (finesse) > 0): attackType = "finesse"; ""]

[h: totalBonus = 0]


[h: searchObj = json.set ("", "object", toon,
					"_searchType", "=~",
					"type", "/damage/",
					"subType", "/.*-attacks/")]

[h: modifiers = dndb_searchGrantedModifiers (searchObj)]

[h, foreach (modifier, modifiers, ""), code: {
	[qualified = dndb_isWeaponModifierApplicable (modifier, weapon)]
	[h, if (qualified > 0), code: {
		[totalBonus = totalBonus + json.get (modifier, "value")]
		[log.debug (getMacroName() + ": " + modifier)]
		[log.debug (getMacroName() + ": qualified = " + qualified)]
	}]
}]

<!-- finally, bonuses on the weapon itself -->
[h: bonus = json.get (weapon, "bonus")]
[h: totalBonus = totalBonus + bonus]

<!-- Real finally, did the user override -->
[h: overridden = 0]
[h: override = 0]
[h: charValueSearchObj =  json.set ("", "object", characterValues, "valueId", json.get (weapon, "id"), "typeId", 10)]
[h: overrideResults = dndb_searchJsonObject (charValueSearchObj)]
[h, if (json.length (overrideResults) > 0), code: {
	[overridden = 1]
	[override = json.get (json.get (overrideResults, 0), "value")]
}; {}]

[h: bonusObj = json.set ("{}", 
		"attackType", attackType,
		"bonus", totalBonus,
		"overridden", overridden,
		"override", override)]
		
[h: log.debug (getMacroName() + ": bonusObj = " + bonusObj)]

[h: macro.return = bonusObj]
