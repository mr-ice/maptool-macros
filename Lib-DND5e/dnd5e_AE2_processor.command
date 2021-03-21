<!-- Get the hidden values from the form -->
[h: form = arg(0)]
[h: id = json.get(form, "hidden-id")]
[h: switchToken(id)]
[h: exps = decode(json.get(form, "hidden-exps"))]
[h: workingCopy = decode(json.get(form, "hidden-working-copy"))]
[h: metaData = decode(json.get(form, "hidden-meta-data"))]
[h: oldActionName = decode(json.get(form, "hidden-active-name"))]
[h: log.debug("dnd5e_AE2_processor: id=" + id + " form=" + json.indent(form))]
[h: dnd5e_AE2_getConstants()]

<!-- Get the old action type before reading the form -->
[h, if (json.isEmpty(exps)), code: {
	[h: oldActionType = ""]
}; {
	[h: firstExp = json.get(exps, 0)]
	[h: type = dnd5e_RollExpression_getTypedDescriptor(firstExp, ACTION_TYPE_TD)]
	[h: oldActionType = type]
	[h, if (type == DNDB_ATTACK_TYPE || type == DNDB_SPELL_TYPE): oldActionType = oldActionType + "-" + dnd5e_RollExpression_getName(firstExp); ""]
	[h, if (type == DNDB_SPELL_TYPE): oldActionType = oldActionType + "-" + json.get(firstExp, "spellLevel"); ""]
}]
[h: log.debug("dnd5e_AE2_processor: oldActionType=" + oldActionType + " exps=" + json.indent(exps))]

<!-- Read the values from the form and add them to the expression -->
[h: ret = dnd5e_AE2_readForm(exps, form, metaData)]
[h: exps = json.get(ret, "exps")]
[h: newActionType = json.get(ret, "newActionType")]
[h: metaData = json.get(ret, "metaData")]
[h: log.debug("dnd5e_AE2_processor: ret=" + json.indent(ret))]

<!-- Handle a name change -->
[h: firstExp = json.get(exps, 0)]
[h: currentActionName = dnd5e_RollExpression_getTypedDescriptor(firstExp, ACTION_NAME_TD)]
[h, if (oldActionName != currentActionName), code: {
	[h: currentActionName = dnd5e_Util_createUniqueName(currentActionName, json.fields(workingCopy, "json"))]
	[h: workingCopy = json.remove(workingCopy, oldActionName)]
	[h: workingCopy = json.set(workingCopy, currentActionName, "{}")]
	[h: firstExp = dnd5e_RollExpression_addTypedDescriptor(firstExp, ACTION_NAME_TD, currentActionName)]
	[h: exps = json.set(exps, 0, firstExp)]
}]

<!-- Did the user choose another action? -->
[h, if (json.contains(form, "chooseAction") && json.get(form, "chooseAction") != oldActionName), code: {
	[h: workingCopy = json.set(workingCopy, currentActionName, exps)]
	[h: currentActionName = json.get(form, "chooseAction")]
	[h: json.toVars(dnd5e_AE2_extractAction(workingCopy, currentActionName))]
}]

