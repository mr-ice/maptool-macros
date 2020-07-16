[h: rollExpressions = arg (0)]
[h: expressionType = arg (1)]

[h: foundExpression = ""]
[h, foreach (rollExpression, rollExpressions), code: {
	[h, if (dnd5e_RollExpression_hasType (rollExpression, expressionType) && encode (foundExpression) == ""): foundExpression = rollExpression; ""]
}]
[h: macro.return = foundExpression]