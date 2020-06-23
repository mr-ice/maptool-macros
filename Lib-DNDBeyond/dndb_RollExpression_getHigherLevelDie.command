[h: spell = arg (0)]
[h: slotLevel = arg (1)]
[h: spellLevel = json.get (spell, "level")]
[h: atHigherLevel = json.path.read (spell, "modifiers[*].atHigherLevels")]
[h: log.debug ("dndb_RollExpression_getHigherLevelDie: atHigherLevel = " + atHigherLevel)]
[h, if (json.type (atHigherLevel) == "ARRAY"): atHigherLevel = json.get (atHigherLevel, 0); ""]
[h: higherLevelDefinitions = json.get (atHigherLevel, "higherLevelDefinitions")]
[h: scaleType = json.get (atHigherLevel, "scaleType")]
[h: dice = ""]
[h, if (scaleType == "characterlevel"), code: {
	<!-- spell effect is based on the characer level -->
	[h: toonLevel = json.get (spell, "casterLevel")]
	[h, foreach (higherLevelDefinition, higherLevelDefinitions), code: {
		[h: higherLevel = json.get (higherLevelDefinition, "level")]
		[h, if (toonLevel >= higherLevel): dice = json.get (higherLevelDefinition, "dice"); ""]
	}]
}; {""}]
[h, if (scaleType == "spellscale"), code: {
	<!-- spell effect is based on the spell slot level -->
	<!-- Need to find the differential, so subract the spell level from slot level -->
	[h: levelDiff = slotLevel - spellLevel]
	[h: higherLevelDefinition = json.get (higherLevelDefinitions, 0)]
	[h: dice = json.get (higherLevelDefinition, "dice")]
	[h: higherLevelLevel = json.get (higherLevelDefinition, "level")]
	[h: multiplier = round (math.floor(levelDiff / higherLevelLevel))]
	[h: diceCount = json.get (dice, "diceCount") * multiplier]
	[h: diceValue = json.get (dice, "diceValue")]
	[h: fixedValue = json.get (dice, "fixedValue")]
	[h: diceMultiplier = json.get (dice, "diceMultiplier")]
	[h: dice = json.set ("", "diceCount", diceCount,
						"diceValue", diceValue,
						"fixedValue", fixedValue,
						"diceMultiplier", diceMultiplier)]
}]

[h: dice = json.set (dice, "scaleType", scaleType)]
[h: macro.return = dice]