<!-- Has a control button been pressed, save off the edited action -->
[h, if (json.contains(form, "control")), code: {
	[h: workingCopy = json.set(workingCopy, currentActionName, exps)]

	<!-- Delete Action? -->
	[h: control = json.get(form, "control"))]
	[h, if (control == "delete"), code: {
		[h: workingCopy = json.remove(workingCopy, currentActionName)]
		[h, if (!json.isEmpty(workingCopy)): currentActionName = json.get(json.fields(workingCopy, "json"), 0)]
		[h, if (!json.isEmpty(workingCopy)): json.toVars(dnd5e_AE2_extractAction(workingCopy, currentActionName))]
		<!-- No more actions defined, create a new one -->
		[h, if (json.isEmpty(workingCopy)): control = "new"]
	}]
	
	<!-- New action? If we deleted the last action, it continues its work here-->
	[h, if (control == "new"), code: {
		[h: currentActionName = dnd5e_Util_createUniqueName("New Action", json.fields(workingCopy, "json"))]
		[h: workingCopy = json.set(workingCopy, currentActionName, "[]")]
		[h: exps = dnd5e_AE2_typeAttack("", "[]")]
		[h: firstExp = dnd5e_RollExpression_addTypedDescriptor(json.get(exps, 0), ACTION_NAME_TD, currentActionName)]
		[h: exps = json.set(exps, 0, firstExp)]
		[h: oldActionType = ATTACK_TYPE]
		[h: newActionType = ATTACK_TYPE]
	}]

	<!-- Run Actions -->
	[h, if (startsWith(control, "run-")), code: {
		[h: setProperty("_AE2_Actions", workingCopy)]
		[h: setProperty("_AE2_Metadata", metaData)]
		[h: closeDialog("Attack Editor 2")]
		[h: detail = listGet(control, 1, "-")]
		[h: args = json.set("{}", "actionName", currentActionName, "advDisadv", detail)]
		[h: link = macroLinkText("dnd5e_Macro_rollAction@Lib:DnD5e", "all", args, id)]
		[h: log.debug("dnd5e_AE2_processor: link=" + json.indent(link))]
		[h: execLink(link)]
		[h: abort(0)]
	}]

	<!-- Save Action? -->
	[h, if (control == "save"), code: {
		[h: setProperty("_AE2_Actions", workingCopy)]
		[h: setProperty("_AE2_Metadata", metaData)]
		[h: closeDialog("Attack Editor 2")]
		[h: return(0, "")]
	}]

	<!-- Duplicate Action? -->
	[h, if (control == "duplicate"), code: {
		[h: currentActionName = dnd5e_Util_createUniqueName("Copy of " + currentActionName, json.fields(workingCopy, "json"))]
		[h: firstExp = dnd5e_RollExpression_addTypedDescriptor(json.get(exps, 0), ACTION_NAME_TD, currentActionName)]
		[h: exps = json.set(exps, 0, firstExp)]
		[h: workingCopy = json.set(workingCopy, currentActionName, exps)]
	}]

	<!-- Exit Action? -->
	[h, if (control == "exit"), code: {
		[h: closeDialog("Attack Editor 2")]
		[h: return(0, "")]
	}]

	<!-- Macro Action? -->
	[h: saveAttackAsMacro = if(control == "macro", 1, 0)]
	[h: currentMacros = getMacros("json")]
	[h, if (saveAttackAsMacro): saveAttackAsMacro = if (json.contains(currentMacros, currentActionName), 0 , 1)]
	[h: doNotNeedAdvantage = 1]
	[h, foreach (exp, exps), if (dnd5e_RollExpression_getExpressionType(exp) == "Attack"): doNotNeedAdvantage = 0]
	[h, if (saveAttackAsMacro), code: {
		[h: setProperty("_AE2_Actions", workingCopy)]
		[h: setProperty("_AE2_Metadata", metaData)]
		[h: fontColor = json.get(metaData, "macroFontColor")]
		[h: buttonColor = json.get(metaData, "macroBgColor")]
		[h: sortByBase = listCount(currentMacros)]
		[h: macroConfig = json.set ("", "applyToSelected", 1,
								"autoExecute", 1,
								"color", buttonColor,
								"fontSize", "1.05em",
								"fontColor", fontColor,
								"group", "D&D 5e - Actions",
								"playerEditable", 1,
								"minWidth", 170,
								"tooltip", "Execute the " + currentActionName + " action.",
								"sortBy", sortByBase)]
		<!-- Normal Attack -->
		[h: macroInputs = json.set ("", "actionName", currentActionName)]
		[h: lastSortBy = dnd5e_Macro_createAdvDisadvMacroFamily(currentActionName, "dnd5e_Macro_rollAction@Lib:DnD5e", macroInputs, macroConfig, doNotNeedAdvantage)]
		[h: lastSortBy = lastSortBy + 1]
		<!-- Edit -->
		[h: macroConfig = json.set(macroConfig, "minWidth", 12,
						"tooltip", "Edit the " + currentActionName + " attack",
						"sortBy", sortByBase + "-" + lastSortBy)]
		[h: macroCmd = "[macro('dnd5e_AE2_attackEditor@Lib:DnD5e'):'" + currentActionName + "']"]
		[h: createMacro ("<html>&#x270e;</html>", macroCmd, macroConfig)]
		<!-- Remove Macros -->
		[h: macroInputs = json.append("[]", currentActionName, "D&D 5e - Actions")]
		[h: macroConfig = json.set(macroConfig, "minWidth", 12,
						"tooltip", "Remove the " + currentActionName + " attack macros. This does not remove the actual action, just the macros",
						"sortBy", sortByBase + "-" + lastSortBy + 1)]
		[h: macroCmd = "[macro('dnd5e_Macro_clearMacroFamilyFromGroup@Lib:DnD5e'): '" + macroInputs + "']"]
		[h: createMacro ("<html>&#128939;</html>", macroCmd, macroConfig)]
c	}]
}]

