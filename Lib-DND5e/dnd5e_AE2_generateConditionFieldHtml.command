[h: fieldId = arg(0) + "-" + arg(1)]
[h: value = arg(2)]
[h: stepClass = arg(3)]
[h: stateGroups = arg(4)]
<div class="col-7 form-group action-detail [r:stepClass]" style="width:100%;">
  <label for="[r:fieldId]-id">States:&nbsp;</label>
  <select id="[r:fieldId]-id" name="[r:fieldId]" class="selectpicker" data-width="fit" multiple 
            title="Choose states&hellip;" data-header="Select States to Apply"  data-live-search="true">
    [r, foreach(group, stateGroups, "</optgroup>"), code : {
      [r: "<optgroup label='" + group + "'>"]
      [r, foreach(state, getTokenStates("json", group), "</option>"): "<option" + if(json.contains(value, state), " selected", "") + ">" + state]
    }]
  </select>
</div>