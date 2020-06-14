[h: basicToon = getProperty ("dndb_BasicToon")]
[h, if (encode (basicToon) == ""), code: {
	[h: error = "You must initialize with DNDBeyond first"]
	[h: abort (input ( " junk | | " + error + " | LABEL | TEXT=fals"))]
	[h: return (0, error)]
}]

[h: CLASS_VAR_SUFFIX = "_spendHitDice"]
[h: classes = json.get (basicToon, "classes")]

<!-- example input string -->
<!-- Barbarian-spendHitDice | 0,1,2,3,4 | Spend Barbarian Hit Dice | List -->
<!-- Fighter-spendHitDice  | 0,1 | Spend Fighter Hit Dice | List -->

<!-- So the challenge here is that are variable name is dynamic. I think I can use the eval -->
<!-- function to help me out here -->

<!-- Build the input string, using ## as a line delimiter -->
[h: inputStr = ""]
[h: classVars = ""]
[h, foreach (class, classes), code: {
	[h: className = json.get (class, "className")]
	[h: level = json.get (class, "level")]
	[h: hitDiceUsed = json.get (class, "hitDiceUsed")]
	[h: hitDice = json.get (class, "hitDice")]
	[h: totalAvailable = level - hitDiceUsed + 1]
	[h: hitDiceChoices = ""]
	[h, for (i, 0, totalAvailable): hitDiceChoices = hitDiceChoices + "," + string (i)]
	[h: hitDiceChoices = substring (hitDiceChoices, 1)]
	[h: classVar = className + CLASS_VAR_SUFFIX]
	[h: inputStr = inputStr + "## " + classVar + " | " + hitDiceChoices + 
			" | Spend " + className + " Hit Dice | List | "]
	[h: classVars = json.append (classVars, json.set ("", "classVar", classVar, 
												"hitDice", hitDice,
												"className", className))]
}]
<!-- prune the leading ## -->
[h: inputStr = substring (inputStr, 3)]
[h: input (inputStr)]
[h: conBonus = getProperty ("Constitution Bonus")]
[h: total = 0]
[h: output = ""]
[h, foreach (classVar, classVars), code: {
	[h: output = output + "<br>" + json.get (classVar, "className") + ":<br>"]
	[h: limit = eval (json.get (classVar, "classVar"))]
	[h: dice = json.get (classVar, "hitDice")]
	[h, for (i, 0, limit), code: {
		[h: expression = "1d" + dice + " + " + conBonus]
		[h: roll = eval (expression)]
		[h: output = output + "&nbsp;&nbsp;&nbsp;" + expression + " = " + roll + "<br>"]
		[h: total = total + roll]
	}]
}]
[r: output]
[r: "<br>Total healed: " + total]