<!-- Should we add a step? -->
[h, if (json.contains(form, "addStep")), code: {
	[h: newStep = json.get(form, "addStep")]
	[h, if (newStep == ATTACK_STEP_TYPE): addExp = dnd5e_AE2_decorateNewStep(dnd5e_RollExpression_Attack(), json.length(exps)); ""]
	[h, if (newStep == DAMAGE_STEP_TYPE): addExp = dnd5e_AE2_decorateNewStep(dnd5e_RollExpression_Damage(), json.length(exps)); ""]
	[h, if (newStep == SAVE_STEP_TYPE), code: {
    	[h: addExp = dnd5e_AE2_decorateNewStep(dnd5e_RollExpression_Save(), json.length(exps))]
    	[h: addExp = dnd5e_RollExpression_addType(addExp, TARGET_ROLL_TYPE)]
    };{""}]
	[h, if (newStep == SAVE_DAMAGE_STEP_TYPE): addExp = dnd5e_AE2_decorateNewStep(dnd5e_RollExpression_SaveDamage(), json.length(exps)); ""]
	[h, if (newStep == SAVE_CONDITION_STEP_TYPE): addExp = dnd5e_AE2_decorateNewStep(dnd5e_RollExpression_SaveEffect(), json.length(exps)); ""]
	[h, if (newStep == CONDITION_STEP_TYPE):  addExp = dnd5e_AE2_decorateNewStep(dnd5e_RollExpression_Condition(), json.length(exps)); ""]
	[h, if (newStep == TARGET_CHECK_STEP_TYPE):  addExp = dnd5e_AE2_decorateNewStep(dnd5e_RollExpression_TargetCheck(), json.length(exps)); ""]
	[h, if (newStep == DRAIN_STEP_TYPE):  addExp = dnd5e_AE2_decorateNewStep(dnd5e_RollExpression_Drain(), json.length(exps)); ""]
	[h, if (newStep == SAVE_DRAIN_STEP_TYPE):  addExp = dnd5e_AE2_decorateNewStep(dnd5e_RollExpression_SaveDrain(), json.length(exps)); ""]
	[h: exps = json.append(exps, addExp)]
	[h: log.debug("dnd5e_AE2_processor: addStep=" + json.indent(addExp))]
}; {""}]

