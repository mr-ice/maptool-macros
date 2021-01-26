[h: rollExpression = arg (0)]
[h: diceSize = dnd5e_RollExpression_getDiceSize (rollExpression)]
[h: diceRolled = dnd5e_RollExpression_getDiceRolled (rollExpression)]
[h: bonus = dnd5e_RollExpression_getBonus (rollExpression)]
[h, if(bonus != 0): bonusOutput = if(bonus > 0, " + " + bonus, " - " + (bonus * -1)); bonusOutput = ""]
[h: baseRoll = diceRolled + "d" + diceSize]


[h: log.debug ("dnd5e_DiceRoller _basicRoll: Rolling " + baseRoll)]
[h: individualRolls = json.rolls("1d" + diceSize, diceRolled)]
[h, if (json.length (individualRolls) == 0): individualRolls = "[0]"; ""]
[h: rollExpression = json.set (rollExpression, "individualRolls", individualRolls)]
[h: roll = math.arraySum(individualRolls)]
[h: rollExpression = dnd5e_RollExpression_addRoll (rollExpression, roll)]
[h: rollString = dnd5e_RollExpression_getRollString (rollExpression)]
[h: rollExpression = json.set (rollExpression, "rollString", rollString)]

[h: log.debug ("dnd5e_DiceRoller_basicRoll: return = " + rollExpression)]
[h: macro.return = rollExpression]