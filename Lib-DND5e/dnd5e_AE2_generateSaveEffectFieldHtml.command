[h: l_value = arg(0)]
[h, if (l_value != ""): l_value = 'value="' + l_value + '"']
[h: out = json.append("[]", strformat('<div class="col-4 form-group action-detail%{stepClass}">'))]
[h: out = json.append(out, strformat('  <label for="%{rowId}-%{SAVE_EFFECT_FIELD}-id">Save Effect:&nbsp;</label>'))]
[h: out = json.append(out, strformat('  <input type="text" id="%{rowId}-%{SAVE_EFFECT_FIELD}-id" name="%{rowId}-%{SAVE_EFFECT_FIELD}" class="form-control " %{l_value} required'
  	       						   + ' data-toggle="tooltip" title="Enter how the damage is effected when a save is made. Valid values are half, none, or a number, usually less than 1">'))]
[h: out = json.append(out, '</div>')]
[h: macro.return = json.toList(out, "")]