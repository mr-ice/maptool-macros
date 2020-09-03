[h: exp = arg(0)]
[h: index = arg(1)]
[h: state = arg(2)]
[h: json.toVars(dnd5e_AE2_getConstants())]
[h: rowId = "row-" + index]

<!-- Create a type name from the type and the subtypes -->
[h: type = dnd5e_RollExpression_getExpressionType(exp)]
[h: log.debug("dnd5e_AE2_generateStepHtml: index = " + index + " type=" + type + " rowId=" + rowId + " exp = " + json.indent(exp))]

<!-- Get the classes asscociated actionType expressions -->
[h: actionType = dnd5e_RollExpression_getTypedDescriptor(exp, "actionType")]
[h, if (actionType != "" && actionType != FREE_FORM_TYPE), code: {
	[h: rowClass = " row-actionType"]
	[h: stepNameClass = " step-name list-group-item-primary action-type"]
	[h: stepClass = " step-actionType"]
};{
	[h: rowClass = ""]
	[h: stepNameClass = " step-name list-group-item-dark"]
	[h: stepClass = ""]
}]

<!-- processing indicators -->
[h: tooltipKey = "tooltip"]
[h: stepData = json.get(NAMES_OF_STEP_TYPES, type)]
[h: indicators = json.get(stepData, "indicators")]
[h: indicatorOut = " "]
[h: hitNeeded = if(json.contains(indicators, "hit") && json.get(state, "attack") > 0, 1, 0)]
[h, if(hitNeeded), code: {
	[h, if(json.get(state, "attack") > 1): text = "on #" + json.get(state, "attack") + " hit"; text = "on hit"]
	[h: indicatorOut = indicatorOut + '<span style="margin-left:2;" class="badge badge-danger">' + text + '</span>']
[h: tooltipKey = "tooltip-hit"]
}]
[h: saveNeeded = if(json.contains(indicators, "onSave") && json.get(state, "save") > 0, 1, 0)]
[h, if(saveNeeded), code: {
	[h, if(json.get(state, "save") > 1): text = "on #" + json.get(state, "save") + " save"; text = "on save"]
	[h: indicatorOut = indicatorOut + '<span style="margin-left:2;" class="badge badge-primary">' + text + '</span>']
}]
[h: checkNeeded = if(json.contains(indicators, "onCheck") && json.get(state, "check") > 0, 1, 0)]
[h, if(checkNeeded), code: {
	[h, if(json.get(state, "check") > 1): text = "on #" + json.get(state, "check") + " check"; text = "on check"]
	[h: indicatorOut = indicatorOut + '<span style="margin-left:2;" class="badge badge-warning">' + text + '</span>']
}]
[h: log.debug("dnd5e_AE2_generateStepHtml: indicators=" + indicators + " hit=" + json.contains(indicators, "hit") 
				+ " save=" + json.contains(indicators, "onSave") + " check=" + json.contains(indicators, "check")
				+ " indicatorOut=" + indicatorOut + " state=" + json.indent(state))]

<!-- Build the row -->
<div class="form-row form-inline step-row [r:rowClass]">

  <!-- Then the step column -->
  <div class="col-2 form-group action-name[r:stepNameClass]" title="[r:json.get(stepData, tooltipKey)]" data-toggle="tooltip">
    [r:json.get(stepData, "name") + indicatorOut]
  </div> 

