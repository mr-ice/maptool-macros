[h: inputObj = arg (0)]
[h: selectedAttack = json.get (inputObj, "selectedAttack")]
[h: advDisadv = json.get (inputObj, "advantageDisadvantage")]
[h: attackObj = dndb_BasicToon_getAttackExpression ()]
[h: log.debug ("rollAttack: attackObj = " + attackObj)]
[h: rollExpressions = json.get (attackObj, selectedAttack)]
[h, if (advDisadv == "Advantage"): hasAdvantage = 1; hasAdvantage = 0]
[h, if (advDisadv == "Disadvantage"): hasDisadvantage = 1; hasDisadvantage = 0]
[h: updatedRollExpressions = "[]"]
[h, foreach (rollExpression, rollExpressions), code: {
	[if (dnd5e_RollExpression_hasType (rollExpression, "Attack")), code: {
		[rollExpression = dnd5e_RollExpression_setAdvantage (rollExpression, hasAdvantage)]
		[rollExpression = dnd5e_RollExpression_setDisadvantage (rollExpression, hasDisadvantage)]
	};{""}]
	[updatedRollExpressions = json.append (updatedRollExpressions, rollExpression)]
}]
[h: rolledExpression = dnd5e_DiceRoller_roll (updatedRollExpressions)]
[r: dnd5e_RollExpression_getCombinedOutput (rolledExpression)]
