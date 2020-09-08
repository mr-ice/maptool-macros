[h: fieldId = arg(0) + "-" + arg(1)]
[h: value = arg(2)]
[h, if (value != ""): value = 'value="' + value + '"'; ""]
[h: stepClass = arg(3)]
<div class="col-3 form-group action-detail[r:stepClass]">
  <label for="[r:fieldId]-id" style="margin-right:0px;">Bonus:&nbsp;</label>
  <input type="number" id="[r:fieldId]-id" name="[r:fieldId]" class="form-control " [r:value] min="-99" max="99" placeholder="##" required
      data-toggle="tooltip" title="Enter a number to be added to the die roll for this attack.">
</div>