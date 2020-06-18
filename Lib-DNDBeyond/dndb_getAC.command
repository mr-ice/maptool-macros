[h: toon = arg (0)]

<!-- Create a dummy "unarmed" armor just to make the next everything easier -->
[h: unarmored = json.set ("", "equipped", "true",
	"definition", json.set ("", "armorClass", 10,
				"baseArmorName", "Unarmored",
				"filterType", "Armor",
				"name", "Unarmored",
				"stealthCheck", 1,
				"armorTypeId", 1))]
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
<!-- adorn the armor with basic details -->
[h: equippedArmor = dndb_setArmorBonus (equippedArmor)]
[h: equippedArmorName = json.path.read (equippedArmor, "definition.name")]

<!-- adorn the armor with bonuses -->
<!-- New approach, get modifiers all at once -->
[h: log.debug ("Selecting equipped armor: " + equippedArmor)]

<!-- determine equipped shield -->
[h: shields = json.path.read (allArmors, "[*].[?(@.definition.armorTypeId == 4)]")]
<!-- Select first equipped shield. log.warn if there are more -->
[h: equippedShields = json.path.read (shields, "[*].[?(@.equipped == true)]")]
[h: equippedShieldNum = json.length (equippedShields)]
[h, if (equippedShieldNum > 1): log.warn ("Too many shields equipped, selecting first found shield")]
[h, if (equippedShieldNum > 0): equippedShield = json.get(equippedShields, 0); 
	equippedShield = noShield]
[h: equippedShield = dndb_setArmorBonus (equippedShield)]
[h: log.debug ("Selecting equipped shield: " + equippedShield)]

<!-- Calculate Dexterity bonus -->
[h: attributes = dndb_getAbilities (toon)]
[h: dexBonus = json.get (attributes, "dexBonus")]

<!-- Apply dex bonus -->
<!-- rules: -->
<!-- no or light armor: full dex bonus -->
<!-- medium armor: dex bonus, up to +2 -->
<!-- heavy armor: No dex bonus (positive or negative) -->
[h: armorTypeId = json.path.read (equippedArmor, "definition.armorTypeId")]
[h: log.debug ("armorTypeId: " + armorTypeId)]
[h, switch ( armorTypeId ):
	case "1" : dexBonus = dexBonus;
	case "2" : dexBonus = math.min (dexBonus, 2);
	case "3" : dexBonus = 0
]
[h: dexBonus = round (dexBonus)]
[h: log.debug ("dexBonus (calculated): " + dexBonus)]

<!-- Look for other modifiers -->
[h: bonus = 0]
[h: searchObj = json.set ("", "object", toon, 
						"_searchType", "=~",
						"subType", "/.*armor-class/")]
[h: modifiers = dndb_searchGrantedModifiers (searchObj)]

[h: totalBonus = 0]
[h, foreach (modifier, modifiers), code: {
	[h: bonus = dndb_getModValue (toon, modifier)]
	<!-- test some specific conditions -->
	[h: id = json.get (modifier, "id")]
	[h: unarmoredRequired = 0]
	[h, switch (id):
		case "2206": unarmoredRequired = 1;
		default: totalBonus = totalBonus + bonus
	]
	[h, if (unarmoredRequired > 0 && equippedArmorName == "Unarmored"): totalBonus = totalBonus + bonus]
}]

<!-- And the customizations, by TypeID -->

<!-- typeId 4 - Override base + DEX -->
<!-- do type 4 before type 1 -->
[h: overrideValue = -1]
[h: customSearchObject = json.set ("", "object", json.path.read (toon, "data.characterValues"),
										"typeId", "4",
										"property", "value")]
[h: overridePlusDexValues = dndb_searchJsonObject (customSearchObject)]
[h, if (json.length (overridePlusDexValues) > 0): overrideValue = json.get (overridePlusDexValues, 0)]

<!-- Not recognizing a difference between types 1 and 4. So for now, they act the same -->
<!-- typeId 1 - Override -->
[h: customSearchObject = json.set (customSearchObject, "typeId", "1")]
[h: overrideValues = dndb_searchJsonObject (customSearchObject)]
[h, if (json.length (overrideValues) > 0): overrideValue = json.get (overrideValues, 0)]

<!-- typeId 2 - Magic bonus -->
[h: customSearchObject = json.set (customSearchObject, "typeId", "2")]
[h: magicBonusValues = dndb_searchJsonObject (customSearchObject)]
[h, if (json.length (magicBonusValues) > 0): totalBonus = totalBonus + json.get (magicBonusValues, 0)]

<!-- typeId 3 - Additional Misc bonus -->
[h: customSearchObject = json.set (customSearchObject, "typeId", "3")]
[h: miscBonusValues = dndb_searchJsonObject (customSearchObject)]
[h, if (json.length (miscBonusValues) > 0): totalBonus = totalBonus + json.get (miscBonusValues, 0)]


<!-- And build it -->
<!-- Lets recap the players -->
<!-- total: every thing -->
<!-- dexterity: dex bonus, modified -->
<!-- armor: just the equipped armor -->
<!-- shield: just the equipped shield -->
<!-- feature: whatever the feature is providing -->
[h: armorBonus = json.get (equippedArmor, "baseArmorClass")]
[h: log.debug ("armorBonus: " + armorBonus)]
[h: shieldBonus = json.get (equippedShield, "baseArmorClass")]
[h: log.debug ("shieldBonus: " + shieldBonus)]
<!-- calculate what we have so far -->
[h: totalACBonus = armorBonus + shieldBonus + dexBonus + totalBonus]
[h, if (overrideValue > -1): totalACBonus = overrideValue]
<!-- build the base object -->
[h: acObj = json.set ("", "Dexterity", dexBonus,
		"Armor", armorBonus,
		"Shield", shieldBonus,
		"Bonus", totalBonus)]
<!-- hope this added up correctly -->
[h: acObj = json.set (acObj, "total", totalACBonus)]
[h: macro.return = acObj]