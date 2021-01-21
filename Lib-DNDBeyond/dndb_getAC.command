[h: toon = arg (0)]

<!-- Create a dummy "unarmed" armor just to make the next everything easier -->
[h: unarmored = json.set ("", "equipped", "true",
	"definition", json.set ("", "armorClass", 10,
				"baseArmorName", "Unarmored",
				"filterType", "Armor",
				"name", "Unarmored",
				"stealthCheck", 1,
				"armorTypeId", 0))]
<!-- And a dummy "noShield" -->
[h: noShield = json.set ("", "equipped", "true",
	"definition", json.set ("", "armorClass", 0,
				"baseArmorName", "No Shield",
				"filterType", "Shield",
				"name", "No Shield",
				"stealthCheck", 1,
				"armorTypeId", 4))]

<!-- Get all armors and shields from inventory -->
[h: allArmors = dndb_getArmor (toon)]

<!-- Determine equipped armor -->
[h: armors = json.path.read (allArmors, "[*].[?(@.definition.armorTypeId != 4)]")]
<!-- Select first equipped armor. log.warn if there are more -->
[h: equippedArmors = json.path.read (armors, "[*].[?(@.equipped == true)]")]
[h: equippedArmorNum = json.length (equippedArmors)]
[h, if (equippedArmorNum > 1): log.warn ("Too many armors equipped, selecting first found armor")]
[h, if (equippedArmorNum > 0): equippedArmor = json.get(equippedArmors, 0); 
	equippedArmor = unarmored]
<!-- adorn the basuc armor object -->
[h: basicArmor = json.set ("", "name", json.path.read (equippedArmor, "definition.name"),
						"armorClass", json.path.read (equippedArmor, "definition.armorClass"),
						"armorTypeId", json.path.read (equippedArmor, "definition.armorTypeId"))]
[h: bonuses = json.path.read (equippedArmor, "definition.grantedModifiers.[?(@.subType == 'armor-class')]['value']", "SUPPRESS_EXCEPTIONS,ALWAYS_RETURN_LIST")]
[h: totalBonus = 0]
[h, foreach (bonus, bonuses): totalBonus = totalBonus + bonus]						
[h: basicArmor = json.set (basicArmor, "bonus", totalBonus)]

<!-- Magic Armor and Shiled bonuses are swept into the acBonus calculation at this point. Easier to deduct them -->
<!-- now instead of refactoring code to search the toon sans those two eqiupped items -->
[h: acBonus = 0 - totalBonus]

[h, switch (json.get (basicArmor, "armorTypeId")):
	case 1: armorType = "Light";
	case 2: armorType = "Medium";
	case 3: armorType = "Heavy";
	default: armorType = "None";
]
[h: basicArmor = json.set (basicArmor, "armorType", armorType)]

<!-- determine equipped shield -->
[h: shields = json.path.read (allArmors, "[*].[?(@.definition.armorTypeId == 4)]")]
<!-- Select first equipped shield. log.warn if there are more -->
[h: equippedShields = json.path.read (shields, "[*].[?(@.equipped == true)]")]
[h: equippedShieldNum = json.length (equippedShields)]
[h, if (equippedShieldNum > 1): log.warn ("Too many shields equipped, selecting first found shield")]
[h, if (equippedShieldNum > 0): equippedShield = json.get(equippedShields, 0); 
	equippedShield = noShield]
[h: basicShield = json.set ("", "name", json.path.read (equippedShield, "definition.name"),
						"armorClass", json.path.read (equippedShield, "definition.armorClass"),
						"armorTypeId", json.path.read (equippedShield, "definition.armorTypeId"))]
[h: bonuses = json.path.read (equippedShield, "definition.grantedModifiers.[?(@.subType == 'armor-class')]['value']", "SUPPRESS_EXCEPTIONS,ALWAYS_RETURN_LIST")]
[h: totalBonus = 0]
[h, foreach (bonus, bonuses): totalBonus = totalBonus + bonus]						
[h: basicShield = json.set (basicShield, "bonus", totalBonus)]
<!-- Deducting shield bonus -->
[h: acBonus = acBonus - totalBonus]

<!-- Look for other modifiers -->
[h: searchObj = json.set ("", "object", toon, 
						"_searchType", "=~",
						"subType", "/.*armor-class/")]
[h: modifiers = dndb_searchGrantedModifiers (searchObj)]
[h, foreach (modifier, modifiers), code: {
	[h: bonus = dndb_getModValue (toon, modifier)]
	<!-- test some specific conditions -->
	[h: id = json.get (modifier, "id")]
	[h: unarmoredRequired = 0]
	[h, switch (id):
		case "2206": unarmoredRequired = 1;
		default: acBonus = acBonus + bonus
	]
	[h, if (unarmoredRequired > 0 && json.get (basicArmor, "name") == "Unarmored"): acBonus = acBonus + bonus]
}]

<!-- typeId 4 - Override base + DEX -->
[h: bonuses = "{}"]
[h: customSearchObject = json.set ("", "object", json.path.read (toon, "data.characterValues"),
										"typeId", "4",
										"property", "value")]
[h: overridePlusDexValues = dndb_searchJsonObject (customSearchObject)]
[h, if (json.length (overridePlusDexValues) > 0), code: {
	[overrideValue = json.get (overridePlusDexValues, 0)]
	[bonusObj = json.set ("", "typeId", 4, "value", overrideValue)]
	[bonuses = json.set (bonuses, "OverridePlusDex", bonusObj)]
}]

<!-- typeId 1 - Override -->
[h: customSearchObject = json.set (customSearchObject, "typeId", "1")]
[h: overrideValues = dndb_searchJsonObject (customSearchObject)]
[h, if (json.length (overrideValues) > 0), code: {
	[overrideValue = json.get (overrideValues, 0)]
	[bonusObj = json.set ("", "typeId", 1, "value", overrideValue)]
	[bonuses = json.set (bonuses, "Override", bonusObj)]
}]

<!-- typeId 2 - Magic bonus -->
[h: customSearchObject = json.set (customSearchObject, "typeId", "2")]
[h: magicBonusValues = dndb_searchJsonObject (customSearchObject)]
[h, if (json.length (magicBonusValues) > 0), code: {
	[magicValue =json.get (magicBonusValues, 0)]
	[bonusObj = json.set ("", "typeId", 2, "value", magicValue)]
	[bonuses = json.set (bonuses, "MagicBonus", bonusObj)]
}]

<!-- typeId 3 - Additional Misc bonus -->
[h: customSearchObject = json.set (customSearchObject, "typeId", "3")]
[h: miscBonusValues = dndb_searchJsonObject (customSearchObject)]
[h, if (json.length (miscBonusValues) > 0), code: {
	[miscValue = json.get (miscBonusValues, 0)]
	[bonusObj = json.set ("", "typeId", 3, "value", miscValue)]
	[bonuses = json.set (bonuses, "MiscBonus", bonusObj)]
}]


<!-- And build it -->
[h: acObj = json.set ("", "equippedArmor", basicArmor,
		"equippedShield", basicShield,
		"bonus", acBonus,
		"bonuses", bonuses)]
[h: macro.return = acObj]