[h: toon = arg(0)]

[h: totalClassACBonus = 0]
[h: classFeatures = "[]"]
<!-- Look for armor based features -->

<!-- Try and look for sub-type ends-with armor-class and use known ids for applying restrictions -->
<!-- Barbarian -->
[h: barbarian = json.path.read (toon, "data.classes[*].[?(@.definition.name == 'Barbarian')]")]
[h, if (json.length (barbarian) == 0): barbarian = "{}"]
[h: log.debug ("barbarian: " + json.length (barbarian))]
[h, if (json.length (barbarian) > 0): barbarian = json.get (barbarian, 0)]

<!-- Look for barbarian class feature "Unarmored Defense" -->
[h: level = 0]
[h: unarmoredDefense = "[]"]
[h: level = json.get (barbarian, "level")]
[h, if (level == ""): level = 0]
[h: log.debug ("level: " + level)]
[h, if (level > 0), code: {
	[h: unarmoredDefense = json.path.read (barbarian,
			"classFeatures[*].[?(@.definition.name == 'Unarmored Defense')]")]
	[h, if (json.length (unarmoredDefense) > 0): unarmoredDefense = json.get (unarmoredDefense, 0)]
	[h: log.debug ("unarmoredDefense: " + json.indent (unarmoredDefense))]
}; {0}
]

[h, if (json.length (unarmoredDefense) > 0), code: {
	<!-- Confirm the barb isnt wearing armor (note: DND Beyond doesnt check this) -->
	[h: equippedArmors = json.path.read (toon, "data.inventory[*].[?(@.equipped == true && @.definition.armorTypeId < 4)]")]
	[h: totalEquipped = json.length (equippedArmors)]
	[h: log.debug ("totalEquipped: " + totalEquipped)]
	[h, if (totalEquipped == 0), code: {
		[h: attributes = dndb_getAbilities (toon)]
		[h: featureBonus = json.get (attributes, "conBonus")]
		[h: totalClassACBonus = totalClassACBonus + featureBonus]
		<!-- Tack on a bonus attribute: dndb_bonus -->
		[h: unarmoredDefense = json.set (unarmoredDefense, "dndb_bonus", featureBonus)]
		[h: classFeatures = json.append (classFeatures, unarmoredDefense)]
	}]
}]

<!-- Build the return object -->
[h: acBonuses = json.set ("", "totalClassACBonus", totalClassACBonus,
			"classFeatures", classFeatures)]
[h: macro.return = acBonuses]