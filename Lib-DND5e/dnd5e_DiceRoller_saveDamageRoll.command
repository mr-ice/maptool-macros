[h: damageExpression = arg (0)]
[h: log.debug (getMacroName() + ": rolling " + damageExpression)]
[h, if (dnd5e_RollExpression_hasType (damageExpression, "saveable") && dnd5e_RollExpression_hasType (damageExpression, "damageable")), code: {
	[h: saveDC = dnd5e_RollExpression_getSaveDC (damageExpression, 1)]
	[h: saveEffect = dnd5e_RollExpression_getSaveEffect (damageExpression)]
	[h: saveAbility = dnd5e_RollExpression_getSaveAbility (damageExpression)]
	[h: damageExpression = dnd5e_RollExpression_addDescription (damageExpression, "Target must make a " + saveAbility + " DC " + saveDC + " or take " + dnd5e_RollExpression_getTotal (damageExpression) + " " + dnd5e_RollExpression_getDamageTypes (damageExpression))]
	[h: damageExpression = dnd5e_RollExpression_addDescription (damageExpression, saveEffect)]

	<!-- Build the save and apply effect to damage text -->
	[h: save = "DC " + saveDC + " " + saveAbility + " save for " + saveEffect]
	[h: saveDamage = dnd5e_RollExpression_getTotal(damageExpression)]
	[h: save = dnd5e_Util_modifySaveDamage(saveDamage, saveEffect)]
	[h: saveDamage = json.get(save, "damage")]
	[h: damageExpression = dnd5e_RollExpression_addTypedDescriptor(damageExpression, "saveable", save + " (" + saveDamage + ")")] 
	[h: damageExpression = dnd5e_RollExpression_addTypedDescriptor(damageExpression, "save-effect-damage", saveDamage)] 
}]
[h: macro.return = damageExpression]
