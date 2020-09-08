[h: fieldId = arg(0) + "-" + arg(1)]
[h: value = arg(2)]
[h: stepClass = arg(3)]
[h: attacks =  json.fields(json.get(dndb_getBasicToon(), "attacks"))]
[h: log.debug("dnd5e_AE2_generateDndbAttackFieldHtml: fieldId=" + fieldId + " value=" + value + " stepClass=" + stepClass + " attacks=" + attacks)]
<div class="col-4 form-group action-detail[r:stepClass]" data-toggle="tooltip" title="Select an attack from those listed by DnD Beyond">
  <label for="[r:fieldId]-id">Attack:&nbsp;</label>
  <select id="[r:fieldId]-id" name="[r:fieldId]" class="selectpicker [r:stepClass]" title="Choose attack&hellip;" required onchange="changeType(this.value)">
    [r, foreach(attack, attacks, "</option>"): "<option" + if(replace(value, " ", "") == replace(attack, " ", ""), " selected", "") + ">" + attack]
  </select>
</div>