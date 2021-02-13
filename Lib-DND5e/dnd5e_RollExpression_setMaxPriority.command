[h: rollExpression = arg (0)]
[h: priority = arg (1)]
[h: rollExpression = json.set (rollExpression, "maxPriority", priority)]
[h: macro.return = rollExpression]