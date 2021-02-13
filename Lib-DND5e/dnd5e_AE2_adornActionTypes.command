[h: expressions = arg (0)]
[h: updatedExpressions = "[]"]
[h, foreach (re, expressions), code: {
	[expressionType = dnd5e_RollExpression_getExpressionType (re)]
	[switch (expressionType):
		case "Ability": prototype = dnd5e_RollExpression_Ability();
		case "Attack": prototype = dnd5e_RollExpression_Attack();
		case "Blessed": prototype = dnd5e_RollExpression_BuildBless();
		case "Condition": prototype = dnd5e_RollExpression_Condition();
		case "Damage": prototype = dnd5e_RollExpression_Damage();
		case "DnDBeyond Attack": prototype = dnd5e_RollExpression_DnDBeyondAttack();
		case "DnDBeyond Spell": prototype = dnd5e_RollExpression_DnDBeyondSpell();
		case "Drain": prototype = dnd5e_RollExpression_Drain();
		case "Healing": prototype = dnd5e_RollExpression_Healing();
		case "Save": prototype = dnd5e_RollExpression_Save();
		case "Save Damage": prototype = dnd5e_RollExpression_SaveDamage();
		case "Save Drain": prototype = dnd5e_RollExpression_SaveDrain();
		case "Save Effect": prototype = dnd5e_RollExpression_SaveEffect();
		case "Spell": prototype = dnd5e_RollExpression_SpellAttack();
		case "Target Check": prototype = dnd5e_RollExpression_TargetCheck();
		default: prototype = re]
		[types = dnd5e_RollExpression_getTypes (prototype)]
		[re = dnd5e_RollExpression_setTypes (re, types)]
		[updatedExpressions = json.append (updatedExpressions, re)]
}]

[h: macro.return = updatedExpressions]