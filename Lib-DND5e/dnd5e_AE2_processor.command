<!-- Get the hidden values from the form -->
[h: form = arg(0)]
[h: id = json.get(form, "hidden-id")]
[h: switchToken(id)]
[h: exps = decode(json.get(form, "hidden-exps"))]
[h: workingCopy = decode(json.get(form, "hidden-working-copy"))]
[h: metaData = decode(json.get(form, "hidden-meta-data"))]
[h: oldActionName = decode(json.get(form, "hidden-active-name"))]
[h: log.debug("dnd5e_AE2_processor: id=" + id + " form=" + json.indent(form))]
[h: json.toVars(dnd5e_AE2_getConstants())]

<!-- Get the old action type before reading the form -->
[h, if (json.isEmpty(exps)), code: {
	[h: oldActionType = ""]
}; {
	[h: firstExp = json.get(exps, 0)]
	[h: type = dnd5e_RollExpression_getTypedDescriptor(firstExp, "actionType")]
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
[h: currentActionName = dnd5e_RollExpression_getTypedDescriptor(firstExp, "actionName")]
[h, if (oldActionName != currentActionName), code: {
	[h: currentActionName = dnd5e_Util_createUniqueName(currentActionName, json.fields(workingCopy, "json"))]
	[h: workingCopy = json.remove(workingCopy, oldActionName)]
	[h: workingCopy = json.set(workingCopy, currentActionName, "{}")]
	[h: firstExp = dnd5e_RollExpression_addTypedDescriptor(firstExp, "actionName", currentActionName)]
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
		[h: firstExp = dnd5e_RollExpression_addTypedDescriptor(json.get(exps, 0), "actionName", currentActionName)]
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
		[h: args = json.set("{}", "actionName", currentActionName, "advantageDisadvantage", detail)]
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
		[h: currentActionName = dnd5e_Util_createUniqueName(" Copy of " + currentActionName, json.fields(workingCopy, "json"))]
		[h: workingCopy = json.set(workingCopy, currentActionName, "[]")]
		[h: firstExp = dnd5e_RollExpression_addTypedDescriptor(json.get(exps, 0), "actionName", currentActionName)]
		[h: exps = json.set(exps, 0, firstExp)]
	}]

	<!-- Exit Action? -->
	[h, if (control == "exit"), code: {
		[h: closeDialog("Attack Editor 2")]
		[h: return(0, "")]
	}]

	<!-- Macro Action? -->
	[h, if (control == "macro"), code: {
	}]
}]

<!-- Should we add a step? -->
[h, if (json.contains(form, "addStep")), code: {
	[h: newStep = json.get(form, "addStep")]
	[h, if (newStep == ATTACK_STEP_TYPE): addExp = dnd5e_AE2_decorateNewStep(dnd5e_RollExpression_Attack(), json.length(exps)); ""]
	[h, if (newStep == DAMAGE_STEP_TYPE): addExp = dnd5e_AE2_decorateNewStep(dnd5e_RollExpression_Damage(), json.length(exps)); ""]
	[h, if (newStep == SAVE_STEP_TYPE), code: {
    	[h: addExp = dnd5e_AE2_decorateNewStep(dnd5e_RollExpression_Save(), json.length(exps))]
    	[h: addExp = dnd5e_RollExpression_addType(addExp, "target")]
    };{""}]
	[h, if (newStep == SAVE_DAMAGE_STEP_TYPE): addExp = dnd5e_AE2_decorateNewStep(dnd5e_RollExpression_SaveDamage(), json.length(exps)); ""]
	[h, if (newStep == SAVE_CONDITION_STEP_TYPE): addExp = dnd5e_AE2_decorateNewStep(dnd5e_RollExpression_SaveEffect(), json.length(exps)); ""]
	[h, if (newStep == CONDITION_STEP_TYPE):  addExp = dnd5e_AE2_decorateNewStep(dnd5e_RollExpression_Condition(), json.length(exps)); ""]
	[h: exps = json.append(exps, addExp)]
	[h: log.debug("dnd5e_AE2_processor: addStep=" + json.indent(addExp))]
}; {""}]

<!-- Should we delete a step? -->
[h, if (json.contains(form, "deleteStep")), code: {
	[h: index = json.get(Form, "deleteStep")]
	[h: deletedExp = json.get(exps, index)]
	[h: deletedActionType = dnd5e_RollExpression_getTypedDescriptor(deletedExp, "actionType")]
	[h, if (deletedActionType != ""), code: {
		<!-- Deleted a specific action step, change type to free form -->
		[h: json.toVars(dnd5e_AE2_getConstants())]
		[h: newActionType = FREE_FORM_TYPE]
		[h: oldActionType = ""]
	}; {""}]
	[h: log.debug("dnd5e_AE2_processor: deleteStep=" + json.indent(deletedExp))]

	<!-- Remove the step and set the new row IDs on each expression -->
	[h: exps = json.remove(exps, index)]
	[h: newExps = "[]"]
	[h, for(index, 0, json.length(exps)): newExps = json.append(newExps, dnd5e_RollExpression_addTypedDescriptor(json.get(exps, index), "rowId", "row-" + index))]
	[h: exps = newExps]
	[h: log.debug("dnd5e_AE2_processor: deleteStep exps=" + json.indent(exps))]
}; {""}]

<!-- Should we add/remove extended fields -->
[h, if (json.contains(form, "extendStep")), code: {
	[h: list = stringToList(json.get(form, "extendStep"), "-")]
	[h: index = number(listGet(list, 0))]
	[h: exp = json.get(exps, index)]
	[h, if(listGet(list, 1) == "+"), code: {
		[h: exp = dnd5e_RollExpression_addTypedDescriptor(exp, "extendedValues", "-")]
	}; {
		[h: exp = dnd5e_RollExpression_removeTypedDescriptor(exp, "extendedValues")]
		[h: exp = json.remove(exp, "name")]
		[h: exp = json.remove(exp, "onCritAdd")]
	}]
	[h: exps = json.set(exps, index, exp)]
	[h: log.debug("dnd5e_AE2_processor: extendedStep exps=" + json.indent(exps))]
}; {""}]

<!-- Redraw the editor with the new info -->
[h: dnd5e_AE2_attackEditor(currentActionName, id, exps, oldActionType, newActionType, workingCopy, metaData)]