[h: actionName = arg (0)]
[h: actionObj = arg (1)]
[h, if (json.length (macro.args) > 2): advDisadv = arg (2); advDisadv = "none"]

[h: attackType = json.get (actionObj, "attackType")]
[h, if (attackType == "Melee"): ability = "Strength"; ability = "Dexterity"]
[h: abilityBonus = eval (ability + "Bonus")]
[h: attackBonus = json.get (actionObj, "attackBonus") + abilityBonus]
[h: attackExpression = dnd5e_RollExpression_Attack (actionName, attackBonus)]
[h: attackExpression = dnd5e_RollExpression_setAdvantageDisadvantage (attackExpression, advDisadv)]
[h: damageRollObj = json.get (actionObj, "damageRollObj")]
[h: damageBonus = json.get (damageRollObj, "bonus") + abilityBonus]
[h: damageDiceRolled = json.get (damageRollObj, "diceRolled")]
[h: damageDiceSize = json.get (damageRollObj, "diceSize")]
[h: damageType = json.get (actionObj, "damageType")]
[h: damageExpression = dnd5e_RollExpression_Damage ()]
[h: damageExpression = dnd5e_RollExpression_setDiceRolled (damageExpression, damageDiceRolled)]
[h: damageExpression = dnd5e_RollExpression_setDiceSize (damageExpression, damageDiceSize)]
[h: damageExpression = dnd5e_RollExpression_setBonus (damageExpression, damageBonus)]
[h: damageExpression = dnd5e_RollExpression_addDamageType (damageExpression, damageType)]




[h: rollExpressions = json.append ("", attackExpression, damageExpression)]


[h: macro.return = rollExpressions]