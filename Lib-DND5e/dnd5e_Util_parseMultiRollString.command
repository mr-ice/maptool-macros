[h: rollString = arg(0)]
[h: dnd5e_Constants (getMacroName())]
[h: rollString = replace (rollString, "\\s", "")]
[h: log.debug (CATEGORY + "stripped rollString = " + rollString)]
<!-- "Why are the bonus values all added up and by itself?"
	Because RegEx is hard! So we tokenize two different patterns: one
	for the dice expression and one for all the bonuses. Since this
	causes those bonuses to become decoupled from their associated 
	dice expression, we just add them up and stuff them in their
	own special object. -->
[h: rollStringPattern = "([+-]?\\d+)d(\\d+)"]

[h: rollFindId = strfind (rollString, rollStringPattern)]

[h: rollArry = "[]"]
[h: rollFindCount = getFindCount (rollFindId)]
[h: log.debug (CATEGORY + "rollFindCount = " + rollFindCount)]
[h, for (i, 1, rollFindCount + 1), code: {
	[diceRolled = getGroup (rollFindId, i, 1)]
	[diceSize = getGroup (rollFindId, i, 2)]
	<!-- Modify the rollString to exclude this expression now that weve found it. -->
	[removePattern = "\\Q" + diceRolled + "d" + diceSize + "\\E"]
	[log.trace (CATEGORY + "removePattern = " + removePattern + "; rollString before remove: " + rollString)]
	[rollString = replace (rollString, removePattern, "")]
	[log.trace (CATEGORY + "rollString after remove: " + rollString)]
	[subtract = 0]
	[log.trace (CATEGORY + "diceRolled = " + diceRolled + "; diceSize = " + diceSize)]
	[if (diceRolled < 0), code: {
		[diceRolled = diceRolled * -1]
		[subtract = 1]
	}]

	[diceObj = json.set ("", "diceRolled", diceRolled, "diceSize", diceSize, "subtract", subtract)]
	[rollArry = json.append (rollArry, diceObj)]
}]
[h: log.debug (CATEGORY + "remaining rollString = " + rollString + "; rollArry = " + rollArry)]
[h: bonusValuePattern = "([+-]?\\d+)"]
[h: bonusFindId = strfind (rollString, bonusValuePattern)]
[h: bonusTotal = 0]
[h: bonusFindCount = getFindCount (bonusFindId)]
[h: log.trace (CATEGORY + "bonusFindCount = " + bonusFindCount)]
[h, for (i, 1, bonusFindCount + 1), code: {
	[bonusVal = getGroup (bonusFindId, i, 1)]
	[log.trace (CATEGORY + "bonusVal = " + bonusVal)]
	[bonusTotal = bonusTotal + bonusVal]
}]
[h: rollArry = json.append (rollArry, json.set ("", "bonus", bonusTotal))]
[h: macro.return = rollArry]