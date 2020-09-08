[h: fieldId = arg(0) + "-" + arg(1)]
[h: value = arg(2)]
[h, if (json.isEmpty(value)): value = ""; value = json.get(value, 0)]
[h: stepClass = arg(3)]
[h: damageTypes = arg(4)]
<div class="col-3 form-group action-detail [r:stepClass]" data-toggle="tooltip" title="Choose the type of damage to be applied to the target">
  <label for="[r:fieldId]-id">Type:&nbsp;</label>
  <select id="[r:fieldId]-id" name="[r:fieldId]" class="selectpicker" title="Choose type&hellip;" required>
    [r, foreach(damageType, damageTypes, "</option>"): "<option" + if(value == damageType, " selected", "") + ">" + damageType ]
  </select>
</div>