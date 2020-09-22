[h: fieldId = arg(0) + "-" + arg(1)]
[h: value = arg(2)]
[h: stepClass = arg(3)]
[h: abilities = arg(4)]
<div class="col-3 form-group action-detail[r:stepClass]" data-toggle="tooltip" title="Choose the save to be made by the target.">
  <label for="[r:fieldId]-id">Ability:&nbsp;</label>
  <select id="[r:fieldId]-id" name="[r:fieldId]" class="selectpicker [r:stepClass]" title="Choose ability&hellip;" required>
    [r, foreach(ability, abilities, "</option>"): "<option" + if(value == ability, " selected", "") + ">" + ability]
  </select>
</div>