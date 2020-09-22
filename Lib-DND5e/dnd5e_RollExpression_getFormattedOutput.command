[h: json.toVars(dnd5e_AE2_getConstants())]
[h, if (argCount() > 1): returnString = arg(1); returnString = 0]
[h: log.debug(getMacroName() + ": args=" + json.indent(macro.args))]

<!-- Get a title from the first expression's actionName descriptor or its name -->
[h: firstExp = json.get(arg(0), 0)]
[h: aTitle = dnd5e_RollExpression_getTypedDescriptor(firstExp, "actionName")]
[h: actionExecution = if(aTitle == "", 0, 1)]
[h, if (aTitle == ""): aTitle = dnd5e_RollExpression_getName(firstExp)]
[h: aTitle = dnd5e_Util_encodeHtml(aTitle)]

<!-- If there is a description, attach it to the title as a tool tip -->
[h: tooltip = if(returnString, "data-toggle='tooltip' ", "") + dnd5e_Util_formatTooltip(dnd5e_RollExpression_getTypedDescriptor(firstExp, "actionDesc")) + "'"]
[h: out = ""]
[h: out = out + "<div>"]
[h: out = out + "  <span " + tooltip + "><font size='5'><b>" + aTitle + "</b></font></span>"]
[h: out = out + "  <div style='margin-left: 15px;'>"]

