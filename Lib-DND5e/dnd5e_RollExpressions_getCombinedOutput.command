[h: rollExpressions = arg (0)]
[h: msg = ""]
[h, foreach (rollExpression, rollExpressions), code: {
	[h: msg = msg + "<br><br>" + json.get (rollExpression, "output")]
}]

[h: macro.return = msg]