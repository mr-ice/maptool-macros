[h: fieldId = arg(0) + "-" + arg(1)]
[h: value = dnd5e_Util_encodeHtml(arg(2))]
[h, if (value != ""): value = 'value="' + value + '"']
[h: stepClass = arg(3)]
<div class="col-9 form-group action-detail[r:stepClass]">
  <label for="[r:fieldId]-id">Expression:&nbsp;</label>
  <input type="text" id="[r:fieldId]-id" name="[r:fieldId]" class="form-control " [r:value] style="width:85%;">
</div>