<!-- Should we delete a step? -->
[h, if (json.contains(form, "deleteStep")), code: {
	[h: index = json.get(form, "deleteStep")]
	[h: deletedExp = json.get(exps, index)]
	[h: exps = json.remove(exps, index)]
	[h: log.debug(getMacroName() + ": index=" + index + " deleteStep=" + json.indent(json.append("[]", deletedExp, exps)))]	

	<!-- Did we delete a save? fix its children -->
	[h, if (dnd5e_RollExpression_getExpressionType(deletedExp) == "Save"), for(i, index, json.length(exps)), code: {
		[h: exp = json.get(exps, i)]
		[h: type = dnd5e_RollExpression_getExpressionType(exp)]
		[h, if (type == SAVE_DAMAGE_STEP_TYPE): exp = dnd5e_RollExpression_setExpressionType(exp, DAMAGE_STEP_TYPE)]
		[h, if (type == SAVE_DAMAGE_STEP_TYPE): exp = json.remove(exp, SAVE_EFFECT_FIELD)]
		[h, if (type == SAVE_CONDITION_STEP_TYPE): exp = dnd5e_RollExpression_setExpressionType(exp, CONDITION_STEP_TYPE)]
		[h, if (type == SAVE_CONDITION_STEP_TYPE): exp = json.remove(exp, SAVE_RESULT_FIELD)]
		[h, if (type == SAVE_DRAIN_STEP_TYPE): exp = dnd5e_RollExpression_setExpressionType(exp, DRAIN_STEP_TYPE)]
		[h, if (type == SAVE_DRAIN_STEP_TYPE): exp = json.remove(exp, SAVE_EFFECT_FIELD)]
		[h, if (type == SAVE_STEP_TYPE): i = json.length(exps)]
		[h: exps = json.set(exps, i, exp)]
	}]

	<!-- When DndBeyond Weapons or Spell types are being changed to free form, the first step should be deleted too, if not already -->
	[h: deletedActionType = dnd5e_RollExpression_getTypedDescriptor(deletedExp, ACTION_TYPE_TD)]
	[h: dndbType = if (deletedActionType == DNDB_ATTACK_TYPE || deletedActionType == DNDB_SPELL_TYPE, 1, 0)]
	[h, if (dndbType && index != 0), code: {
		[h: index = 0]
		[h: deletedExp = json.get(exps, index)]
		[h: exps = json.remove(exps, index)]
	}]
	
	<!-- We need to change the type to free form when an old action type is removed -->
	[h, if (deletedActionType != ""), code: {
		[h: newActionType = FREE_FORM_TYPE]
		[h: oldActionType = FREE_FORM_TYPE]
		[h: newExps = "[]"]
		[h, for(i, 0, json.length(exps)): newExps = json.append(newExps, dnd5e_RollExpression_removeTypedDescriptor(json.get(exps, i), ACTION_TYPE_TD))]
		[h: exps = newExps]
	}]

	<!-- Copy the name and description if the first step is deleted -->
	[h, if (index == 0), code: {
		[h: firstExp = json.get(exps, 0)]
		[h: firstExp = dnd5e_RollExpression_addTypedDescriptor(firstExp, ACTION_NAME_TD, dnd5e_RollExpression_getTypedDescriptor(deletedExp, ACTION_NAME_TD))]
		[h: firstExp = dnd5e_RollExpression_addTypedDescriptor(firstExp, ACTION_DESC_TD, dnd5e_RollExpression_getTypedDescriptor(deletedExp, ACTION_DESC_TD))]
		[h: firstExp = dnd5e_RollExpression_addTypedDescriptor(firstExp, ACTION_TYPE_TD, FREE_FORM_TYPE)]
		[h: exps = json.set(exps, 0, firstExp)]
	}]

	<!-- Remove the step and set the new row IDs on each expression -->
	[h: newExps = "[]"]
	[h, for(index, 0, json.length(exps)): newExps = json.append(newExps, dnd5e_RollExpression_addTypedDescriptor(json.get(exps, index), ROW_ID_TD, "row-" + index))]
	[h: exps = newExps]
	[h: log.debug(getMacroName() + ": deleteStep Done=" + json.indent(exps))]	
}]

<!-- Should we add/remove extended fields -->
[h, if (json.contains(form, "extendStep")), code: {
	[h: list = stringToList(json.get(form, "extendStep"), "-")]
	[h: index = number(listGet(list, 0))]
	[h: exp = json.get(exps, index)]
	[h, if(listGet(list, 1) == "+"), code: {
		[h: exp = dnd5e_RollExpression_addTypedDescriptor(exp, EXTENDED_VALUES_TD, "-")]
	}; {
		[h: exp = dnd5e_RollExpression_removeTypedDescriptor(exp, EXTENDED_VALUES_TD)]
		[h: exp = json.remove(exp, "name")]
		[h: exp = json.remove(exp, "onCritAdd")]
	}]
	[h: exps = json.set(exps, index, exp)]
	[h: log.debug("dnd5e_AE2_processor: extendedStep exps=" + json.indent(exps))]
}; {""}]

<!-- Redraw the editor with the new info -->
[h: dnd5e_AE2_attackEditor(currentActionName, id, exps, oldActionType, newActionType, workingCopy, metaData)]