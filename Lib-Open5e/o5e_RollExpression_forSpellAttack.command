[h: actionName = arg (0)]
[h: actionObj = arg (1)]
[h, if (json.length (macro.args) > 2): advDisadv = arg (2); advDisadv = "none"]
[h: o5e_Constants (getMacroName())]

[h: spellcastingAbility = json.get (actionObj, "spellcastingAbility")]
[h, switch (spellcastingAbility):
	case "Strength": selectedAbility = 0;
	case "Dexterity": selectedAbility = 1;
	case "Constitution": selectedAbility = 2;
	case "Intelligence": selectedAbility = 3;
	case "Wisdom": selectedAbility = 4;
	case "Charisma": selectedAbility = 5;
	default: log.debug (CATEGORY + "## ...wut? spellcastingAbility = " + spellcastingAbility);
]

<!-- in case we didnt get a match, get the difference for the attackBonus -->
[h: attackBonus = json.get (actionObj, "attackBonus")]
[h: log.debug (CATEGORY + "## selectedAbility = " + selectedAbility + "; attackBonus = " +
		attackBonus]
[h: attackExpression = dnd5e_RollExpression_SpellAttack (actionName, selectedAbility)]
[h: attackExpression = dnd5e_RollExpression_setBonus (attackExpression, attackBonus)]
[h: attackExpression = dnd5e_RollExpression_setProficiency (attackExpression, 1)]
[h: damageExpressions = o5e_RollExpression_forDamageAction (actionObj, attackExpression)]
[h: rollExpressions = json.append ("", attackExpression)]
[h: rollExpressions = json.merge (rollExpressions, damageExpressions)]
[h: extraObjs = json.get (actionObj, "extraDamage")]
[h, foreach (extraObj, extraObjs), code: {
	[extDamageExpressions = o5e_RollExpression_forDamageAction (extraObj)]
	[rollExpressions = json.merge (rollExpressions, extDamageExpressions)]
}]

[h: macro.return = rollExpressions]