[h: fieldId = arg(0) + "-" + arg(1)]
[h: value = arg(2)]
[h: stepClass = arg(3)]
[h: stateGroups = arg(4)]
<div class="col-7 form-group action-detail [r:stepClass]" style="width:100%;" data-toggle="tooltip" 
		title="Choose up to 4 conditions or states to be applied to the target.">
  <label for="[r:fieldId]-id">States:&nbsp;</label>
  <select id="[r:fieldId]-id" name="[r:fieldId]" class="selectpicker w-75" data-width="auto" multiple required
            title="Choose states&hellip;" data-header="Select States to Apply"  data-live-search="true">
    [r, foreach(group, stateGroups, "</optgroup>"), code : {
      [r: "<optgroup label='" + group + "'>"]
      [r, foreach(state, getTokenStates("json", group), "</option>"): "<option" + if(json.contains(value, state), " selected", "") + ">" + state]
    }]
  </select>
</div>