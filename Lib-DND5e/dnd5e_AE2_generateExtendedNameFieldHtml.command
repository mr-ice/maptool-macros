[h: fieldId = arg(0) + "-" + arg(1)]
[h: value = arg(2)]
[h, if (value != ""): value = 'value="' + value + '"'; ""]
[h: stepClass = arg(3)]
<div class="offset-2 col-4 form-group action-detail[r:stepClass]">
  <label for="[r:fieldId]-id">Name:&nbsp;</label>
  <input type="text" id="[r:fieldId]-id" name="[r:fieldId]" class="form-control " [r:value]
  		 data-toggle="tooltip" title="Enter an optional name that is displayed with the step in chat.">
</div>