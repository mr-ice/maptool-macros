<!-- Check for arguments read constants -->
[h: exp = arg(0)]
[h: log.debug("dnd5e_AE2_generateHeaderHtml: exp = " + json.indent(exp))]
[h: json.toVars(dnd5e_AE2_getConstants())]

<!-- Read the action name, type & desc from the first expression in the list -->
[h: actionName = dnd5e_Util_encodeHtml(dnd5e_RollExpression_getTypedDescriptor(exp, "actionName"))]
[h: actionDesc = dnd5e_Util_encodeHtml(dnd5e_RollExpression_getTypedDescriptor(exp, "actionDesc"))]
[h: newActionType = dnd5e_RollExpression_getTypedDescriptor(exp, "actionType"))]

<!-- Check for attacks -->
[h: disabled = "[]"]
[h: toon = getProperty("dndb_BasicToon")]
[h, if(json.isEmpty(toon)): attacks = ""; attacks = json.get(toon, "attacks")]
[h, if(json.isEmpty(attacks)): disabled = json.append(disabled, DNDB_ATTACK_TYPE); ""]
[h, if(json.isEmpty(toon)): spells = ""; spells = json.get(toon, "spells")]
[h, if(json.isEmpty(spells)): disabled = json.append(disabled, DNDB_SPELL_TYPE); ""]

<!-- Action name textfield -->
[h, if(actionName == ""): ""; actionName = " value='" + actionName + "'"]
<div class="form-row">
  <div class="col-9 form-group" data-toggle="tooltip" title="Title of the action and macro name">
    <label for="actionNameId">Action Name</label>
    <input type="text" name="actionName" class="form-control" id="actionNameId" ${actionName}>
  </div>

  <!-- Action type menu select -->
  <div class="col-3 form-group" data-toggle="tooltip" title="Action type determines starting steps." data-placement="top">
    <label for="actionTypeId">Action Type</label>
    <select id="actionTypeId" name="actionType" class="selectpicker" required, onchange="changeType(this.value)">
      [r, foreach(actionType, ACTION_TYPES, "</option>"): "<option" + if(newActionType == actionType, " selected", "") 
      			+ if(json.contains(disabled, actionType), " disabled", "") + ">" + actionType]
    </select>    
  </div>
</div> 

<!-- Description row -->
<div class="form-row">
  <div class="col form-group" data-toggle="tooltip" title="An optional description. Will be attached to the action name as a tool tip if provided.">
    <label for="actionDescId">Description</label>
    <textarea name="actionDesc" class="form-control" id="actionDescId">[r:actionDesc]</textarea>
  </div>
</div>

<!-- Action step header -->
<div class="form-row">
  <div class="col-sm form-group">
    <h4>Action Steps</h4>
  </div>
</div>