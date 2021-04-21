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
		[h: re = dnd5e_CharSheet_Util_adornRollExpressions (re)]
		[h: attackExpression = dnd5e_RollExpression_findExpressionByType (re, "Attack")]
		[h: damageExpression = dnd5e_RollExpression_findExpressionByType (re, "Damage")]
		<!-- get ready for dumbitude -->
		[r, if (json.isEmpty (damageExpression)):
			"<font color='red'>" + attackKey + " did not have damage</font>";
			dnd5e_RollExpression_getFormattedOutput (
				dnd5e_DiceRoller_roll (
					json.set (damageExpression, "rollExpressions", attackExpression)
				)
			)
		]
	}]
}]