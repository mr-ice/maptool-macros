[h: rollExpressions = arg (0)]
[h, if (json.length (macro.args) > 1): bonusProperty = arg (1); bonusProperty = ""]
[h, if (json.type (rollExpressions) == "ARRAY"): rollExpression = json.get (rollExpressions, 0); rollExpression = rollExpressions]
[h: macroCmd = "[h: rollExpression = '" + rollExpressions + "']"]
[h, if (bonusProperty != ""), code: {
	[h: macroCmd = macroCmd + "[h: bonus = getProperty ('" + bonusProperty + "')]"]
	[h: macroCmd = macroCmd + "[h: rollExpression = dnd5e_RollExpression_setBonus (rollExpression, bonus)]"]
}]
[h: macroCmd = macroCmd + "[h:rolledExpressions = dnd5e_DiceRoller_roll (rollExpression)]"]
[h: macroCmd = macroCmd + "[h: output = '']"]
[h: macroCmd = macroCmd + "[h, foreach (rolledExpression, rolledExpressions): output = " +
				"output + '<br>' + dnd5e_RollExpression_getOutput (rolledExpression)]"]
[h: macroCmd = macroCmd + "[r: output]"]
[h: selectedIds = getSelected ()]
[h, foreach (tokenId, selectedIds), code: {
	[h: label = dnd5e_RollExpression_getName (rollExpression) + " " 
				+ dnd5e_RollExpression_getExpressionType (rollExpression)]
	[h: createMacro(label, macroCmd, "playerEditable=1,applyToSelected=1", ",", tokenId)]
}]

[h: log.debug (macroCmd)]