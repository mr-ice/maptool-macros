[h: baseBonus = arg(0)]
[h: proficiencyBonus = arg(1)]
<!-- Do not attempt to go any further if a proficiencyBonus -->
<!-- of 0 or less is provided -->
[h, if (proficiencyBonus <= 0): return (0, json.set ("",
				"proficiency", 0,
				"bonus", baseBonus)); ""]

[h: proficiencyMultiplier = 0]
[h, foreach (multiplier, json.append ("[]", 0.5, 1, 2)), code: {
	[quotient = baseBonus / (proficiencyBonus * multiplier)]
	[if (quotient >= 1): proficiencyMultiplier = multiplier; ""]
}]
[h: bonus = baseBonus - floor(proficiencyBonus * proficiencyMultiplier)]
[h: bonusObj = json.set ("", "proficiency", proficiencyMultiplier,
						"bonus", bonus)]
[h: macro.return = bonusObj]