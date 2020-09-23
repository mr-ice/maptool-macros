[h: rollExpressions = arg (0)]
[h: msg = ""]
[h: total = 0]
[h, foreach (rollExpression, rollExpressions), code: {
	[totalRolls = dnd5e_RollExpression_getTotalRolls (rollExpression)]
	[if (!isNumber (totalRolls)): totalRolls = 1; ""]
	[if (totalRolls > 1), code: {
		[outputArry = dnd5e_RollExpression_getOutputs(rollExpression)]
		[total = total + dnd5e_RollExpression_getAllTotal (rollExpression)]
	}; {
		[outputArry = json.append ("", dnd5e_RollExpression_getOutput(rollExpression))]
	}]
	[foreach (output, outputArry): msg = msg + "<br><br>" + output]
}]
[h, if (total > 0): msg = msg + "<br><br>Total: " + total]
[h: macro.return = msg]