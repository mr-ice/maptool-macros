[h: basicToon = dndb_getBasicToon ()]

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
[h: abort (input (inputStr))]
[h: conBonus = getProperty ("Constitution Bonus")]
[h: total = 0]
[h: output = ""]
[h: rollExpressions = "[]"]
[h, foreach (classVar, classVars), code: {
	[h: rollName = json.get (classVar, "className")]
	[h: diceSize = json.get (classVar, "hitDice")]
	[h: totalRolls = eval (json.get (classVar, "classVar"))]
	
	[h: rollExpression = json.set ("", "name", rollName,
									"diceSize", diceSize,
									"diceRolled", 1,
									"totalRolls", totalRolls,
									"bonus", conBonus,
									"expressionTypes", "Healing")]
	[h: rollExpressions = json.append (rollExpressions, rollExpression)]
}]
[h: rolls = dnd5e_DiceRoller_roll (rollExpressions)]
[h: output = ""]
[h, foreach (roll, rolls), code: {
	[h: total = json.get (roll, "allTotal")]
	[h, foreach (rollOutput, json.get (roll, "outputs")): output = output + rollOutput + "<br>"]
	[h: output = output + "<br>"]
}]
[h: output = output + "<br>" + "Total Healing: " + total]
<pre>[r: output]</pre>
