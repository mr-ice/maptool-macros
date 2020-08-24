[h: rollExpression = arg (0)]

<!-- Build the output message -->
<!-- Simple for now -->
[h: expressionTypes = dnd5e_RollExpression_getExpressionType (rollExpression)]
[h, if (json.type (expressionTypes) == "ARRAY"): expressionTypes = json.toList (expressionTypes); ""]
[h: descriptor = expressionTypes + " Roll"]
[h: description = dnd5e_RollExpression_getDescription (rollExpression)]
[h, if (description != ""): description = description + "<br>"; ""]
[h: damageTypes = dnd5e_RollExpression_getDamageTypes (rollExpression)]
[h: damageTypeStr = json.toList (damageTypes)]
[h: name = dnd5e_RollExpression_getName (rollExpression)]
[h: rollString = dnd5e_RollExpression_getRollString (rollExpression)]
[h: total = dnd5e_RollExpression_getTotal (rollExpression)]
[h: roll = dnd5e_RollExpression_getRoll (rollExpression)]
[h: log.debug ("dnd5e_DiceRoller_basicRoll: damagetTypes = " + damageTypes + "; name = " + name)]
[h: output = description]
[h, if (isNumber (roll)): output = output + "Rolled: " + roll  + "<br>"; ""]
[h: output = output +  name + " " + descriptor + ": " + rollString + " = " + total + " " + damageTypeStr]

[h: macro.return = json.set (rollExpression, "output", output)]

