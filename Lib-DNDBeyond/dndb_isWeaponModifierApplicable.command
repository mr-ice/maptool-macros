<!-- Primarily via the subType attribute of the modifier, determine if the weapon applies. -->
<!-- Originally written for weapons, but could be expanded to easily apply to any item -->
[h: modifier = arg(0)]
[h: weapon = arg(1)]
<!-- todo - add a third optional argument to change from an optimistic behavior to a pessimistic -->

[h: qualified = 1]

[h: subType = json.get (modifier, "subType")]

<!-- if subType is blank, most of our work is pointless -->
[h, if (json.length (subType) == 0): subType = ""]

[h: attackType = json.get (weapon, "attackType")]
[h: type = json.get (weapon, "type")]
[h: log.debug (getMacroName() + "## subType = " + subType + "; attackType = " + attackType + "; type = " + type)]

<!-- subType must have "weapon-attack" or weapon-ish attack -->
[h: weaponAttacks = lastIndexOf (subType, "weapon-attack")]
[h: weaponAttacks = weaponAttacks + lastIndexOf (subType, "melee-attack")]
[h: weaponAttacks = weaponAttacks + lastIndexOf (subType, "range-attack")]
[h, if (weaponAttacks < 0): qualified = 0]

<!-- Ranged required? -->
[h: isRangedModifier = lastIndexOf (subType, "range")]
[h: isMeleeModifier = lastIndexOf (subType, "melee")]
[h, if (isRangedModifier > -1 && equals (attackType, "Melee")): qualified = 0]
[h, if (isMeleeModifier > -1 && equals (attackType, "Ranged")): qualified = 0]

<!-- one hand vs two hand restriction -->
[h: twoHandedProperty = json.path.read (weapon, "properties..[?(@.name == 'Two-Handed')]")]
[h: oneHandedRestriction = lastIndexOf (subType, "one-handed")]
[h, if (oneHandedRestriction > -1 && json.length (twoHandedProperty) > 0): qualified = 0]

<!-- "unarmed-attack" -->
[h, if (subType == "unarmed-attacks"), code: {
	[switch (type):
		case "Natural Weapon": qualified = qualified + 1;
		case "Unarmed": qualified = qualified + 1;
		default: "";
	]
}]

[h: macro.return = qualified]