<!-- Before we do anything, validate we have the correct object version. Which means running more macros and clobbering the incoming args; save them first -->
[h: incomingArgs = macro.args]
<!-- Now validate -->
[h: versioned = dnd5e_AE2_assertVersion (0)]
[h, if (!versioned): dnd5e_AE2_upgradeActions(); ""]
<!-- Check the parameters passed -->
[h, if (json.length(incomingArgs) > 0): activeName = trim(arg(0)); activeName = ""]
[h, if (json.length(incomingArgs) > 1): id = arg(1); id = currentToken()]
[h: switchToken(id)]
[h, if (json.length(incomingArgs) > 2): exps = arg(2); exps = "[]"]
[h, if (json.length(incomingArgs) > 3): oldActionType = arg(3); oldActionType = ""]
[h, if (json.length(incomingArgs) > 4): newActionType = arg(4)]
[h, if (json.length(incomingArgs) > 5): workingCopy = arg(5); workingCopy = getProperty("_AE2_Actions")]
[h: dnd5e_AE2_getConstants()]
[h, if (json.length(incomingArgs) <= 4): newActionType = ATTACK_TYPE]
[h: log.debug("dnd5e_AE2_attackEditor: id=" + id + " newActionType = " + newActionType + " oldActionType = " + oldActionType 
			+ " activeName=" + activeName + " exps = " + json.indent(exps))]

<!-- Read editor related data -->
[h, if (json.isEmpty(workingCopy)), code: {
	<!-- First time edit -->
	[h: workingCopy = json.set("{}", "New Action", "[]")]
	[h: activeName = "New Action"]
}; {
	<!-- Retrieve a value from the working copy, check for valid name, assign one if not valid -->
	[h, if (json.isEmpty(activeName)): activeName = json.get(json.fields(workingCopy, "json"), 0)]
	[h: actionData = dnd5e_AE2_extractAction(workingCopy, activeName)]
	[h: log.debug("dnd5e_AE2_attackEditor: activeName=" + activeName + " workingCopy=" + json.fields(workingCopy) + " actionData = " + json.indent(actionData))]
	[h, if (!json.contains(workingCopy, activeName)), code: {
		[h: input("Error|The action named '" + activeName + "' does not exist. If an edit macro was used it has an old macro name.| |LABEL")]
		[h: activeName = json.get(json.fields(workingCopy, "json"), 0)]
		[h: actionData = dnd5e_AE2_extractAction(workingCopy, activeName)]
	}]
	[h, if (json.isEmpty(exps)): json.toVars(actionData)]
}]
[h, if (json.length(macro.args) > 6): metaData = arg(6); metaData = getProperty("_AE2_Metadata")]
[h, if (json.isEmpty(metaData)): macroFontColor = "white"; macroFontColor = json.get(metaData, "macroFontColor")]
[h, if (json.isEmpty(metaData)): macroBgColor = "red"; macroBgColor = json.get(metaData, "macroBgColor")]
[h, if (json.isEmpty(metaData)): metaData = json.set("{}", "macroBgColor", macroBgColor, "macroFontColor", macroFontColor)]
[h: log.debug("dnd5e_AE2_attackEditor: workingCopy=" + json.fields(workingCopy) + " metaData=" + json.indent(metaData))]

<!-- Handle a type change by deleting the old and adding the new, append old non action type steps -->
[h, if (newActionType == DNDB_ATTACK_TYPE): exps = dnd5e_AE2_typeDndbWeapon(oldActionType, exps); ""]
[h, if (newActionType == DNDB_SPELL_TYPE): exps = dnd5e_AE2_typeDndbSpell(oldActionType, exps); ""]
[h, if (newActionType == ATTACK_TYPE): exps = dnd5e_AE2_typeAttack(oldActionType, exps); ""]
[h, if (newActionType == SAVE_DAMAGE_TYPE): exps = dnd5e_AE2_typeSaveDamage(oldActionType, exps); ""]
[h, if (newActionType == DAMAGE_TYPE): exps = dnd5e_AE2_typeDamage(oldActionType, exps); ""]
[h, if (newActionType == SAVE_COND_TYPE): exps = dnd5e_AE2_typeSaveCondition(oldActionType, exps); ""]
[h, if (newActionType == COND_TYPE): exps = dnd5e_AE2_typeCondition(oldActionType, exps); ""]
[h, if (newActionType == FREE_FORM_TYPE): exps = dnd5e_AE2_typeFreeForm(oldActionType, exps); ""]
[h: log.debug("dnd5e_AE2_attackEditor fixed exps = " + json.indent(exps))]

