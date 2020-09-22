[h: fieldId = arg(0) + "-" + arg(1)]
[h: value = arg(2)]
[h, if (value != ""): value = 'value="' + value + '"'; ""]
[h: stepClass = arg(3)]
<div class="col-3 form-group action-detail[r:stepClass]">
  <label for="[r:fieldId]-id">Crit Die:&nbsp;</label>
  <input type="number" id="[r:fieldId]-id" name="[r:fieldId]" class="form-control " [r:value] min="1" max="99" placeholder="##"
  		 data-toggle="tooltip" title="Enter an optional number of extra dice to be added on a critical hit.">
</div>