[h: rollString = arg (0)]
<!-- Careful not to expand property values yet -->
<!-- But since Ive improved my MT regex skills since the last time I was here, lets
     revisit this nonsense. In fact, in o5e Im pretty sure I wrote a pretty solid pattern for this -->
[h, if (json.length (macro.args) > 1): rollExpression = arg (1); rollExpression = "{}"]
[h: rollObj = dnd5e_Util_parseRollString (rollString)]
[h: diceSize = json.get (rollObj, "diceSize")]
[h: diceRolled = json.get (rollObj, "diceRolled")]
[h: bonus = json.get (rollObj, "bonus")]
[h: rollExpression = json.set (rollExpression, "diceSize", diceSize,
								"diceRolled", diceRolled,
								"bonus", bonus)]
<!-- ensure it has the Basic Type -->
[h: rollExpression = dnd5e_RollExpression_addType (rollExpression, dnd5e_Type_Basic())]
[h: macro.return = rollExpression]