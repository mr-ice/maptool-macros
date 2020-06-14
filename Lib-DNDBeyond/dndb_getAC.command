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
<!-- adorn the armor with bonuses -->
[h: equippedArmor = dndb_setArmorBonus (equippedArmor)]
[h: log.debug ("Selecting equipped armor: " + equippedArmor)]

<!-- determine equipped shield -->
[h: shields = json.path.read (allArmors, "[*].[?(@.definition.armorTypeId == 4)]")]
<!-- Select first equipped shield. log.warn if there are more -->
[h: equippedShields = json.path.read (shields, "[*].[?(@.equipped == true)]")]
[h: equippedShieldNum = json.length (equippedShields)]
[h, if (equippedShieldNum > 1): log.warn ("Too many shields equipped, selecting first found shield")]
[h, if (equippedShieldNum > 0): equippedShield = json.get(equippedShields, 0); 
	equippedShield = noShield]
<!-- adorn the shield with bonuses -->
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
[h: log.debug ("dexBonus (calculated): " + dexBonus)]

<!-- Look for other modifiers from class abilities -->
<!-- Lets defer this to another script for brevity -->
[h: classACBonus = dndb_getACBonusFromClasses (toon)]
[h: log.debug ("classACBonus: " + json.indent (classACBonus))]

<!-- And build it -->
<!-- Lets recap the players -->
<!-- total: every thing -->
<!-- dexterity: dex bonus, modified -->
<!-- armor: just the equipped armor -->
<!-- shield: just the equipped shield -->
<!-- feature: whatever the feature is providing -->
[h: armorBonus = json.get (equippedArmor, "totalAC")]
[h: log.debug ("armorBonus: " + armorBonus)]
[h: shieldBonus = json.get (equippedShield, "totalAC")]
[h: log.debug ("shieldBonus: " + shieldBonus)]
<!-- calculate what we have so far -->
[h: totalACBonus = armorBonus + shieldBonus + dexBonus]
<!-- build the base object -->
[h: acObj = json.set ("", "Dexterity", dexBonus,
		"Armor", armorBonus,
		"Shield", shieldBonus)]
<!-- and the class features -->
[h: totalClassACBonus = json.get (classACBonus, "totalClassACBonus")]
[h: totalACBonus = totalACBonus + totalClassACBonus]
[h, foreach (classFeature, json.get (classACBonus, "classFeatures")), code: {
	[h: classBonus = json.get (classFeature, "dndb_bonus")]
	[h: featureName = json.path.read (classFeature, "definition.name")]
	[h: acObj = json.set (acObj, featureName, classBonus)]
}]
<!-- hope this added up correctly -->
[h: acObj = json.set (acObj, "total", totalACBonus)]
[h: macro.return = acObj]