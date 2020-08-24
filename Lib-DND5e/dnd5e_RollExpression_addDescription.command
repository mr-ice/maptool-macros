[h: rollExpression = arg (0)]
[h: candidateDescription = arg (1)]
[h: currentDescription = dnd5e_RollExpression_getDescription (rollExpression)]
[h: descriptionIdx = listFind (currentDescription, candidateDescription, "<br>")]

[h, if (descriptionIdx < 0), code: {
	[if (currentDescription != ""): currentDescription = currentDescription + "<br>"; ""]
	[currentDescription = currentDescription + candidateDescription]
}; {""}]

[h: macro.return = dnd5e_RollExpression_setDescription (rollExpression, currentDescription)]