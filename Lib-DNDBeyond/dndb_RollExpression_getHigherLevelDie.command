[h: spell = arg (0)]
[h: slotLevel = arg (1)]
[h, if (argCount() > 2): modifier = arg (2); modifier = ""]
[h: spellLevel = json.get (spell, "level")]
[h, if (encode (modifier) == ""): atHigherLevel = json.path.read (spell, "modifiers[*].atHigherLevels"); atHigherLevel = json.get (modifier, "atHigherLevels")]

[h: log.debug ("dndb_RollExpression_getHigherLevelDie: atHigherLevel = " + atHigherLevel)]
[h, if (json.type (atHigherLevel) == "ARRAY"): atHigherLevel = json.get (atHigherLevel, 0); ""]
[h, if (json.isEmpty (atHigherLevel)): return (0, "{}"); ""]
[h: higherLevelDefinitions = json.get (atHigherLevel, "higherLevelDefinitions")]
[h: scaleType = json.get (spell, "scaleType")]
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
	[h, if (json.length (higherLevelDefinitions) > 0): 
			higherLevelDefinition = json.get (higherLevelDefinitions, 0);
			higherLevelDefinition = "{}"]
	[h: dice = json.get (higherLevelDefinition, "dice")]
	[h, if (encode (dice) == ""): dice = "{}"; ""]
	[h: higherLevelLevel = json.get (higherLevelDefinition, "level")]
	[h, if (higherLevelLevel == ""): higherLevelLevel = 1; ""]
	[h: multiplier = round (math.floor(levelDiff / higherLevelLevel))]
	[h: diceCount = json.get (dice, "diceCount")]
	[h, if (diceCount == ""): diceCount = 0; ""]
	[h, if (diceCount == 0): totalRolls = levelDiff; totalRolls = 0]
	[h: diceCount = diceCount * multiplier]
	[h: diceValue = json.get (dice, "diceValue")]
	[h: fixedValue = json.get (dice, "fixedValue")]
	[h: diceMultiplier = json.get (dice, "diceMultiplier")]

	<!-- For something like Magic Missile, the diceCount will end up being 0 -->
	<!-- it should be calculated differently anyways, so ok for this macro to return 0-->
	[h: dice = json.set ("", "diceCount", diceCount,
						"diceValue", diceValue,
						"fixedValue", fixedValue,
						"totalRolls", totalRolls,
						"diceMultiplier", diceMultiplier)]
}]

[h: dice = json.set (dice, "scaleType", scaleType)]
[h: macro.return = dice]