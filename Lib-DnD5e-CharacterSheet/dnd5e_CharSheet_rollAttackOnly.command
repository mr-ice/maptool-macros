[h: attackKey = arg (0)]
[h: dnd5e_CharSheet_Constants (getMacroName())]
[h: attackJson = getProperty ("attackExpressionJSON")]
[r, if (json.isEmpty (attackJson)), code: {
	[r: "<font color='red'>No attacks were found!</font>"]
}; {
	[h: re = json.get (attackJson, attackKey)]
	[r, if (json.isEmpty (re)), code: {
		[r: "<font color='red'>" + attackKey + " was not found!</font>"]
	}; {
		[h: attackExpression = dnd5e_RollExpression_findExpressionByType (re, "Attack")]
		[r, if (json.isEmpty (attackExpression)):
			"<font color='red'>" + attackKey + " did not have an attack</font>";
			dnd5e_RollExpression_getFormattedOutput (
				dnd5e_DiceRoller_roll (attackExpression))
		]
	}]
}]