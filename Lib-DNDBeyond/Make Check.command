
[h, if (json.length (macro.args) > 0), code: {
	[h: inputObj = arg (0)]
	[h: bonus = json.get (inputObj, "bonus")]
	[h: advDisadv = json.get (inputObj, "advDisadv")]
	[h: checkLabel = json.get (inputObj, "checkLabel")]
}; {
	<!-- "variableName|value|prompt|inputType|options" -->
	[h: abort (input (
		" checkLabel | A Check | Text ",
		" bonus | 0 | Check bonus | Text ",
		" advDisadv | None, Advantage, Disadvantage | Advantage / Disadvantage | List "))]
}]

[h: checkExpr = "1d20 + " + bonus]
[h: roll1 = eval (checkExpr)]
[h: roll2 = eval (checkExpr)]
[h: actual = roll1]
[h: atkString = "<b>" + checkLabel + "<br>" + checkExpr + "</b>: " + roll1]
[h, if (advDisadv == 1), code: {
	[h: atkString = atkString + "<br><b>Advantage:</b> " + roll2]
	[h: actual = max (roll1, roll2)]
}]
[h, if (advDisadv == 2), code: {
	[h: atkString = atkString + "<br><b>Disadvantage:</b> " + roll2]
	[h: actual = min (roll1, roll2)]	
}]
[h, if (advDisadv > 0): atkString = atkString + "<br><br><b>Actual:</b> " + actual]
[r: atkString]