<!-- View each expression -->
[h: indent = "<div style='margin-left:15px;'>"]
[h: damageTotal = 0]
[h: lastDamage = 0]
[h: showConditions = 1]
[foreach(exp, arg(0), ""), code: {
	[h: log.debug("dnd5e_RollExpression_getFormattedOutput: Working On" + json.indent(exp))]

	<!-- Generate the tool tip -->
	[h: total = dnd5e_RollExpression_getTotal(exp)]
	[h: tt = dnd5e_RollExpression_getTypedDescriptor(exp, "tooltipRoll") + " = " 
			+ dnd5e_RollExpression_getTypedDescriptor(exp, "tooltipDetail") + " = " + total]
	[h: tt = dnd5e_Util_encodeHtml(tt)]
	[h: tt = "<span " + if(returnString, "data-toggle='tooltip' ", "") + "title='" + tt + "'>"]

	<!-- Handle top level expressions only by type -->
	[h: expressionType = dnd5e_RollExpression_getExpressionType(exp)]
	[h, if (expressionType == ATTACK_STEP_TYPE), code: {

		<!-- Get all of the condition output -->
		[h: conditions = dnd5e_RollExpression_getTypedDescriptor(exp, "condition")]
		[h, if (!json.isEmpty(conditions) && showConditions): out = out + json.toList(conditions, "<br>") + "<br>"]
		[h: showConditions = 0]

		<!-- Attack roll ouput with tool tip, advantage, critical, auto miss & lucky -->
		[h: out = out + tt + "<b><font size='4'>"+total+"</font></b> to hit"]
		[h: out = out + dnd5e_RollExpression_getTypedDescriptor(exp, "advantageable")]
		[h: name = dnd5e_RollExpression_getName(exp)]
		[h, if (name != ""): out = out + " for " + dnd5e_Util_encodeHtml(name)]
		[h, if (dnd5e_RollExpression_getRoll(exp) == 20): out = out + " <font color='red' size='4'><b><i>Critical</i></b></font></span>"]
		[h, if (dnd5e_RollExpression_getRoll(exp) == 1): out = out + " <font size='4' color='red'><b><i>Automatic Miss</i></b></font></span>"]
		[h: out = out + dnd5e_RollExpression_getTypedDescriptor(exp, "lucky")]
		[h: out = out + "</span><br>"]
	}]
	[h, if (expressionType == DAMAGE_STEP_TYPE), code: {

		<!-- Regular damage with tool tip and damage types -->
		[h: damageTotal = damageTotal + total]
		[h: lastDamage = total]
		[h: out = out + indent + tt + "<b><font size='4'>"+total+"</font></b>"]
		[h: out = out + " " + json.toList(dnd5e_RollExpression_getDamageTypes(exp), ", ") + " Damage "]
		[h: name = dnd5e_RollExpression_getName(exp)]
		[h, if (name != ""): out = out + " from " + dnd5e_Util_encodeHtml(name)]
		[h: out = out + "</span></div>"]
	}]
	[h, if (expressionType == SAVE_DAMAGE_STEP_TYPE), code: {

		<!-- Damage on Save with tool tip, damage types & save information -->
		[h: damageTotal = damageTotal + total]
		[h: lastDamage = total]
		[h: out = out + indent + tt + "<b><font size='4'>"+total+"</font></b> "]
		[h: out = out + json.toList(dnd5e_RollExpression_getDamageTypes(exp), ", ") + " Damage "]
		[h: name = dnd5e_RollExpression_getName(exp)]
		[h, if (name != ""): out = out + " from " + dnd5e_Util_encodeHtml(name)]
		[h: out = out + " if target save fails."]
		
		<!-- Actions apply the save effect here w/o DC & Ability, the attack editor uses those 2 fields -->
		[h: saveEffect = dnd5e_RollExpression_getSaveEffect(exp)]
		[h: saveEffectDamage = dnd5e_RollExpression_getTypedDescriptor(exp, "save-effect-damage")]
		[h, if (lower(saveEffect) == "none"): saveEffect = "no"]
		[h, if (isNumber(saveEffect)): saveEffect = floor(saveEffect * 100) + "%"]
		[h, if (saveEffect != ""): saveEffect = saveEffect + " damage" + if(saveEffectDamage == 0, "", " of " + saveEffectDamage); 
					saveEffect = saveEffectDamage + " damage"]
		[h, if (actionExecution): out = out + " If target save passes the target takes " + saveEffect]
		[h: saveable = dnd5e_RollExpression_getTypedDescriptor(exp, "saveable")]
		[h, if (!actionExecution): out = out + "<i><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + saveable]
		[h: out = out + "</span></div>"]
	}]
	[h, if (expressionType == SAVE_STEP_TYPE), code: {

		<!-- Actions create a separate target save object -->
		[h: saveDC = dnd5e_RollExpression_getSaveDC (exp)]
		[h: saveAgainst = json.get(exp, SAVE_AGAINST_FIELD)]
		[h, if (saveAgainst != ""): saveAgainst = " against " + dnd5e_Util_encodeHtml(saveAgainst)]
		[h: saveAbility = dnd5e_RollExpression_getSaveAbility (exp)]
		[h: save = "Target must make a DC " + saveDC + " " + saveAbility + " save" + saveAgainst]
		[h: out = out + "<i>"+save+" "]
		[h: name = dnd5e_RollExpression_getName(exp)]
		[h, if (name != ""): out = out + " for " + dnd5e_Util_encodeHtml(name)]
		[h: out = out + "</i><br>"]
	}]
	[h, if (expressionType == SAVE_CONDITION_STEP_TYPE), code: {

		<!-- Actions can apply states to the target depending on an earlier save -->
		[h: saveResult = json.get(exp, SAVE_RESULT_FIELD) + "ed"]
		[h: saveConditions = json.toList(json.get(exp, SAVE_CONDITION_FIELD), ", ")]
		[h: condition = "If target save " + saveResult + " then apply these states on the target: "]
		[h: out = out + indent + condition + "<b>" + saveConditions + "</b> "]
		[h: name = dnd5e_RollExpression_getName(exp)]
		[h, if (name != ""): out = out + " for " + dnd5e_Util_encodeHtml(name)]
		[h: out = out + "</div>"]
	}]
	[h, if (expressionType == CONDITION_STEP_TYPE), code: {

		<!-- Actions can apply states to the token --->
		[h: saveConditions = json.toList(json.get(exp, SAVE_CONDITION_FIELD))]
		[h: out = out + indent + "Apply these states on the target:<b> "+saveConditions+"</b> "]
		[h: name = dnd5e_RollExpression_getName(exp)]
		[h, if (name != ""): out = out + " for " + dnd5e_Util_encodeHtml(name)]
		[h: out = out + "</div>"]
	}]
	[h, if (expressionType == TARGET_CHECK_STEP_TYPE), code: {

		<!-- Actions can apply states to the token --->
		[h: expression = dnd5e_Util_encodeHtml(dnd5e_RollExpression_getTargetCheck(exp))]
		[h: name = dnd5e_RollExpression_getName(exp)]
		[h, if (name != ""): name = " " + dnd5e_Util_encodeHtml(name)]
		[h: out = out + "<i>Check the target for"+name+": <b>"+expression+"</b>"]
		[h: out = out + "</i><br>"]
	}]
	[h: log.debug("-----------------------------------------------------------------------")]
}]
[h, if(damageTotal != lastDamage): out = out + "<b><font size='4'>" + damageTotal + "</font></b> Total damage"; ""]
[h: out = out + "  </div>"]
[h: out = out + "</div>"]
[h: log.debug(getMacroName() + ": returnString=" + returnString + " out=" + out)]
[r, if (returnString != 0), code: {
	[h: return(0, out)]
};{
	[r: out]
}]