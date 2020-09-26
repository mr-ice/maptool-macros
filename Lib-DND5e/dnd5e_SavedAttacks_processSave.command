[h: log.debug(getMacroName() + ": args=" + json.indent(macro.args))]
[h: saveRoll = arg(0)]
[h: totalDamage = arg(1)]
[h: saveEffect = arg(2)]

<!-- Generate a save tool tip -->
[h: tt = "DC " + dnd5e_RollExpression_getSaveDC(saveRoll) + " " + dnd5e_RollExpression_getSaveAbility(saveRoll) + ": "]
[h: tt = tt + dnd5e_RollExpression_getTypedDescriptor(saveRoll, "tooltipRoll") + " = " 
		+ dnd5e_RollExpression_getTypedDescriptor(saveRoll, "tooltipDetail") + " = " + dnd5e_RollExpression_getTotal(saveRoll)]
[h: saveResult = json.get(saveRoll, "saveResult")]
[h, if (saveResult == "passed"): saveResult = trim(lower(saveEffect))]
[h: log.debug(getMacroName() + ": saveResult=" + saveResult + " tt=" + tt)]
[h: save = dnd5e_Util_modifySaveDamage(totalDamage, saveResult)]
[h: macro.return = json.set("{}", "saveOutput", "<span title='" + tt + "'>" + json.get(save, "saveText") + "</span>", "damage", json.get(save, "damage"),
                                  "saveText", json.get(save, "saveText"))]