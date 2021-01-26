[h: rollExpression = arg(0)]
[h: type = dnd5e_Type_Proficient()]
[h, if (!dnd5e_RollExpression_hasType (rollExpression, type)): 
		rollExpression = dnd5e_RollExpression_addType (rollExpression, type); ""]
[h: rollExpression = json.set (rollExpression, "proficient", arg(1))]
[h: macro.return = rollExpression]