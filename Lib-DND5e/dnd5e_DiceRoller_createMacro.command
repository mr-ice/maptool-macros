[h: rollExpressions = arg (0)]
[h, if (json.length (macro.args) > 1): bonusProperty = arg (1); bonusProperty = ""]
[h, if (json.type (rollExpressions) == "ARRAY"): rollExpression = json.get (rollExpressions, 0); rollExpression = rollExpressions]
[h: macroCmd = "[h: rollExpression = '" + rollExpressions + "']"]
[h, if (bonusProperty != ""), code: {
	[h: macroCmd = macroCmd + "[h: bonus = getProperty ('" + bonusProperty + "')]"]
	[h: macroCmd = macroCmd + "[h: rollExpression = json.set (rollExpression, 'bonus', bonus)]"]
}]
[h: macroCmd = macroCmd + "[h:rolledExpressions = dnd5e_DiceRoller_roll (rollExpression)]"]
[h: macroCmd = macroCmd + "[h: output = '']"]
[h: macroCmd = macroCmd + "[h, foreach (rolledExpression, rolledExpressions): output = " +
				"output + '<br>' + json.get (rolledExpression, 'output')]"]
[h: macroCmd = macroCmd + "[r: output]"]
[h: selectedIds = getSelected ()]
[h, foreach (tokenId, selectedIds), code: {
	[h: label = json.get (rollExpression, "name") + " " 
				+ json.get (rollExpression, "expressionTypes")]
	[h: createMacro(label, macroCmd, "playerEditable=1,applyToSelected=1", ",", tokenId)]
}]

[h: log.debug (macroCmd)]