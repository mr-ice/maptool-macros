[h: rollString = arg (0)]
<!-- New twist: must also parse with property expressions:
	1d6 + %7BStrengthBonus%7D
	1d8 + 2 + %7Bbonus.attack.finesse%7D
	Note: Do not expand the properties, just put the relevant
		  string in the bonus field, ex: "2 + %7Bbonus.attack.finesse%7D" -->
[h: log.debug (getMacroName() + ": rollString = " + rollString)]
<!-- Hmm, cant go around replacing whitespace anymore, since properties can have spaces -->
<!-- examples: 1d6 + 2, 
			   2d20 + 5 + 7, 
			   1d20 + 2 + %7Bbonus.attack.melee%7D,
			   1d20+%7BProficiencyBonus}+%7BCharismaBonus%7D
			   1d20 + %7BAnimal Handling%7D
			   2d10 - 5
			   5d6 -->
<!-- All we really have to do is tokenize the string into two tokens: die roll and bonus -->
<!-- base pattern is (\\d+)d(\\d+) for the die roll -->
<!-- everyting else is .* and just stuff it into bonus. dnd5e_RE_getBonus will expand the value -->
[h: retObj = "{}"]
[h: rollStringRegEx = "(\\d+)d(\\d+)(.*)"]
[h: findId = strfind (rollString, rollStringRegEx)]
[h: findCount = getFindCount (findId)]
[h, if (findCount > 0), code: {
	[h: diceRolled = getGroup (findId, 1, 1)]
	[h: diceSize = getGroup (findId, 1, 2)]
	[h: bonus = getGroup (findId, 1, 3)]
	<!-- If bonus starts with + or - followed by a non-integer, 
			prepend the whole string with 0 -->
	[h: pattern = "^\\s*[+-]"]
	[h: beginsWithId = strfind (bonus, pattern)]
	[h, if (getFindCount (beginsWithId) > 0): bonus = "0" + bonus; ""]
	[h: retObj = json.set (retObj, "diceRolled", diceRolled, "diceSize", diceSize, "bonus", bonus)]
}; {}]
[h: macro.return = retObj]