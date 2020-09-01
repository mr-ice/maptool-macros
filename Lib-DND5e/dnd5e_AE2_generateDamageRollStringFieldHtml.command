[h: fieldId = arg(0) + "-" + arg(1)]
[h: value = arg(2)]
[h, if (value != ""): value = 'value="' + value + '"'; ""]
[h: stepClass = arg(3)]
[h: p = "^\\s*[1-9]\\d*d[1-9]\\d*\\s*([+|-]\\s*[1-9]\\d*)?\\s*\$"]
<div class="col-2 form-group action-detail[r:stepClass]">
  <label for="[r:fieldId]-id" style="margin-right:15px;">Roll:&nbsp;</label>
  <input type="text" id="[r:fieldId]-id" name="[r:fieldId]" class="form-control " [r:value] pattern="[r:p]" placeholder="#d#+|-#", style="width:100;">
</div>
