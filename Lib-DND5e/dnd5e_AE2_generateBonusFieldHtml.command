[h: l_value = arg(0)]
[h, if (json.isEmpty(l_value)): l_value = ""; l_value = 'value="' + l_value + '"']
[h: out = json.append("[]", strformat('<div class="col-2 form-group action-detail%{stepClass}">'))]
[h: out = json.append(out, strformat('  <label for="%{rowId}-%{BONUS_FIELD}-id" style="margin-right:0px;">Bonus:&nbsp;</label>'))]
[h: out = json.append(out, strformat('  <input type="number" id="%{rowId}-%{BONUS_FIELD}-id" name="%{rowId}-%{BONUS_FIELD}" class="form-control" %{l_value} min="-99" max="99" placeholder="##" ')
                                     + 'required data-toggle="tooltip" title="Enter a number to be added to the die roll for this attack.">')]
[h: out = json.append(out, '</div>')]
[h: macro.return = json.toList(out, "")]