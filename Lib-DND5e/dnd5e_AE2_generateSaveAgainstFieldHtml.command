[h: l_value = arg(0)]
[h, if (!json.isEmpty(l_value)): l_value = 'value="' + l_value + '"']
[h: out = json.append("[]", strformat('<div class="col-4 form-group action-detail%{stepClass}">'))]
[h: out = json.append(out, strformat('  <label for="%{rowId}-%{SAVE_AGAINST_FIELD}-id">Against:&nbsp;</label>'))]
[h: out = json.append(out, strformat('  <input type="text" id="%{rowId}-%{SAVE_AGAINST_FIELD}-id" name="%{rowId}-%{SAVE_AGAINST_FIELD}" class="form-control " %{l_value}'
  		                           + 'data-toggle="tooltip" title="Enter an optional list of values that can help determine advantage and disadvantage on saves by the target.">'))]
[h: out = json.append(out, '</div>')]
[h: macro.return = json.toList(out, "")]