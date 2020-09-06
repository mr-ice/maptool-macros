[h: json.toVars(dnd5e_AE2_getConstants())]

<!-- Get a title from the first expression's actionName descriptor or its name -->
[h: firstExp = json.get(arg(0), 0)]
[h: aTitle = dnd5e_RollExpression_getTypedDescriptor(firstExp, "actionName")]
[h: actionExecution = if(aTitle == "", 0, 1)]
[h, if (aTitle == ""): aTitle = dnd5e_RollExpression_getName(firstExp)]
[h: aTitle = dnd5e_Util_encodeHtml(aTitle)]

<!-- If there is a description, attach it to the title as a tool tip -->
[h: tooltip = dnd5e_Util_formatTooltip(dnd5e_RollExpression_getTypedDescriptor(firstExp, "actionDesc"))]
<div>
  <span style='font: bold 14px;' [r:tooltip]>[r:aTitle]</span>
  <div style='left-margin: 15px;'>

<!-- View each expression -->
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

	<!-- Handle top level expressions only by type -->
	[h: expressionType = dnd5e_RollExpression_getExpressionType(exp)]
	[r, if (expressionType == ATTACK_STEP_TYPE), code: {

		<!-- Get all of the condition output -->
		[h: conditions = dnd5e_RollExpression_getTypedDescriptor(exp, "condition")]
		[h: log.debug("dnd5e_RollExpression_getFormattedOutput: conditions: " + json.indent(conditions)))]		
		[r, if (!json.isEmpty(conditions) && showConditions): json.toList(conditions, "<br>") + "<br>"]
		[h: showConditions = 0]

		<!-- Attack roll ouput with tool tip, advantage, critical, auto miss & lucky -->
		<span title='[r:tt]'><span style='font: bold 12px;' title='[r:tt]'>[r:total]</span> to hit
		[r: dnd5e_RollExpression_getTypedDescriptor(exp, "advantageable")]
		[h: name = dnd5e_RollExpression_getName(exp)]
		[r, if (name != ""): " for " + dnd5e_Util_encodeHtml(name)]
		[h: critable = json.path.read(arg(0), ".typedDescriptors.critable", "ALWAYS_RETURN_LIST")]
		[r, if (!json.isEmpty(critable)): " <span style='color: red; font: bold italic 12px;' title='" 
			+ tt + "'>Critical</span>"; ""]
		[r, if (dnd5e_RollExpression_getRoll(exp) == 1): " <span style='color: red; font: bold italic 12px;' title='" 
			+ tt + "'>Automatic Miss</span>"; ""]
		[r: dnd5e_RollExpression_getTypedDescriptor(exp, "lucky")]
		</span><br>
	};{[h:""]}]
	[r, if (expressionType == DAMAGE_STEP_TYPE), code: {

		<!-- Regular damage with tool tip and damage types -->
		[h: damageTotal = damageTotal + total]
		[h: lastDamage = total]
		<span title='[r:tt]'><span style='font: bold 12px;' title='[r:tt]'>&nbsp;&nbsp;[r:total]</span>
		[r: json.toList(dnd5e_RollExpression_getDamageTypes(exp), ", ")] Damage
		[h: name = dnd5e_RollExpression_getName(exp)]
		[r, if (name != ""): " from " + dnd5e_Util_encodeHtml(name)]
		</span><br>
	};{[h:""]}]	
	[r, if (expressionType == SAVE_DAMAGE_STEP_TYPE), code: {

		<!-- Damage on Save with tool tip, damage types & save information -->
		[h: damageTotal = damageTotal + total]
		[h: lastDamage = total]
		<span title='[r:tt]'><span style='font: bold 12px;' title='[r:tt]'>&nbsp;&nbsp;[r:total]</span>
		[r: json.toList(dnd5e_RollExpression_getDamageTypes(exp), ", ")] Damage
		[h: name = dnd5e_RollExpression_getName(exp)]
		[r, if (name != ""): " from " + dnd5e_Util_encodeHtml(name)]
		if target save fails.
		
		<!-- Actions apply the save effect here w/o DC & Ability, the attack editor uses those 2 fields -->
		[h: saveEffect = dnd5e_RollExpression_getSaveEffect(exp)]
		[h: saveEffectDamage = dnd5e_RollExpression_getTypedDescriptor(exp, "save-effect-damage")]
		[h, if (lower(saveEffect) == "none"): saveEffect = "no"]
		[h, if (isNumber(saveEffect)): saveEffect = "(" + total + " * " + saveEffect + ")"]
		[h, if (saveEffect != ""): saveEffect = saveEffect + " damage" + if(saveEffectDamage == 0, "", " of " + saveEffectDamage); 
					saveEffect = saveEffectDamage + " damage"]
		[r, if (actionExecution): saveEffect = " If target save passes the target takes " + saveEffect]
		[h: saveable = dnd5e_RollExpression_getTypedDescriptor(exp, "saveable")]
		[r, if (!actionExecution): saveable = "<span title='" + tt + "' style='font: italic;'><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + saveable]
		</span><br>
	};{[h:""]}]
	[r, if (expressionType == SAVE_STEP_TYPE), code: {

		<!-- Actions create a separate target save object -->
		[h: saveDC = dnd5e_RollExpression_getSaveDC (exp)]
		[h: saveAgainst = json.get(exp, SAVE_AGAINST_FIELD)]
		[h, if (saveAgainst != ""): saveAgainst = " against " + dnd5e_Util_encodeHtml(saveAgainst)]
		[h: saveAbility = dnd5e_RollExpression_getSaveAbility (exp)]
		[h: save = "Target must make a DC " + saveDC + " " + saveAbility + " save" + saveAgainst]
		<span style='font: italic;'>&nbsp;&nbsp;[r:save]
		[h: name = dnd5e_RollExpression_getName(exp)]
		[r, if (name != ""): " for " + dnd5e_Util_encodeHtml(name)]
		</span><br>
	};{[h:""]}]
	[r, if (expressionType == SAVE_CONDITION_STEP_TYPE), code: {

		<!-- Actions can apply states to the target depending on an earlier save -->
		[h: saveResult = json.get(exp, SAVE_RESULT_FIELD) + "ed"]
		[h: saveConditions = json.toList(json.get(exp, SAVE_CONDITION_FIELD), ", ")]
		[h: condition = "If target save " + saveResult + " then apply these states on the target: "]
		<span style='font: italic;'>&nbsp;&nbsp;[r:condition]<b>[r:saveConditions]</b>
		[h: name = dnd5e_RollExpression_getName(exp)]
		[r, if (name != ""): " for " + dnd5e_Util_encodeHtml(name)]
		</span><br>
	};{[h:""]}]
	[r, if (expressionType == CONDITION_STEP_TYPE), code: {

		<!-- Actions can apply states to the token --->
		[h: saveConditions = json.toList(json.get(exp, SAVE_CONDITION_FIELD))]
		<span style='font: italic;'>&nbsp;&nbsp;Apply these states on the target:<b>[r:saveConditions]</b>
		[h: name = dnd5e_RollExpression_getName(exp)]
		[r, if (name != ""): " for " + dnd5e_Util_encodeHtml(name)]
		</span><br>	
	};{[h:""]}]
	[r, if (expressionType == TARGET_CHECK_STEP_TYPE), code: {

		<!-- Actions can apply states to the token --->
		[h: expression = dnd5e_Util_encodeHtml(dnd5e_RollExpression_getTargetCheck(exp))]
		[h: name = dnd5e_RollExpression_getName(exp)]
		[r, if (name != ""): name = " " + dnd5e_Util_encodeHtml(name)]
		<span style='font: italic;'>&nbsp;&nbsp;Check the target for[r:name]:<b>[r:expression]</b>
		</span><br>	
	};{[h:""]}]
	[h: log.debug("-----------------------------------------------------------------------")]
}]
[r, if(damageTotal != lastDamage): "<span style='font: bold 12px;'>" + damageTotal + "</span> Total damage"; ""]
  </div>
</div>