[h: log.debug(getMacroName() + ": args=" + json.indent(macro.args))]
[h: id = arg(0)]
[h: exp = arg(1)]
[h: state = arg(2)]
[h, if (argCount() > 3): saveRoll = arg(3); saveRoll = ""]

<!-- Get the ability and drain amount -->
[h: ability = dnd5e_RollExpression_getDrainAbility(exp)]
[h: drain = dnd5e_RollExpression_getTotal(exp)]

<!-- Handle the save -->
[h, if (json.isEmpty(saveRoll)), code: {
	[h: saveOutput = ""]
	[h: saveText = ""]
};{
	[h: saveEffect = dnd5e_RollExpression_getSaveEffect(exp)]
	[h: save = dnd5e_SavedAttacks_processSave(saveRoll, drain, saveEffect)]
	[h: saveOutput = json.get(save, "saveOutput")]
	[h: saveText = json.get(save, "saveText")]
	[h: drain = json.get(save, "damage")]	
}]

<!-- Update the output -->
[h: output = json.get(state, "output")]
[h: tt = dnd5e_RollExpression_getTypedDescriptor(exp, "tooltipRoll") + " = " 
		+ dnd5e_RollExpression_getTypedDescriptor(exp, "tooltipDetail") + " = " + dnd5e_RollExpression_getTotal(exp)]
[h, if (saveText != ""): saveText = "(" + saveText + ")"]
[h, if (drain != dnd5e_RollExpression_getTotal(exp)): tt = tt + ", Adjusted" + saveText + ": " + drain]
[h: dnd5e_Health_applyAbilityChange(ability, 0 - drain, id)]
[h: tt = tt + "; New " + ability + " = " + getProperty(ability, id)]
[h: output = output + " <span title='" + tt + "'>Drain " + ability + ": " + drain + "</span>"]
[h, if (!json.isEmpty(saveOutput)): output = output + " (" + saveOutput + ")"]
[h: macro.return = json.set(state, "output", output + ",")]