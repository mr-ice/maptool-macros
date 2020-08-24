[h: damageExpression = arg (0)]
[h, if (dnd5e_RollExpression_hasType (damageExpression, "saveable") && dnd5e_RollExpression_hasType (damageExpression, "damageable")), code: {
	[h: saveDC = dnd5e_RollExpression_getSaveDC (damageExpression)]
	[h: saveEffect = dnd5e_RollExpression_getSaveEffect (damageExpression)]
	[h: saveAbility = dnd5e_RollExpression_getSaveAbility (damageExpression)]
	[h: damageExpression = dnd5e_RollExpression_addDescription (damageExpression, "Target must make a " + saveAbility + " DC " + saveDC + " or take " + dnd5e_RollExpression_getTotal (damageExpression) + " " + dnd5e_RollExpression_getDamageTypes (damageExpression))]
	[h: damageExpression = dnd5e_RollExpression_addDescription (damageExpression, saveEffect)]

	<!-- Build the save and apply effect to damage text -->
	[h: save = "DC " + saveDC + " " + saveAbility + " save for " + saveEffect]
	[switch(lower(saveEffect)):
	case "half": save = save + " (" + floor(dnd5e_RollExpression_getTotal(damageExpression)/2) + ")";
	case "none": save = save + " (0)");
	default: ""]
	[h: damageExpression = dnd5e_RollExpression_addTypedDescriptor(damageExpression, "saveable", save)] 
}]
[h: macro.return = damageExpression]