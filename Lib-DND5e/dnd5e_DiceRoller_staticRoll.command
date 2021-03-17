[h: rollExpression = arg (0)]
[h: log.debug (getMacroName() + ": rolling " + rollExpression)]

<!-- Add dnd5e_DiceRoller_basicRoll rolledRollers list, causing them to be skipped -->
[h: rolledRollers = json.get (rollExpression, "rolledRollers")]
[h: rolledRollers = json.append (rolledRollers, "dnd5e_DiceRoller_basicRoll")]
[h: rollExpression = json.set (rollExpression, "rolledRollers", rolledRollers)]

<!-- do everything basic would, and make it static -->
[h: roll = dnd5e_RollExpression_getStaticRoll (rollExpression)]
[h: rolls = dnd5e_RollExpression_getRolls (rollExpression)]
[h: diceRolled = dnd5e_RollExpression_getDiceRolled (rollExpression)]

<!-- fill individualRolls with 0s -->
[h: individualRolls = json.rolls ("1d1-1", diceRolled)]
<!-- set the first to the static roll -->
[h: individualRolls = json.set (individualRolls, 0, roll)]
[h: rollExpression = json.set (rollExpression, "individualRolls", individualRolls)]

[h: rolls = json.append (rolls, roll)]
[h: rollExpression = dnd5e_RollExpression_addRoll (rollExpression, roll)]
[h: tooltipRoll = roll]
[h: tooltipDetail = "Fixed"]
[h: staticRollText = "<font color='red'><b>A roll of " + roll + " has been forced!</b></font>")]
[h: broadcast (staticRollText + "<br>")]
[h: rollExpression = dnd5e_RollExpression_addTypedDescriptor(rollExpression, 
			"staticRoll", staticRollText, 0)]
[h: rollExpression = dnd5e_RollExpression_addTypedDescriptor(rollExpression, 
			"tooltipDetail", tooltipDetail, 0)]
			
[h: macro.return = rollExpression]