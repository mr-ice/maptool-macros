<!-- Read arguments -->
[h: id = arg(0)]
[h: exp = arg(1)]
[h: state = arg(2)]
[h: log.debug(json.indent(macro.args))]

<!-- Which exspression type are we handling? -->
[h: hit = json.get(state, "hit")]
[h, switch(dnd5e_RollExpression_getExpressionType(exp)), code: 
case "Attack": {

	<!-- Determine if we hit for all later damage rolls -->
	[h: ac = getProperty("AC", id)]
	[h: ac = if(isNumber(ac), number(ac), 0)]
	[h: hit = if(ac >= dnd5e_RollExpression_getTotal(exp), false, true)]
	[h: state = json.set(state, "hit", hit, "output", json.get(state, "output") + " Attack " + if(hit, "HIT;", "MISS;"))]
	[h: log.debug("Attack: " + ac + " " + dnd5e_RollExpression_getTotal(exp) + " " + json.indent(state))]
};
case "Damage": {

	<!-- On a hit apply calculated damage -->
	[h, if (hit != 0), code: {
		[h: damageOutput = dnd5e_SavedAttacks_calculateDamage(id,  dnd5e_RollExpression_getTotal(exp),
			dnd5e_RollExpression_getDamageTypes(exp))]
		[h: state = dnd5e_SavedAttacks_updateState(state, damageOutput)]
		[h: log.debug("Damage: " + json.indent(state))]
	}; {""}]
};
case "Save Damage": {

	<!-- On a hit, make saving throw, then apply calculated damage -->
	[h, if (hit != 0), code: {
		[h: save = dnd5e_SavedAttacks_makeSave(id, dnd5e_RollExpression_getSaveAbility(exp),
					dnd5e_RollExpression_getSaveDC(exp), dnd5e_RollExpression_getSaveEffect(exp))]
		[h: log.debug("Save Damage: save = " + json.indent(save)]
		[h: damageOutput = dnd5e_SavedAttacks_calculateDamage(id,  dnd5e_RollExpression_getTotal(exp),
			dnd5e_RollExpression_getDamageTypes(exp), save)]
		[h: state = dnd5e_SavedAttacks_updateState(state, damageOutput)]
		[h: log.debug("Save Damage: " + json.indent(state))]
	}; {""}]
};
default: {
	[log.warn("Unknown expression type: " + dnd5e_RollExpression_getExpressionType(exp))]
}]
[h: log.debug("done: " + json.indent(state))]
[h: macro.return = state]