[h: rollExpression = arg (0)]
[h: propertyModifiers = json.get (rollExpression, "propertyModifiers")]
[h: proficient = dnd5e_RollExpression_getProficiency(rollExpression)]
[h: propertyModifier = "" + proficient + " * Proficiency"]
<!-- If its zero, just skip it -->
[h, if (propertyModifier != 0): propertyModifiers = json.append (propertyModifiers, propertyModifier); ""]
[h: macro.return = json.set (rollExpression, "propertyModifiers", propertyModifiers)]