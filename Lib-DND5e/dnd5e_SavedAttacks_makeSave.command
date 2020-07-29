[h: id = arg(0)]
[h: ability = capitalize(lower(trim(arg(1))))]
[h: dc = arg(2)]
[h: effect = arg(3)]

<!-- Create a roll expression and roll it -->
[h, if (ability != ""), code: {
	[h: save = dnd5e_RollExpression_Save(ability + " Save", getProperty(ability + " Save", id))]
	[h: switchToken(id)]
	[h: save = json.get(dnd5e_DiceRoller_roll(save), 0)]
	[h: saveTotal = dnd5e_RollExpression_getTotal(save)]
}; {

	<!-- Bad data, always cause the save to succeed -->
	[saveTotal = 100]
}]

<!-- Return the updated roll expression -->
[h: save = dnd5e_RollExpression_setSaveAbility(save, ability)]
[h: save = dnd5e_RollExpression_setSaveDC(save, dc)]
[h: save = dnd5e_RollExpression_setSaveEffect(save, effect)]
[h: save = json.set(save, "saveResult", if(saveTotal >= dc, effect, "failed"))]
[h: macro.return = save]