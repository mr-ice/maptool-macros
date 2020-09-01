[h: fieldId = arg(0) + "-" + arg(1)]
[h: value = arg(2)]
[h, if (value != ""): value = 'value="' + value + '"'; ""]
[h: stepClass = arg(3)]
<div class="col-4 form-group action-detail[r:stepClass]">
  <label for="[r:fieldId]-id">Against:&nbsp;</label>
  <input type="text" id="[r:fieldId]-id" name="[r:fieldId]" class="form-control " [r:value]>
</div>  