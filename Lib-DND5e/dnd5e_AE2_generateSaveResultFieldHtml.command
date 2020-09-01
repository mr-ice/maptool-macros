[h: fieldId = arg(0) + "-" + arg(1)]
[h: value = arg(2)]
[h, if (value == ""): value = "fail"; ""]
[h: valuePass = if(value == "pass", "checked", "")]
[h: valueFail = if(value == "fail", "checked", "")]
[h: stepClass = arg(3)]
[h: log.debug("dnd5e_AE2_generateSaveResultFieldHtml: fieldId=" + fieldId + " value=" + arg(2) + " valuePass=" + valuePass + " valueFail=" + valueFail)]
<div class="form-group custom-control custom-radio col-1">
  <input class="custom-control-input" type="radio" name="[r:fieldId]" id="[r:fieldId]-id" value="pass" [r:valuePass]>
  <label class="custom-control-label" for="[r:fieldId]-id">Pass</label>
</div>
<div class="form-group custom-control custom-radio col-1">
  <input class="custom-control-input" type="radio" name="[r:fieldId]" id="[r:fieldId]-id2" value="fail" [r:valueFail]>
  <label class="custom-control-label" for="[r:fieldId]-id2">Fail</label>
</div>
