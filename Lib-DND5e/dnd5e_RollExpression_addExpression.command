[h: rollExpression = arg (0)]
[h: argsLength = json.length (macro.args)]
[h: children = "[]"]
[h, for (childIndex, 1, argsLength), code: {
	[h: children = json.append (children, json.get (macro.args, childIndex))]
}]
[h: macro.return = json.set (rollExpression, "expressions", children)]