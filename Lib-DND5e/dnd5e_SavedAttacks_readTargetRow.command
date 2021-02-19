[h: log.debug(getMacroName() + ": args=" + json.indent(macro.args))]
[h: form = arg(0)]
[h: targetId = arg(1)]
[h: rolledExps = arg(2)]
[h: row = arg(3)]
[h, if (argCount() > 4): selected = arg(4); selected="{}"]
[h: dnd5e_AE2_getConstants()]
[h: selected = json.set(selected, "id", targetId)]

<!-- Still applying to this token? -->
[h: rowName = "row-" + row + "="]
[h: selected = json.set(selected, "apply", json.contains(form, rowName + "-apply"))]

<!-- Handle Each Expression -->
[h, for(i, 0, json.length(rolledExps)), code: {
	[h: exp = json.get(rolledExps, i)]
	[h: expKey = "exp-" + i]
	[h: expName = rowName + expKey]
	[h: type = dnd5e_RollExpression_getExpressionType(exp)]
	[h: value = json.get(form, expName)]
	[h: selected = json.set(selected, expKey, value)]
}]
[h: log.debug(getMacroName() + ": selected=" + json.indent(macro.args))]
[h: macro.return = selected]