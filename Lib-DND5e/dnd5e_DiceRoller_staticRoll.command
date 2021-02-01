[h: rollExpression = arg (0)]
[h: log.debug (getMacroName() + ": rolling " + rollExpression)]
<!-- Remove the remaining rollers -->
[h: rollers = json.get (rollExpression, "remainingRollers")]
<!-- remove all rollers specified by the Basic type. There should really only be one -->
[h: basicRollers = dnd5e_Type_getRoller (dnd5e_Type_Basic())]
[h: rollers = json.removeAll (rollers, basicRollers)]
[h: rollExpression = json.set (rollExpression, "remainingRollers", rollers)]
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
			"staticRoll", staticRollText)]
[h: rollExpression = dnd5e_RollExpression_addTypedDescriptor(rollExpression, 
			"tooltipDetail", tooltipDetail)]
			
[h: macro.return = rollExpression]