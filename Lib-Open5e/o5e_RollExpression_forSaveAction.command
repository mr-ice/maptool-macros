[h: actionObj = arg (0)]
[h: saveDC = json.get (actionObj, "saveDC")]
[h, if (isNumber (saveDC) > 0), code: {
	[name = json.get (actionObj, "name")]
	[saveEffect = json.get (actionObj, "saveEffect")]
	[saveAbility = json.get (actionObj, "saveAbility")]
	[rollExpression = dnd5e_RollExpression_SaveEffect (name)]
	[rollExpression = dnd5e_RollExpression_setSaveAbility (rollExpression, saveAbility)]
	[rollExpression = dnd5e_RollExpression_setSaveDC (rollExpression, saveDC)]
	[rollExpression = dnd5e_RollExpression_setSaveEffect (rollExpression, saveEffect)]
}; {
	[rollExpression = ""]
}]
[h: macro.return = rollExpression]