<!-- Build the other columns by type -->
[r, if(type == ATTACK_STEP_TYPE), code: {
	[r: dnd5e_AE2_generateBonusFieldHtml(rowId, BONUS_FIELD, dnd5e_RollExpression_getBonus(exp), stepClass)]
}; {[h:""]}]
[r, if(type == DAMAGE_STEP_TYPE), code: {
	[r: dnd5e_AE2_generateDamageRollStringFieldHtml(rowId, ROLL_STRING_FIELD, dnd5e_RollExpression_getRollString(exp), stepClass)]
	[r: dnd5e_AE2_generateDamageTypeFieldHtml(rowId, DAMAGE_TYPE_FIELD, dnd5e_RollExpression_getDamageTypes(exp), stepClass, DAMAGE_TYPES)]
}; {[h:""]}]
[r, if(type == DNDB_ATTACK_STEP_TYPE), code: {
	[r: dnd5e_AE2_generateDndbAttackFieldHtml(rowId, DNDB_ATTACK_FIELD, dnd5e_RollExpression_getName(exp), stepClass)]
}; {[h:""]}]
[r, if(type == DNDB_SPELL_STEP_TYPE), code: {
	[r: dnd5e_AE2_generateDndbSpellFieldHtml(rowId, DNDB_SPELL_FIELD, dnd5e_RollExpression_getName(exp), stepClass)]
	[r: dnd5e_AE2_generateDndbSpellLevelFieldHtml(rowId, DNDB_SPELL_LEVEL_FIELD, json.get(exp, "spellLevel"), stepClass, dnd5e_RollExpression_getName(exp))]
}; {[h:""]}]
[r, if(type == SAVE_STEP_TYPE), code: {
	[r: dnd5e_AE2_generateSaveDCFieldHtml(rowId, DC_FIELD, dnd5e_RollExpression_getSaveDC(exp), stepClass)]
	[r: dnd5e_AE2_generateSaveAbilityFieldHtml(rowId, SAVE_ABILITY_FIELD, dnd5e_RollExpression_getSaveAbility(exp), stepClass, CHAR_ABILITIES)]
	[r: dnd5e_AE2_generateSaveAgainstFieldHtml(rowId, SAVE_AGAINST_FIELD, json.get(exp, SAVE_AGAINST_FIELD), stepClass)]
}; {[h:""]}]
[r, if(type == SAVE_DAMAGE_STEP_TYPE), code: {
	[r: dnd5e_AE2_generateDamageRollStringFieldHtml(rowId, ROLL_STRING_FIELD, dnd5e_RollExpression_getRollString(exp), stepClass)]
	[r: dnd5e_AE2_generateDamageTypeFieldHtml(rowId, DAMAGE_TYPE_FIELD, dnd5e_RollExpression_getDamageTypes(exp), stepClass, DAMAGE_TYPES)]
	[r: dnd5e_AE2_generateSaveEffectFieldHtml(rowId, SAVE_EFFECT_FIELD, dnd5e_RollExpression_getSaveEffect(exp), stepClass)]
}; {[h:""]}]
[r, if(type == SAVE_CONDITION_STEP_TYPE), code: {
	[r: dnd5e_AE2_generateSaveResultFieldHtml(rowId, SAVE_RESULT_FIELD, json.get(exp, SAVE_RESULT_FIELD), stepClass)]
	[r: dnd5e_AE2_generateConditionFieldHtml(rowId, SAVE_CONDITION_FIELD, json.get(exp, SAVE_CONDITION_FIELD), stepClass, STATE_GROUPS)]
}; {[h:""]}]
[r, if(type == CONDITION_STEP_TYPE), code: {
	[r: dnd5e_AE2_generateConditionFieldHtml(rowId, SAVE_CONDITION_FIELD, json.get(exp, SAVE_CONDITION_FIELD), stepClass, STATE_GROUPS)]
}; {[h:""]}]
[r, if(type == TARGET_CHECK_STEP_TYPE), code: {
	[r: dnd5e_AE2_generateTargetCheckFieldHtml(rowId, TARGET_CHECK_FIELD, dnd5e_RollExpression_getTargetCheck(exp), stepClass)]
}; {[h:""]}]

  <!-- Place the delete & extended buttons at the end of the row -->
  <div class="flex-grow-1"> 
    <button type="submit" class="float-right btn btn-outline-danger" name="deleteStep" value="[r:index]" style="margin-top:2px;width:40;" 
    	data-toggle="tooltip" title="Delete this step">X</button>
    [h: extended = dnd5e_RollExpression_getTypedDescriptor(exp, "extendedValues")]
	[h, if (extended == ""): extended = "+"]
	[h, if (extended == "+"): title = "Show extended fields."; title = "Hide extended fields and erase them."]
    [r, if (type != DNDB_ATTACK_STEP_TYPE && type != DNDB_SPELL_STEP_TYPE), code: { 
      <button type="submit" class="float-right btn btn-outline-info" name="extendStep" value="[r:index]-[r:extended]" 
              style="margin-top:2px;margin-right:2px;width:40;" data-toggle="tooltip" title="[r:title]">[r:extended]</button>
    }]
  </div>

</div>

<!-- Generate the second row for extended values -->
[r, if(extended == "-"), code: {
	<!-- Build the extended row -->
	<div class="form-row form-inline [r:rowClass]">
      [r: dnd5e_AE2_generateExtendedNameFieldHtml(rowId, NAME_FIELD, dnd5e_RollExpression_getName(exp), stepClass)]
      [r, if(dnd5e_RollExpression_hasType(exp, "critable")): 
            dnd5e_AE2_generateExtendedCritFieldHtml(rowId, ON_CRITICAL_FIELD, dnd5e_RollExpression_getOnCritAdd(exp), stepClass); ""]
	</div>
}; {[h:""]}]