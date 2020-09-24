<!-- Check the parameters passed or grab the data fresh -->
[h: log.debug(getMacroName() + ": args=" + json.indent(macro.args))]
[h: activeIndex = if(argCount() > 0, arg(0), 0)] 
[h, if (argCount() > 1): workingCopy = arg(1); workingCopy = json.reverse(dnd5e_SavedAttacks_fetch())]
[h, if (json.isEmpty(workingCopy)), code: {
	[h: broadcast("Apply Attack Options; No Saved Attacks found", "gm")]
	[h: return(0, "")]	
}]
[h: active = json.get(workingCopy, activeIndex)]
[h, if (argCount() > 2): sIds = arg(2); sIds = getSelected("json")]
[h, if (argCount() > 3): selected = arg(3); selected = "[]"]
[h, if (json.isEmpty(selected)), code: {
	[h, for(i, 0, json.length(sIds)): selected = json.append(selected, "{}")]
}]
[h, if(json.isEmpty(sIds)), code: { 
	[h: broadcast("Apply Attack Options; No selected IDs", "gm")]
	[h: return(0, "")]
}; {""}]

<!-- Show the available attacks allow selection and set up modifiers -->
[h: processorLink = macroLinkText ("dnd5e_SavedAttacks_applyProcessor@Lib:DnD5e", "all")]
[dialog5 ("Saved Attacks", "title=Apply Attacks; input=0; width=1200; height=800; closebutton=0"): {
<!doctype html>
<html><head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <link rel="stylesheet" type="text/css" href="dnd5e_SavedAttacks_applyCSS@Lib:DnD5e"></link>
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-select@1.13.14/dist/css/bootstrap-select.min.css">
</head><body><div class="container-fluid">
<form action="[r:processorLink]" method="json" id="editor">

	<!-- Hidden fields -->
  <input type="hidden" name="hidden-working-copy" value="[r:encode(workingCopy)]">
  <input type="hidden" name="hidden-sIds" value="[r:encode(sIds)]">
  <input type="hidden" name="hidden-activeIndex" value="[r:activeIndex]">
  <input type="hidden" name="hidden-selected" value="[r:encode(selected)]">

  <h4><b>Actions</b></h4>
  <div class="form-container">
    <div class="form-row">
    
      <!-- Buttons used to choose an attack -->
      <div class="list-group col-3">
        [r, for(i, 0, json.length(workingCopy), 1, "</button>"), code: {
          [h: action = json.get(workingCopy, i)]
          [h: firstExp = json.get(action, 0)]
          [h: id = dnd5e_RollExpression_getTypedDescriptor(firstExp, "rollerId")]
          [h: actionName = dnd5e_RollExpression_getTypedDescriptor(firstExp, "actionName")]
          [h, if (actionName == ""): actionName = dnd5e_RollExpression_getName(firstExp)]
          [h: actionDesc = dnd5e_RollExpression_getTypedDescriptor(firstExp, "actionDesc")]
          [h: isActive = if(i == activeIndex, "active", "")]
          <button type="submit" class="list-group-item list-group-item-action [r:isActive]" 
                  data-toggle="tooltip" title="[r:actionDesc]" name="changeActive" value="[r:i]">
            <div class="row"> 
              <div class="col col-sm-auto" style="margin: 0px -18px"> 
                <img src="[r:getTokenImage(30, id)]"/> 
              </div>
              <div class="col"  style="margin: 0px -10px"> 
                [r:getName(id)] <b>[r:actionName]</b>
              </div>
            </div>
          </button>
        }]
      </div>
      
      <!-- The rolled attack -->
      <div class="col-9">
        [h: out = dnd5e_RollExpression_getFormattedOutput(active, 1)]
        [r: out]
      </div>
    </div>

	<!-- Start the table of targets -->
	<h4><b>Targets</b></h4>
	<table class="table table-borderless">
      [r, for(i, 0, json.length(sIds), 1, ""): dnd5e_SavedAttacks_targetRow(json.get(sIds, i), active, i, json.get(selected, i))]
	</table>

    <div class="btn-group offset-4 col-4">
      <button id="run" type="submit" class="btn btn-primary" name="control" value="run"
   	        data-toggle="tooltip" title="Apply the attack with the selected objects.">Apply</button>
      <button type="submit" class="btn btn-danger" name="control", value="exit" formnovalidate
    	  	data-toggle="tooltip" title="Exit without applying the attack.">Exit</button>
      <button type="submit" class="btn btn-warning" name="control", value="clear" formnovalidate
    	  	data-toggle="tooltip" title="Clear all of the saved attacks.">Clear</button>
    </div>
    
<!--  Fix this button as we go along -->
<br><button id="submit" type="submit" class="invisible btn btn-outline-primary" name="submit" value="1" style="margin-top:2px;">Submit</button>
  </div>
</form>

  <!-- Bootstrap required java script -->
  <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"></script>
  <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap-select@1.13.14/dist/js/bootstrap-select.min.js"></script>
  <script type="text/javascript">[r:getLibProperty("_AE2_JavaScript", "Lib:DnD5e")]</script>
</body></html>
}]