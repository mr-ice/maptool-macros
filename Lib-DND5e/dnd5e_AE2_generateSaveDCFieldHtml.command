[h: fieldId = arg(0) + "-" + arg(1)]
[h: value = arg(2)]
[h, if (value != ""): value = 'value="' + value + '"'; ""]
[h: stepClass = arg(3)]
<div class="col-sm-2 form-group action-detail[r:stepClass]">
  <label for="[r:fieldId]-id" style="margin-right:21px;">DC:&nbsp;</label>
  <input type="number" id="[r:fieldId]-id" name="[r:fieldId]" class="form-control " [r:value] min="-99" max="99" placeholder="##">
</div>