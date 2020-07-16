[h: damageExpression = arg (0)]
[h, if (dnd5e_RollExpression_hasType (damageExpression, "saveable") && !dnd5e_RollExpression_hasType (damageExpression, "damageable")), code: {
	[h: saveDC = dnd5e_RollExpression_getSaveDC (damageExpression)]
	[h: saveEffect = dnd5e_RollExpression_getSaveEffect (damageExpression)]
	[h: saveAbility = dnd5e_RollExpression_getSaveAbility (damageExpression)]
	<!-- Use setDescription to overwrite anything previously set -->
	[h: damageExpression = dnd5e_RollExpression_setDescription (damageExpression, "Target must make a " + saveAbility + " DC " + saveDC + " save. " + saveEffect)]
	[h: damageExpression = json.set (damageExpression, "roll", "", "tototal", "")]
}]
[h: macro.return = damageExpression]