[h: json.toVars(dnd5e_AE2_getConstants())]
[h: log.debug(getMacroName() + ": args=" + json.indent(macro.args))]
[h: targetId = arg(0)]
[h: rolledExps = arg(1)]
[h: row = arg(2)]
[h, if (argCount() > 3): selected = arg(3); selected="{}"]
[h: rowBackgroundClass = "class='" + if(math.mod(row, 2) == 0, "even-row", "odd-row") + "'"]

<!-- Start the row with the target name and image -->
[h: rowName = "row-" + row + "="]
[h: applyKey = rowName + "-apply"]
[h, if (json.isEmpty(selected) || !json.contains(selected, "apply")): apply = "checked"; apply = if(json.get(selected, "apply"), "checked", "")]
<tr [r:rowBackgroundClass]>
  <th scope="row" style="text-align:left;">
    <div class="custom-control custom-checkbox custom-control-inline">
      <input type="checkbox" class="custom-control-input" name="[r:applyKey]" id="[r:applyKey]-id" value="[r:targetId]" [r:apply]>
      <label class="custom-control-label" for="[r:applyKey]-id"><img src="[r:getTokenImage(30, targetId)]"/> [r:getName(targetId)]</label>
    </div>
  </th>

<!-- Check each expression -->
[h: index = 0]
[h: counts = "{}"]
[r, for(i, 0, json.length(rolledExps), 1, ""), code: {
  [h: exp = json.get(rolledExps, i)]
  [h: expKey = "exp-" + i]
  [h: expName = rowName + expKey]

  <!-- Start a new row? And, get the count for a type -->
  [h: type = dnd5e_RollExpression_getExpressionType(exp)]
  [r, if (index > 0 && math.mod(index, 3) == 0): "<tr " + rowBackgroundClass + "><td></td>"; ""]
  [h: count = if(json.contains(counts, type), json.get(counts, type) + 1, 1)]
  [h: counts = json.set(counts, type, count)]
  [h: typeConstants = json.get(NAMES_OF_STEP_TYPES, type)]
  [h, if (json.contains(typeConstants, "applyHeader")): header = strformat(json.get(typeConstants, "applyHeader"), dnd5e_Util_ordinalPostfix(count))]
  
  <!-- Attacks need to check for cover -->
  [r, if (type == ATTACK_STEP_TYPE), code: {
    [h, if (json.isEmpty(selected) || !json.contains(selected, expKey)): expSelect = "no"; expSelect = json.get(selected, expKey)]
    [h: selectedNo = if(expSelect == "no", "checked", "")]
    [h: selectedHalf = if(expSelect == "half", "checked", "")]
    [h: selectedThreeQuarters = if(expSelect == "threeQuarters", "checked", "")]
    <td>[r:header]<br>
      <div class="form-check-inline">
        <div class="custom-control custom-radio custom-control-inline">
          <input class="custom-control-input" type="radio" name="[r:expName]" id="[r:expName]-no" value="no" [r:selectedNo]>
          <label class="custom-control-label" for="[r:expName]-no">No</label>
        </div>
        <div class="custom-control custom-radio custom-control-inline">
          <input class="custom-control-input" type="radio" name="[r:expName]" id="[r:expName]-half" value="half" [r:selectedHalf]>
          <label class="custom-control-label" for="[r:expName]-half">&frac12;</label>
        </div>
        <div class="custom-control custom-radio custom-control-inline">
          <input class="custom-control-input" type="radio" name="[r:expName]" id="[r:expName]-threeQuarters" value="threeQuarters" [r:selectedThreeQuarters]>
          <label class="custom-control-label" for="[r:expName]-threeQuarters">&frac34;</label>
        </div>
      </div>
    </td>
    [h: index = index + 1]
  };{[h: ""]}]

  <!-- Saves need to check for advantage -->
  [r, if (type == SAVE_STEP_TYPE), code: {
    [h, if (json.isEmpty(selected) || !json.contains(selected, expKey)): expSelect = "normal"; expSelect = json.get(selected, expKey)]
    [h: selectedNormal = if(expSelect == "normal", "checked", "")]
    [h: selectedAdvantage = if(expSelect == "advantage", "checked", "")]
    [h: selectedDisadvantage = if(expSelect == "disadvantage", "checked", "")]
    [h: selectedBoth = if(expSelect == "both", "checked", "")]
    <td>[r:header]<br>
      <div class="form-check-inline">
        <div class="custom-control custom-radio custom-control-inline">
          <input class="custom-control-input" type="radio" name="[r:expName]" id="[r:expName]-normal" value="normal" [r:selectedNormal]>
          <label class="custom-control-label" for="[r:expName]-normal">[r:dnd5e_Macro_getModLabel("normal", 0)]</label>
        </div>
        <div class="custom-control custom-radio custom-control-inline">
          <input class="custom-control-input" type="radio" name="[r:expName]" id="[r:expName]-advantage" value="advantage" [r:selectedAdvantage]>
          <label class="custom-control-label" for="[r:expName]-advantage">[r:dnd5e_Macro_getModLabel("advantage", 0)]</label>
        </div>
        <div class="custom-control custom-radio custom-control-inline">
          <input class="custom-control-input" type="radio" name="[r:expName]" id="[r:expName]-disadvantage" value="disadvantage" [r:selectedDisadvantage]>
          <label class="custom-control-label" for="[r:expName]-disadvantage">[r:dnd5e_Macro_getModLabel("disadvantage", 0)]</label>
        </div>
        <div class="custom-control custom-radio custom-control-inline">
          <input class="custom-control-input" type="radio" name="[r:expName]" id="[r:expName]-both" value="both" [r:selectedBoth]>
          <label class="custom-control-label" for="[r:expName]-both">[r:dnd5e_Macro_getModLabel("both", 0)]</label>
        </div>
      </div>
    </td>
    [h: index = index + 1]
  };{[h: ""]}]


  <!-- Saves need to check for advantage -->
  [r, if (type == DAMAGE_STEP_TYPE || type == SAVE_DAMAGE_STEP_TYPE), code: {
    [h, if (json.isEmpty(selected) || !json.contains(selected, expKey)): expSelect = "normal"; expSelect = json.get(selected, expKey)]
    [h: selectedNormal = if(expSelect == "normal", "checked", "")]
    [h: selectedResistance = if(expSelect == "resistance", "checked", "")]
    [h: selectedImmunity = if(expSelect == "immunity", "checked", "")]
    [h: selectedVulnerability = if(expSelect == "vulnerability", "checked", "")]
    <td>[r:header]<br>
      <div class="form-check-inline">
        <div class="custom-control custom-radio custom-control-inline">
          <input class="custom-control-input" type="radio" name="[r:expName]" id="[r:expName]-normal" value="normal" [r:selectedNormal]>
          <label class="custom-control-label" for="[r:expName]-normal" title="Normal" data-toggle="tooltip">&times;1</label>
        </div>
        <div class="custom-control custom-radio custom-control-inline">
          <input class="custom-control-input" type="radio" name="[r:expName]" id="[r:expName]-resistance" value="resistance" [r:selectedResistance]>
          <label class="custom-control-label" for="[r:expName]-resistance" title="Resistance" data-toggle="tooltip">&times;&frac12;</label>
        </div>
        <div class="custom-control custom-radio custom-control-inline">
          <input class="custom-control-input" type="radio" name="[r:expName]" id="[r:expName]-immunity" value="immunity" [r:selectedImmunity]>
          <label class="custom-control-label" for="[r:expName]-immunity" title="Immunity" data-toggle="tooltip">&times;0</label>
        </div>
        <div class="custom-control custom-radio custom-control-inline">
          <input class="custom-control-input" type="radio" name="[r:expName]" id="[r:expName]-vulnerability" value="vulnerability" [r:selectedVulnerability]>
          <label class="custom-control-label" for="[r:expName]-vulnerability" title="Vulnerability" data-toggle="tooltip">&times;2</label>
        </div>
      </div>
    </td>
    [h: index = index + 1]
  };{[h: ""]}]

  <!-- Conditions need to check for immunity -->
  [r, if (type == CONDITION_STEP_TYPE || type == SAVE_CONDITION_STEP_TYPE), code: {
    [h, if (json.isEmpty(selected) || !json.contains(selected, expKey)): expSelect = "Normal"; expSelect = json.get(selected, expKey)]
    [h: selectedNormal = if(expSelect == "normal", "checked", "")]
    [h: selectedImmunity = if(expSelect == "immunity", "checked", "")]
    <td>[r:header]<br>
      <div class="form-check-inline">
        <div class="custom-control custom-radio custom-control-inline">
          <input class="custom-control-input" type="radio" name="[r:expName]" id="[r:expName]-normal" value="normal" [r:selectedNormal]>
          <label class="custom-control-label" for="[r:expName]-normal">Normal</label>
        </div>
        <div class="custom-control custom-radio custom-control-inline">
          <input class="custom-control-input" type="radio" name="[r:expName]" id="[r:expName]-immunity" value="immunity" [r:selectedImmunity]>
          <label class="custom-control-label" for="[r:expName]-immunity">Immunity</label>
        </div>
      </div>
    </td>
    [h: index = index + 1]
  };{[h: ""]}]

  <!-- Finish an extra row -->
  [r, if (index > 0 && math.mod(index, 3) == 0): "</tr>"; ""]
}]
[r, while(math.mod(index, 3) != 0, ""), code: {
  <td></td>
  [h: index = index + 1]
}]
</tr>