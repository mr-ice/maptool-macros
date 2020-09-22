[h: fieldId = arg(0) + "-" + arg(1)]
[h: value = arg(2)]
[h, if (value != ""): value = 'value="' + value + '"'; ""]
[h: stepClass = arg(3)]
<div class="col-4 form-group action-detail[r:stepClass]">
  <label for="[r:fieldId]-id">Save Effect:&nbsp;</label>
  <input type="text" id="[r:fieldId]-id" name="[r:fieldId]" class="form-control " [r:value] required
         data-toggle="tooltip" title="Enter how the damage is effected when a save is made. Valid values are half, none, or a number, usually less than 1">
</div>