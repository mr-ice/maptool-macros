[h: l_value = arg(0)]
[h: l_attacks =  json.fields(json.get(dndb_getBasicToon(), "attacks"))]
[h: out = json.append("[]", strformat('<div class="col-4 form-group action-detail%{stepClass}" data-toggle="tooltip" title="Select an attack from those listed by DnD Beyond">'))]
[h: out = json.append(out, strformat('  <label for="%{rowId}-%{DNDB_ATTACK_FIELD}-id">Attack:&nbsp;</label>'))]
[h: out = json.append(out, strformat('  <select id="%{rowId}-%{DNDB_ATTACK_FIELD}-id" name="%{rowId}-%{DNDB_ATTACK_FIELD}" class="selectpicker %{stepClass}" title="Choose attack&hellip;"'
									+ ' required onchange="changeType(this.value)">'))]
[h, foreach(l_attack, l_attacks), code: {
	[h: l_selected = if(replace(l_value, " ", "") == replace(l_attack, " ", ""), " selected", "")]
	[h: out = json.append(out, strformat('<option %{l_selected}>%{l_attack}</option>'))]
}]
[h: out = json.append(out, '  </select>')]
[h: out = json.append(out, '</div>')]
[h: macro.return = json.toList(out, "")]