<!-- don't allow 2 attacks or 2 saves in a row -->
[h: lastExp = json.get(exps, json.length(exps) - 1)]
[h: log.debug("lastExp = " + json.indent(lastExp))]
[h: attackDisabled = if(dnd5e_RollExpression_getExpressionType(lastExp) == ATTACK_STEP_TYPE, "disabled", "")]
[h: saveDisabled = if(dnd5e_RollExpression_getExpressionType(lastExp) == SAVE_STEP_TYPE, "disabled", "")]

<!-- Need a save before you can add a save damage or save condition -->
[h: hasSave = 0]
[h, foreach(exp, exps, ""): hasSave = hasSave + if(dnd5e_RollExpression_getExpressionType(exp) == SAVE_STEP_TYPE, 1, 0)]
[h: saveNeededDisabled = if(hasSave, "", "disabled")]

<!-- No advantage/disadvantage runs allowed if no attack -->
[h: hasAttack = 0]
[h, foreach(exp, exps, ""): hasAttack = hasAttack + if(dnd5e_RollExpression_getExpressionType(exp) == ATTACK_STEP_TYPE, 1, 0)]
[h: runAdvDisadvDisabled = if(hasAttack, "", "disabled")]

<!-- The expression returned to from the type functions is returned to the editor --><!-- Start the form html with bootstrap and hidden fields -->
[h: state = json.set("{}", "attack", 0, "save", 0, "check", 0)]
[h: processorLink = macroLinkText ("dnd5e_AE2_processor@Lib:DnD5e", "all", "", id)]
[dialog5 ("Attack Editor 2", "title=Action Editor; input=0; width=1200; height=800; closebutton=0"): {
<!doctype html>
<html><head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <link rel="stylesheet" type="text/css" href="dnd5e_AE2_CSS@Lib:DnD5e"></link>
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-select@1.13.14/dist/css/bootstrap-select.min.css">
</head><body><div class="container-fluid">

<form action="[r:processorLink]" method="json" id="editor">
  <ul class="nav nav-tabs">
    [r, foreach(action, json.fields(workingCopy), ""): "<li class='nav-item'><button type='submit' class='nav-link " 
    		+ if(activeName == action, "active", "") + "' name='chooseAction' value='"	+ action + "'
    		>" + action + "</button></li>"]
  </ul>  
  <div class="form-container">

    <!-- Generate the header fields and fill the values from the first expression -->
    [r: dnd5e_AE2_generateHeaderHtml(json.get(exps, 0))]

    <!-- Generate the step form rows -->
    [r, for(index, 0, json.length(exps), 1, ""), code: {
    	[h: workingExp = json.get(exps, index)]
		[h: indicators = json.get(json.get(NAMES_OF_STEP_TYPES, dnd5e_RollExpression_getExpressionType(workingExp)), "indicators")]
		[h, if(json.contains(indicators, "attack")): state = json.set(state, "attack", json.get(state, "attack") + 1)]
		[h, if(json.contains(indicators, "save")): state = json.set(state, "save", json.get(state, "save") + 1)]
		[h, if(json.contains(indicators, "check")): state = json.set(state, "check", json.get(state, "check") + 1)]
    	[r: dnd5e_AE2_generateStepHtml(workingExp, index, state, json.length(exps))]
    }]

  	<!-- Hidden fields -->
    <input type="hidden" name="hidden-id" value="[r:id]">
    <input type="hidden" name="hidden-exps" value="[r:encode(exps)]">
    <input type="hidden" name="hidden-working-copy" value="[r:encode(workingCopy)]">
    <input type="hidden" name="hidden-meta-data" value="[r:encode(metaData)]">
    <input type="hidden" name="hidden-active-name" value="[r:encode(activeName)]">

    <!-- Group of buttons to add more steps -->
    <div class="btn-group form-row col-12">
      <button type="submit" class="btn btn-secondary" name="addStep", value="[r:ATTACK_STEP_TYPE]" [r:attackDisabled] formnovalidate
      		data-toggle="tooltip" title="Add a new attack step to the action">Attack</button>
      <button type="submit" class="btn btn-secondary" name="addStep", value="[r:DAMAGE_STEP_TYPE]" formnovalidate
      		data-toggle="tooltip" title="Add a damage step to the action">Damage</button>
      <button type="submit" class="btn btn-secondary" name="addStep", value="[r:DRAIN_STEP_TYPE]" formnovalidate
      		data-toggle="tooltip" title="Add an ability drain step to the action">Drain</button>
      <button type="submit" class="btn btn-secondary" name="addStep", value="[r:SAVE_STEP_TYPE]" [r:saveDisabled] formnovalidate
      		data-toggle="tooltip" title="Add a target save step to the action">Save</button>
      <button type="submit" class="btn btn-secondary" name="addStep", value="[r:SAVE_DAMAGE_STEP_TYPE]" [r:saveNeededDisabled] formnovalidate
      		data-toggle="tooltip" title="Add a damage step that is modified by the target's saving throw">Save Damage</button>
      <button type="submit" class="btn btn-secondary" name="addStep", value="[r:SAVE_CONDITION_STEP_TYPE]" [r:saveNeededDisabled] formnovalidate
      		data-toggle="tooltip" title="Add a condition step that is modified by the target's saving throw">Save Condition</button>
      <button type="submit" class="btn btn-secondary" name="addStep", value="[r:SAVE_DRAIN_STEP_TYPE]" [r:saveNeededDisabled] formnovalidate
      		data-toggle="tooltip" title="Add a drain step that is eliminated by the target's saving throw">Save Drain</button>
      <button type="submit" class="btn btn-secondary" name="addStep", value="[r:CONDITION_STEP_TYPE]" formnovalidate
      		data-toggle="tooltip" title="Add a condition step">Condition</button>
      <button type="submit" class="btn btn-secondary" name="addStep", value="[r:TARGET_CHECK_STEP_TYPE]" formnovalidate
      		data-toggle="tooltip" title="Add a target check step.">Target Check</button>
    </div>
    
    <div class="btn-group offset-2 col-8">
      <button type="submit" class="btn btn-primary" name="control", value="new" style="margin-left:-17"
	      	data-toggle="tooltip" title="Create a new action.">New</button>
      <button type="submit" class="btn btn-primary" name="control", value="save"
	      	data-toggle="tooltip" title="Save all changes made to any action.">Save</button>
      <button type="submit" class="btn btn-primary" name="control", value="duplicate"
	      	data-toggle="tooltip" title="Make a new action from a copy of this action">Duplicate</button>
      <button type="submit" class="btn btn-success" name="control", value="run-Normal"
      		data-toggle="tooltip" title="Run the action after saving all changes.">Run</button>
      <button type="submit" class="btn btn-success" name="control", value="run-Advantage" [r:runAdvDisadvDisabled]
    	  	data-toggle="tooltip" title="Run the action with advantage after saving all changes.">&#x23eb;</button>
      <button type="submit" class="btn btn-success" name="control", value="run-Disadvantage" [r:runAdvDisadvDisabled]
	      	data-toggle="tooltip" title="Run the action with disadvantage after saving all changes.">&#x23ec;</button>
      <button type="submit" class="btn btn-success" name="control", value="run-Both" [r:runAdvDisadvDisabled]
      		data-toggle="tooltip" title="Run the action ignoring advantage & disadvantage after saving all changes.">&#x23eb;&#x23ec;</button>
      <button type="submit" class="btn btn-danger" name="control", value="delete" formnovalidate
            data-toggle="tooltip" title = "Delete this action. When the last action is deleted a new one is created to replace it.">
    	  	Delete</button>
      <button type="submit" class="btn btn-danger" name="control", value="exit" formnovalidate
    	  	data-toggle="tooltip" title="Exit the editor ignoring all changes.">Exit</button>
    </div>
    <div class="form-row form-inline">
      <button type="submit" class="btn btn-info offset-2" name="control", value="macro"
	      	data-toggle="tooltip" title="Build a macro for this action.">Create Macro</button>
      <div class="form-inline col-3 form-group" style="margin-right:5;">
	    <label for="macro-font-color-id">Macro Font:&nbsp;</label>
        <select id="macro-font-color-id" name="macro-font-color" class="selectpicker" title="Choose color&hellip;" data-width="130px">
          [r, foreach(color, json.fields(MACRO_COLORS), "</option>"): "<option"  + if(macroFontColor == color, " selected", "") 
          			+ " value='" + color + "'>" + json.get(MACRO_COLORS, color)]
        </select>
      </div> 
      <div class="form-inline col-3 form-group" style="margin-right:5;">
	    <label for="macro-bg-color-id">Macro Background:&nbsp;</label>
        <select id="macro-bg-color-id" name="macro-bg-color" class="selectpicker" title="Choose color&hellip;" data-width="130px">
          [r, foreach(color, json.fields(MACRO_COLORS), "</option>"): "<option"  + if(macroBgColor == color, " selected", "") 
          			+ " value='" + color + "'>" + json.get(MACRO_COLORS, color)]
        </select>
      </div> 
    </div>
    
	<!--  This button is hidden and used to submit the autmatic process somponents -->
	<button id="submit" type="submit" class="invisible btn btn-outline-primary" name="submit" value="1" style="margin-top:2px;" formnovalidate>Submit</button>
  </div>
</form>
</div>

  <!-- Bootstrap required java script -->
  <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"></script>
  <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap-select@1.13.14/dist/js/bootstrap-select.min.js"></script>
  <script type="text/javascript">[r:getLibProperty("_AE2_JavaScript", "Lib:DnD5e")]</script>
</body></html>
}]